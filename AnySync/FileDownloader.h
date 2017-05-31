//
//  FileDownloader.h
//  AnySync
//
//  Created by CmST0us on 17/5/30.
//  Copyright © 2017年 CmST0us. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DownloadTask;
@interface FileDownloader : NSObject

+ (instancetype)shareInstance;

- (void)addDownloadTask:(DownloadTask *)task;

- (void)resumeTaskWithId:(NSString *)taskId;

- (void)pauseTaskWithId:(NSString *)taskId;

- (void)stopTaskWithId:(NSString *)taskId;
@end
