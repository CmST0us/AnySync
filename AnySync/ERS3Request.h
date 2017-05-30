//
//  ERS3Request.h
//  extenFun
//
//  Created by CmST0us on 17/5/2.
//  Copyright © 2017年 CmST0us. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "ERS3Authorization.h"

static NSString *kERS3MainApiDomain = @"http://sinacloud.net";
static NSString *kERS3AlternativApieDomain = @"http://sinastorage.cn";
static NSString *kERS3DownloadApiDomain = @"http://cdn.sinacloud.net";
static NSString *kERS3UploadApiDomain = @"http://up.sinacloud.net";

@interface ERS3Request : NSObject
@property (nonatomic, readonly) AFHTTPSessionManager *httpSessionManager;
@property (nonatomic, readonly) AFURLSessionManager *urlSessionManager;
@property (nonatomic, readonly) NSURL *baseUrl;

+ (NSString *)currentDateStringUseHttpHeaderFormatter;
    
- (instancetype)initWithBaseUrl:(NSString *)url;

@end
