//
//  ERS3ServiceRequest.m
//  extenFun
//
//  Created by CmST0us on 17/5/2.
//  Copyright © 2017年 CmST0us. All rights reserved.
//

#import "ERS3ServiceRequest.h"
#import "ERS3Request.h"
#import <AFNetworking/AFNetworking.h>
#import "ERS3Authorization.h"

@implementation ERS3ServiceRequest

- (NSURLSessionDataTask *)listBucketsWithProgress:(void (^)(NSProgress * _Nonnull))downloadProgress
                                          success:(void (^)(NSURLSessionDataTask * _Nonnull, NSDictionary * _Nullable))success
                                          failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure {
    
    AFHTTPRequestSerializer *rSerializer = self.httpSessionManager.requestSerializer;
    NSString *dateString = [ERS3Request currentDateStringUseHttpHeaderFormatter];
    [rSerializer setValue:dateString forHTTPHeaderField:@"Date"];
    NSString *authorizationValue = [ERS3Authorization authorizationValueWithAccessKey:kAccessKey SecretAccessKey:kSecretAccessKey HTTPVerb:@"GET" ContentMD5:@"" ContentType:@"" Date:dateString CanonicalizedAmzHeaders:@"" CanonicalizedResource:@"/"];
    [rSerializer setValue:authorizationValue forHTTPHeaderField:@"Authorization"];
    [rSerializer setValue:[self.baseUrl host] forHTTPHeaderField:@"Host"];
    
    return [self.httpSessionManager GET:@"/?formatter=json"
                      parameters:nil
                        progress:^(NSProgress * _Nonnull d) {
                            downloadProgress(d);
                        }
                        success:^(NSURLSessionDataTask * _Nonnull t, id  _Nullable r) {
                            success(t, r);
                        }
                        failure:^(NSURLSessionDataTask * _Nullable t, NSError * _Nonnull e) {
                            failure(t, e);
                        }];
}

@end
