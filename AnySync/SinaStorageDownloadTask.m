//
//  SinaStorageDownloadTask.m
//  AnySync
//
//  Created by CmST0us on 17/5/30.
//  Copyright © 2017年 CmST0us. All rights reserved.
//

#import "SinaStorageDownloadTask.h"
#import "FileDownloader.h"
#import "ERS3ObjectRequest.h"
#import "DownloadTask.h"

@interface SinaStorageDownloadTask () {
    NSString *_downloadFilePath;
    ERS3ObjectRequest *_objectRequest;
}

@end

@implementation SinaStorageDownloadTask


#pragma mark - 初始化方法
- (instancetype)init {
    self = [super init];
    if (self) {
        _downloadFilePath = NULL;
        _objectRequest = [[ERS3ObjectRequest alloc] initWithBaseUrl:kERS3DownloadApiDomain bucketName:@"com.cmst0us.anysync.bucket"];
        _downloadDestination = NULL;
    }
    return self;
}

#pragma mark - 类方法
+ (instancetype)downloadTaskWithFilePath:(NSString *)path {
    SinaStorageDownloadTask *downloadTask = [[SinaStorageDownloadTask alloc] init];
    [downloadTask setDownloadTaskWithFilePath:path];
    return downloadTask;
}

#pragma mark - 实例方法
- (void)setDownloadTaskWithFilePath:(NSString *)path {
    _downloadFilePath = [path copy];
}

- (void)doDownload {
    [_objectRequest downloadWithPath:_downloadFilePath range:@"" progress:^(NSProgress *downloadProgress) {
        //不需要向下载器汇报，下载器定时回调轮询
        _downloadProgress = [downloadProgress fractionCompleted];
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        if (_downloadDestination == NULL) {
            _downloadDestination = [targetPath absoluteString];
        }
        return [NSURL URLWithString:_downloadDestination];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        //向下载器报告完成
        [[NSNotificationCenter defaultCenter] postNotificationName:(NSString *)kDownloadTaskFinishNotification object:NULL userInfo:@{kDownloadTaskIdKey: _taskId,
                                                                                                                                      kDownloadTaskFilePathKey: filePath,
                                                                                                                                      kDownloadTaskErrorKey: error,
                                                                                                                                      }];
    }];
}
#pragma mark - 私有方法


@end
