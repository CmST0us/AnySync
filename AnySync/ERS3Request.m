//
//  ERS3Request.m
//  extenFun
//
//  Created by CmST0us on 17/5/2.
//  Copyright © 2017年 CmST0us. All rights reserved.
//

#import "ERS3Request.h"

@interface ERS3Request () {
    dispatch_queue_t _httpSessionManagerCompletionQueue;
    dispatch_queue_t _urlSessionManagerCompletionQueue;
}

@end

@implementation ERS3Request


//TODO BUG incorrect checksum for freed object - object was probably modified after being freed.*** set a breakpoint in malloc_error_break to debug

+ (NSString *)currentDateStringUseHttpHeaderFormatter {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"EEE, d MMM yyyy HH:mm:ss ZZZ"];
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
    NSString *dateString = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    return dateString;
}

- (instancetype)initWithBaseUrl:(NSString *)url {
    self = [super init];
    if (self) {
        _baseUrl = [NSURL URLWithString:url];
        _httpSessionManagerCompletionQueue = dispatch_queue_create("com.CmST0us.AnySync.HttpCompletionQueue", DISPATCH_QUEUE_SERIAL);
        _urlSessionManagerCompletionQueue = dispatch_queue_create("com.CmST0us.AnySync.URLCompletionQueue", DISPATCH_QUEUE_SERIAL);
        _httpSessionManager = [[AFHTTPSessionManager alloc]initWithBaseURL:_baseUrl];
        _httpSessionManager.completionQueue = _httpSessionManagerCompletionQueue;
        _urlSessionManager = [[AFURLSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        _urlSessionManager.completionQueue = _urlSessionManagerCompletionQueue;
    }
    return self;
}


@end
