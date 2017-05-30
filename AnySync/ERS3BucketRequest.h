//
//  ERS3BucketRequest.h
//  extenFun
//
//  Created by CmST0us on 17/5/2.
//  Copyright © 2017年 CmST0us. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ERS3Request.h"

@interface ERS3BucketRequest : ERS3Request

@property (nonatomic, readonly) NSString *bucketName;

- (instancetype)initWithBaseUrl:(NSString *)url
                     bucketName:(NSString *)bucketName;

- (NSURLSessionTask *)listObjectsWithPrefix:(NSString *)prefix
                                     marker:(NSString *)marker
                                  delimiter:(NSString *)delimiter
                                   progress:(void (^)(NSProgress *progress))downloadProgress
                                    success:(void (^)(NSURLSessionDataTask *dataTask, NSDictionary *bucketsDictionary))success
                                    failure:(void (^)(NSURLSessionDataTask *dataTask, NSError *error))failure;

- (NSArray *)listAllObjectsWithError:(NSError **)err;

- (NSURLSessionTask *)listObjectsWithPrefix:(NSString *)prefix
                                     marker:(NSString *)marker
                                    maxKeys:(NSInteger)maxKeys
                                  delimiter:(NSString *)delimiter
                                   progress:(void (^)(NSProgress *progress))downloadProgress
                                    success:(void (^)(NSURLSessionDataTask *dataTask, NSDictionary *bucketsDictionary))success
                                    failure:(void (^)(NSURLSessionDataTask *dataTask, NSError *error))failure;

- (NSURLSessionTask *)listMetaWithProgress:(void (^)(NSProgress *progress))downloadProgress
                                   success:(void (^)(NSURLSessionDataTask *dataTask, NSDictionary *bucketsDictionary))success
                                   failure:(void (^)(NSURLSessionDataTask *dataTask, NSError *error))failure;

- (NSURLSessionTask *)createWithFastAcl:(NSString *)acl
                               Progress:(void (^)(NSProgress *))downloadProgress
                                success:(void (^)(NSURLSessionDataTask *, NSDictionary *))success
                                failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;

- (NSURLSessionTask *)deleteWithProgress:(void (^)(NSProgress *progress))downloadProgress
                                 success:(void (^)(NSURLSessionDataTask *dataTask, NSDictionary *bucketsDictionary))success
                                 failure:(void (^)(NSURLSessionDataTask *dataTask, NSError *error))failure;

- (NSURLSessionTask *)listAclWithProgress:(void (^)(NSProgress *progress))downloadProgress
                                  success:(void (^)(NSURLSessionDataTask *dataTask, NSDictionary *bucketsDictionary))success
                                  failure:(void (^)(NSURLSessionDataTask *dataTask, NSError *error))failure;

- (NSURLSessionTask *)putAclWithAcl:(NSDictionary *)acl
                              progress:(void (^)(NSProgress *progress))downloadProgress
                               success:(void (^)(NSURLSessionDataTask *dataTask, NSDictionary *bucketsDictionary))success
                               failure:(void (^)(NSURLSessionDataTask *dataTask, NSError *error))failure;

#pragma Helper -

@end
