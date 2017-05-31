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
+ (instancetype)downloadTaskWithFilePath:(NSString *)path
                                  taskId:(NSString *)taskId{
    SinaStorageDownloadTask *downloadTask = [[SinaStorageDownloadTask alloc] init];
    [downloadTask setDownloadTaskWithFilePath:path];
    downloadTask.taskId = taskId;
    return downloadTask;
}

#warning add downloadWithStorageFile
#pragma mark - 实例方法
- (void)setDownloadTaskWithFilePath:(NSString *)path {
    _downloadFilePath = [path copy];
}

- (void)resumeDownload {
    /*
                业务逻辑
     1. 首先向CoreData取回已经下载的文件大小，返回逻辑？？？<或者判断文件是否存在，存在则读取大小，使用此大小向储存器下载>
     */
    
    [_objectRequest downloadWithPath:_downloadFilePath range:@"0-" progress:^(NSProgress *downloadProgress) {
        //不需要向下载器汇报，下载器定时回调轮询
        _downloadProgress = [downloadProgress fractionCompleted];
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        if (_downloadDestination == NULL) {
            _downloadDestination = [targetPath absoluteString];
        }
        return [NSURL URLWithString:_downloadDestination];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (error != nil) {
#warning 字典不能添加NULL
            [[NSNotificationCenter defaultCenter] postNotificationName:(NSString *)kDownloadTaskErrorNotification object:NULL userInfo:@{kDownloadTaskIdKey: _taskId,
                                                                                                                                          kDownloadTaskFilePathKey: filePath,
                                                                                                                                          kDownloadTaskErrorKey: error,
                                                                                                                                          }];
            return ;
        }
        //向下载器报告完成
#warning 字典不能添加NULL
        [[NSNotificationCenter defaultCenter] postNotificationName:(NSString *)kDownloadTaskFinishNotification object:NULL userInfo:@{kDownloadTaskIdKey: _taskId,
                                                                                                                                      kDownloadTaskFilePathKey: filePath,
                                                                                                                                      }];
    }];
}

- (void)pauseDownload {
    /*
            业务逻辑
     1. 保存文件
     2. 保存进度
     
     */
}
#pragma mark - 私有方法


@end
