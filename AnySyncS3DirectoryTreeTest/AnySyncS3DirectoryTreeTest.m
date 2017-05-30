//
//  AnySyncS3DirectoryTreeTest.m
//  AnySyncS3DirectoryTreeTest
//
//  Created by CmST0us on 17/5/27.
//  Copyright © 2017年 CmST0us. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ERS3BucketRequest.h"
#import "SinaStorageDataModel.h"
#import "SinaStorageFile.h"
#import "SinaStorageDirectory.h"
@interface AnySyncS3DirectoryTreeTest : XCTestCase{
    
}

@property (nonatomic, strong) ERS3BucketRequest *bucketRequest;
@end

@implementation AnySyncS3DirectoryTreeTest

- (void)setUp {
    [super setUp];
    _bucketRequest = [[ERS3BucketRequest alloc] initWithBaseUrl:kERS3MainApiDomain bucketName:@"com.cmst0us.anysync.bucket"];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    SinaStorageDataModel *dataModel = [[SinaStorageDataModel alloc] init];
    NSArray *dictArray = [_bucketRequest listAllObjectsWithError:NULL];
    if ([dictArray count] == 0) {
        NSLog(@"NULL");
    }
    [dictArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *bucketsDictionary = obj;
        NSArray *contentArray = [bucketsDictionary objectForKey:@"Contents"];
        NSDate *date = [NSDate date];
        [dataModel feedContentsArray:contentArray];
        NSLog(@"time cost:%f", [[NSDate date] timeIntervalSinceDate:date]);
    }];
    [dataModel changeDirectoryToNextDirectoryWithName:@"haproxy-master"];
    [[dataModel directories] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SinaStorageDirectory *directory = obj;
        NSLog(@"Directory: %@", directory.name);
    }];
    [[dataModel files] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SinaStorageFile *file = obj;
        NSLog(@"File: %@", file.name);
    }];
    
    [dataModel changeDirectoryToPathFromRoot:@"haproxy-master/src/"];
    [[dataModel files] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SinaStorageFile *file = obj;
        NSLog(@"File: %@", file.name);
    }];
    NSLog(@"ok");
}
- (void)testChangeToPath {
    SinaStorageDataModel *dataModel = [[SinaStorageDataModel alloc] init];
    NSArray *dictArray = [_bucketRequest listAllObjectsWithError:NULL];
    if ([dictArray count] == 0) {
        NSLog(@"NULL");
    }
    [dictArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *bucketsDictionary = obj;
        NSArray *contentArray = [bucketsDictionary objectForKey:@"Contents"];
        NSDate *date = [NSDate date];
        [dataModel feedContentsArray:contentArray];
        NSLog(@"time cost:%f", [[NSDate date] timeIntervalSinceDate:date]);
    }];
    
    [dataModel changeDirectoryToPathFromRoot:@"haproxy-master/src/"];
    [[dataModel files] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SinaStorageFile *file = obj;
        NSLog(@"File: %@", file.name);
    }];
}

- (void)testChangeToPathFromCurrent {
    SinaStorageDataModel *dataModel = [[SinaStorageDataModel alloc] init];
    dataModel.isLastDirectoryInDictionary = YES;
    NSArray *dictArray = [_bucketRequest listAllObjectsWithError:NULL];
    if ([dictArray count] == 0) {
        NSLog(@"NULL");
    }
    [dictArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *bucketsDictionary = obj;
        NSArray *contentArray = [bucketsDictionary objectForKey:@"Contents"];
        NSDate *date = [NSDate date];
        [dataModel feedContentsArray:contentArray];
        NSLog(@"time cost:%f", [[NSDate date] timeIntervalSinceDate:date]);
    }];
    
    [dataModel changeDirectoryToPathFromRoot:@"haproxy-master/../"];
    [[dataModel directories] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SinaStorageDirectory *directory = obj;
        NSLog(@"Directory: %@", directory.name);
    }];
}
- (void)testPathToDirectorieyNameArray {
//    NSArray *filePath = [SinaStorageDataModel _parsePathToDirectoryNameArray:@"asdfas/asdfasd/fasdfasdfa"];
//    NSArray *directoryPath = [SinaStorageDataModel _parsePathToDirectoryNameArray:@"asdfas/asdfasd/fasdfasdfa/"];
}

- (void)testDispatchGroup {
    dispatch_group_t group = dispatch_group_create();
    for (int i = 0; i < 100; ++i) {
        dispatch_group_enter(group);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSLog(@"%d", i);
            dispatch_group_leave(group);
        });
    }
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    NSLog(@"ok");
}
- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
