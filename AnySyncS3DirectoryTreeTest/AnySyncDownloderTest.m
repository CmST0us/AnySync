//
//  AnySyncDownloderTest.m
//  AnySync
//
//  Created by CmST0us on 17/5/31.
//  Copyright © 2017年 CmST0us. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DownloadTask.h"
#import "SinaStorageDownloadTask.h"
#import "FileDownloader.h"

@interface AnySyncDownloderTest : XCTestCase

@end

@implementation AnySyncDownloderTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    SinaStorageDownloadTask *task = [SinaStorageDownloadTask downloadTaskWithFilePath:@"lijlkj/test.xls" taskId:@"test.xls"];
    task.downloadDestination = @"/tmp/test.xls";
    FileDownloader *downloader = [FileDownloader shareInstance];
    [downloader addDownloadTask:task];
    [downloader resumeTaskWithId:@"test.xls"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadFinish:) name:(NSString *)kDownloadTaskFinishNotification object:nil];
    [[NSRunLoop currentRunLoop] run];
}

- (void)downloadFinish:(NSNotification *)notification {
    NSLog(@"task OK!");
}
- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
