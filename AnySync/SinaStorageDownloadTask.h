//
//  SinaStorageDownloadTask.h
//  AnySync
//
//  Created by CmST0us on 17/5/30.
//  Copyright © 2017年 CmST0us. All rights reserved.
//

#import "DownloadTask.h"

@interface SinaStorageDownloadTask : DownloadTask

+ (instancetype)downloadTaskWithFilePath:(NSString *)path;

- (void)setDownloadTaskWithFilePath:(NSString *)path;


@end
