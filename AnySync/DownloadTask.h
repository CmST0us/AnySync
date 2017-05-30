//
//  DownloadTask.h
//  AnySync
//
//  Created by CmST0us on 17/5/30.
//  Copyright © 2017年 CmST0us. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString const *kDownloadTaskFinishNotification;

extern NSString const *kDownloadTaskIdKey;
extern NSString const *kDownloadTaskFilePathKey;
extern NSString const *kDownloadTaskErrorKey;
@interface DownloadTask : NSObject {
    @protected
    double _downloadProgress;
    NSString *_downloadDestination;
    NSString *_taskId;
}

@property (nonatomic, readonly, assign) double downloadProgress;
@property (nonatomic, copy) NSString *downloadDestination;
@property (nonatomic, readonly, copy) NSString *taskId;

- (void)doDownload;

@end
