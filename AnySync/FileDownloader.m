//
//  FileDownloader.m
//  AnySync
//
//  Created by CmST0us on 17/5/30.
//  Copyright © 2017年 CmST0us. All rights reserved.
//

#import "FileDownloader.h"
#import "DownloadTask.h"
@interface FileDownloader () {
    NSMutableDictionary<NSString *, DownloadTask *> *_downloadTask;
}

@end

@implementation FileDownloader

#pragma mark - 单例方法
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static FileDownloader *downloader;
    dispatch_once(&onceToken, ^{
        downloader = [[FileDownloader alloc] init];
    });
    return downloader;
}
#pragma mark - 初始化方法
- (instancetype)init {
    self = [super init];
    if (self) {
        _downloadTask = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - 下载器方法
- (void)addDownloadTask:(DownloadTask *)task {
    [_downloadTask setObject:task forKey:task.taskId];
}

- (void)resumeTaskWithId:(NSString *)taskId {
    DownloadTask *task = [_downloadTask objectForKey:taskId];
    [task resumeDownload];
}

- (void)pauseTaskWithId:(NSString *)taskId {
    DownloadTask *task = [_downloadTask objectForKey:taskId];
    [task pauseDownload];
}

- (void)stopTaskWithId:(NSString *)taskId {
    DownloadTask *task = [_downloadTask objectForKey:taskId];
    [task stopDownload];
}

@end
