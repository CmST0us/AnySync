//
//  ERS3BucketRequest.m
//  extenFun
//
//  Created by CmST0us on 17/5/2.
//  Copyright © 2017年 CmST0us. All rights reserved.
//

#import "ERS3BucketRequest.h"

@implementation ERS3BucketRequest

- (instancetype)initWithBaseUrl:(NSString *)url bucketName:(NSString *)bucketName {
    self = [super initWithBaseUrl:url];
    if (self) {
        _bucketName = bucketName;
    }
    return self;
}
- (NSURLSessionTask *)listObjectsWithPrefix:(NSString *)prefix
                                     marker:(NSString *)marker
                                  delimiter:(NSString *)delimiter
                                   progress:(void (^)(NSProgress * _Nonnull))downloadProgress
                                    success:(void (^)(NSURLSessionDataTask * _Nonnull, NSDictionary * _Nullable))success
                                    failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure {
    
    AFHTTPRequestSerializer *rSerializer = [AFHTTPRequestSerializer serializer];
    self.httpSessionManager.requestSerializer = rSerializer;
    NSString *dateString = [ERS3Request currentDateStringUseHttpHeaderFormatter];
    NSString *hostString = [NSString stringWithFormat:@"%@.%@", _bucketName, [self.baseUrl host]];
    NSDictionary *xamzDict = @{
                               @"x-amz-date": dateString,
                               };
    
    NSDictionary *tParmDict = @{
                                @"prefix": prefix == NULL? @"" : prefix,
                                @"delimiter": delimiter == NULL? @"" : delimiter,
                                @"marker": marker == NULL ? @"" : marker,
                                };
    NSMutableDictionary *tParaments = [[NSMutableDictionary alloc]initWithDictionary:tParmDict];
    if (delimiter == NULL) {
        [tParaments removeObjectForKey:@"delimiter"];
    }
    if (marker == NULL) {
        [tParaments removeObjectForKey:@"marker"];
    }
    //rParamter需要按照字符串升序排序
    NSString *canonicalizedResource = [NSString stringWithFormat:@"/%@/", _bucketName];
    NSString *authorizationValue = [ERS3Authorization authorizationValueWithAccessKey:kAccessKey
                                                                      SecretAccessKey:kSecretAccessKey
                                                                             HTTPVerb:@"GET"
                                                                           ContentMD5:@""
                                                                          ContentType:@""
                                                                                 Date:@""
                                                              CanonicalizedAmzHeaders:[ERS3Authorization amzHeaderWithDictionary:xamzDict]
                                                                CanonicalizedResource:canonicalizedResource];
    
    NSDictionary *reqDict = @{
                              @"Authorization": authorizationValue,
                              @"Host": hostString,
                              @"Content-Type": @""
                              };
    
    [reqDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [rSerializer setValue:obj forHTTPHeaderField:key];
    }];
    [xamzDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [rSerializer setValue:obj forHTTPHeaderField:key];
    }];
    return [self.httpSessionManager GET:@"/?formatter=json"
                             parameters:tParaments
                               progress:^(NSProgress * _Nonnull d) {
                                   downloadProgress(d);
                               }
                                success:^(NSURLSessionDataTask * _Nonnull t, id  _Nullable r) {
                                    //TODO 去除重复数据!!!!!!!!
                                    NSMutableDictionary *bucketsDictionary = [[NSMutableDictionary alloc]initWithDictionary:r];
                                    NSString *currentPrefix = [bucketsDictionary objectForKey:@"Prefix"];
                                    NSArray *rawList = [bucketsDictionary objectForKey:@"Contents"];
                                    NSMutableArray *list = [NSMutableArray array];
                                    [rawList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                        NSDictionary *d = obj;
                                        if ([[d objectForKey:@"Name"] compare:currentPrefix] != NSOrderedSame) {
                                            [list addObject:obj];
                                        }
                                    }];
                                    [bucketsDictionary setObject:list forKey:@"Contents"];
                                    success(t, bucketsDictionary);
                                }
                                failure:^(NSURLSessionDataTask * _Nullable t, NSError * _Nonnull e) {
                                    failure(t, e);
                                }];
}

- (NSURLSessionTask *)listObjectsWithPrefix:(NSString *)prefix
                                     marker:(NSString *)marker
                                    maxKeys:(NSInteger)maxKeys
                                  delimiter:(NSString *)delimiter
                                   progress:(void (^)(NSProgress * _Nonnull))downloadProgress
                                    success:(void (^)(NSURLSessionDataTask * _Nonnull, NSDictionary * _Nullable))success
                                    failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure {
    
    AFHTTPRequestSerializer *rSerializer = [AFHTTPRequestSerializer serializer];
    self.httpSessionManager.requestSerializer = rSerializer;
    NSString *dateString = [ERS3Request currentDateStringUseHttpHeaderFormatter];
    NSString *hostString = [NSString stringWithFormat:@"%@.%@", _bucketName, [self.baseUrl host]];
    NSDictionary *xamzDict = @{
                               @"x-amz-date": dateString,
                               };
    
    NSDictionary *tParmDict = @{
                                  @"prefix": prefix == NULL? @"" : prefix,
                                  @"delimiter": delimiter == NULL? @"" : delimiter,
                                  @"max-keys": [[NSNumber numberWithInteger:maxKeys] stringValue],
                                  @"marker": marker == NULL ? @"" : marker,
                                  };
    NSMutableDictionary *tParaments = [[NSMutableDictionary alloc]initWithDictionary:tParmDict];
    if (delimiter == NULL) {
        [tParaments removeObjectForKey:@"delimiter"];
    }
    if (marker == NULL) {
        [tParaments removeObjectForKey:@"marker"];
    }
    //rParamter需要按照字符串升序排序
    NSString *canonicalizedResource = [NSString stringWithFormat:@"/%@/", _bucketName];
    NSString *authorizationValue = [ERS3Authorization authorizationValueWithAccessKey:kAccessKey
                                                                      SecretAccessKey:kSecretAccessKey
                                                                             HTTPVerb:@"GET"
                                                                           ContentMD5:@""
                                                                          ContentType:@""
                                                                                 Date:@""
                                                              CanonicalizedAmzHeaders:[ERS3Authorization amzHeaderWithDictionary:xamzDict]
                                                                CanonicalizedResource:canonicalizedResource];
    
    NSDictionary *reqDict = @{
                              @"Authorization": authorizationValue,
                              @"Host": hostString,
                              @"Content-Type": @""
                              };
    
    [reqDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [rSerializer setValue:obj forHTTPHeaderField:key];
    }];
    [xamzDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [rSerializer setValue:obj forHTTPHeaderField:key];
    }];
    
    return [self.httpSessionManager GET:@"/?formatter=json"
                             parameters:tParaments
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

- (NSURLSessionTask *)listObjectsSyncWithPrefix:(NSString *)prefix
                                         marker:(NSString *)marker
                                        maxKeys:(NSInteger)maxKeys
                                      delimiter:(NSString *)delimiter
                                       progress:(void (^)(NSProgress * _Nonnull))downloadProgress
                                        success:(void (^)(NSURLSessionDataTask * _Nonnull, NSDictionary * _Nullable))success
                                        failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure {
    
    AFHTTPRequestSerializer *rSerializer = [AFHTTPRequestSerializer serializer];
    self.httpSessionManager.requestSerializer = rSerializer;

    NSString *dateString = [ERS3Request currentDateStringUseHttpHeaderFormatter];
    NSString *hostString = [NSString stringWithFormat:@"%@.%@", _bucketName, [self.baseUrl host]];
    NSDictionary *xamzDict = @{
                               @"x-amz-date": dateString,
                               };
    
    NSDictionary *tParmDict = @{
                                @"prefix": prefix == NULL? @"" : prefix,
                                @"delimiter": delimiter == NULL? @"" : delimiter,
                                @"max-keys": [[NSNumber numberWithInteger:maxKeys] stringValue],
                                @"marker": marker == NULL ? @"" : marker,
                                };
    NSMutableDictionary *tParaments = [[NSMutableDictionary alloc]initWithDictionary:tParmDict];
    if (delimiter == NULL) {
        [tParaments removeObjectForKey:@"delimiter"];
    }
    if (marker == NULL) {
        [tParaments removeObjectForKey:@"marker"];
    }
    //rParamter需要按照字符串升序排序
    NSString *canonicalizedResource = [NSString stringWithFormat:@"/%@/", _bucketName];
    NSString *authorizationValue = [ERS3Authorization authorizationValueWithAccessKey:kAccessKey
                                                                      SecretAccessKey:kSecretAccessKey
                                                                             HTTPVerb:@"GET"
                                                                           ContentMD5:@""
                                                                          ContentType:@""
                                                                                 Date:@""
                                                              CanonicalizedAmzHeaders:[ERS3Authorization amzHeaderWithDictionary:xamzDict]
                                                                CanonicalizedResource:canonicalizedResource];
    
    NSDictionary *reqDict = @{
                              @"Authorization": authorizationValue,
                              @"Host": hostString,
                              @"Content-Type": @""
                              };
    
    [reqDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [rSerializer setValue:obj forHTTPHeaderField:key];
    }];
    [xamzDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [rSerializer setValue:obj forHTTPHeaderField:key];
    }];
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    NSURLSessionDataTask *dataTask = [self.httpSessionManager GET:@"/?formatter=json"
                                                           parameters:tParaments
                                                             progress:^(NSProgress * _Nonnull d) {
                                                                 downloadProgress(d);
                                                             }
                                                              success:^(NSURLSessionDataTask * _Nonnull t, id  _Nullable r) {
                                                                  success(t, r);
                                                                  dispatch_group_leave(group);
                                                              }
                                                              failure:^(NSURLSessionDataTask * _Nullable t, NSError * _Nonnull e) {
                                                                  failure(t, e);
                                                                  dispatch_group_leave(group);
                                                              }];

    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    return dataTask;
}
- (NSArray *)listAllObjectsWithError:(NSError **)err {
    NSMutableArray *dictArray = [NSMutableArray array];
    __block NSString *marker = @"";
    __block BOOL isFinishListObject = NO;
    
    while (!isFinishListObject) {
        [self listObjectsSyncWithPrefix:@"" marker:marker maxKeys:400 delimiter:NULL progress:^(NSProgress *progress) {
           
        } success:^(NSURLSessionDataTask *t, NSDictionary *d) {
            //取NextMarker
            NSString *nextMarker = [d objectForKey:@"NextMarker"];
            NSNumber *isTruncatedNumber = [d objectForKey:@"IsTruncated"];
            BOOL isTruncated = [isTruncatedNumber boolValue];
            
            if (!isTruncated) {
                //end
                isFinishListObject = YES;
                nextMarker = @"";
            }
            //nextMarker 作为marker
            marker = nextMarker;
            [dictArray addObject:d];
        } failure:^(NSURLSessionDataTask *t, NSError *e) {
            if (err != NULL) {
                *err = e;
            }
        }];
    }
    
    return dictArray;

}
- (NSURLSessionTask *)listMetaWithProgress:(void (^)(NSProgress * _Nonnull))downloadProgress
                                   success:(void (^)(NSURLSessionDataTask * _Nonnull, NSDictionary * _Nullable))success
                                   failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure {
    
    AFHTTPRequestSerializer *rSerializer = [AFHTTPRequestSerializer serializer];
    self.httpSessionManager.requestSerializer = rSerializer;
    NSString *dateString = [ERS3Request currentDateStringUseHttpHeaderFormatter];
    NSString *canonicalizedResource = [NSString stringWithFormat:@"/%@/?meta", _bucketName];
    NSString *hostString = [NSString stringWithFormat:@"%@.%@", _bucketName, [self.baseUrl host]];
    NSDictionary *xamzDict = @{
                               @"x-amz-date": dateString,
                               };
    
    NSString *authorizationValue = [ERS3Authorization authorizationValueWithAccessKey:kAccessKey
                                                                      SecretAccessKey:kSecretAccessKey
                                                                             HTTPVerb:@"GET"
                                                                           ContentMD5:@""
                                                                          ContentType:@""
                                                                                 Date:@""
                                                              CanonicalizedAmzHeaders:[ERS3Authorization amzHeaderWithDictionary:xamzDict]
                                                                CanonicalizedResource:canonicalizedResource];
    
    NSDictionary *reqDict = @{
                              @"Authorization": authorizationValue,
                              @"Host": hostString,
                              @"Content-Type": @""
                              };
    
    [reqDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [rSerializer setValue:obj forHTTPHeaderField:key];
    }];
    [xamzDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [rSerializer setValue:obj forHTTPHeaderField:key];
    }];
    
    
    return [self.httpSessionManager GET:@"/?meta&formatter=json"
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

- (NSURLSessionTask *)createWithFastAcl:(NSString *)acl
                               Progress:(void (^)(NSProgress * _Nonnull))downloadProgress
                                success:(void (^)(NSURLSessionDataTask * _Nonnull, NSDictionary * _Nullable))success
                                failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure {
    
    AFHTTPRequestSerializer *rSerializer = [AFHTTPRequestSerializer serializer];
    self.httpSessionManager.requestSerializer = rSerializer;
    NSString *dateString = [ERS3Request currentDateStringUseHttpHeaderFormatter];
    NSString *canonicalizedResource = [NSString stringWithFormat:@"/%@/", _bucketName];
    NSString *hostString = [NSString stringWithFormat:@"%@.%@", _bucketName, [self.baseUrl host]];
    NSDictionary *xamzDict = @{
                               @"x-amz-acl": acl,
                               @"x-amz-date": dateString,
                               };
    
    NSString *authorizationValue = [ERS3Authorization authorizationValueWithAccessKey:kAccessKey
                                                                      SecretAccessKey:kSecretAccessKey
                                                                             HTTPVerb:@"PUT"
                                                                           ContentMD5:@""
                                                                          ContentType:@""
                                                                                 Date:@""
                                                              CanonicalizedAmzHeaders:[ERS3Authorization amzHeaderWithDictionary:xamzDict]
                                                                CanonicalizedResource:canonicalizedResource];
    
    NSDictionary *reqDict = @{
                              @"Authorization": authorizationValue,
                              @"Host": hostString,
                              @"Content-Type": @""
                              };
    
    [reqDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [rSerializer setValue:obj forHTTPHeaderField:key];
    }];
    [xamzDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [rSerializer setValue:obj forHTTPHeaderField:key];
    }];
    
    return [self.httpSessionManager PUT:@"/?formatter=json" parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task, error);
    }];
}

- (NSURLSessionTask *)deleteWithProgress:(void (^)(NSProgress * _Nonnull))downloadProgress
                                 success:(void (^)(NSURLSessionDataTask * _Nonnull, NSDictionary * _Nullable))success
                                 failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure {
    
    AFHTTPRequestSerializer *rSerializer = [AFHTTPRequestSerializer serializer];
    self.httpSessionManager.requestSerializer = rSerializer;
    NSString *dateString = [ERS3Request currentDateStringUseHttpHeaderFormatter];
    NSString *canonicalizedResource = [NSString stringWithFormat:@"/%@/", _bucketName];
    NSString *hostString = [NSString stringWithFormat:@"%@.%@", _bucketName, [self.baseUrl host]];
    NSDictionary *xamzDict = @{
                               @"x-amz-date": dateString,
                               };
    
    NSString *authorizationValue = [ERS3Authorization authorizationValueWithAccessKey:kAccessKey
                                                                      SecretAccessKey:kSecretAccessKey
                                                                             HTTPVerb:@"DELETE"
                                                                           ContentMD5:@""
                                                                          ContentType:@""
                                                                                 Date:@""
                                                              CanonicalizedAmzHeaders:[ERS3Authorization amzHeaderWithDictionary:xamzDict]
                                                                CanonicalizedResource:canonicalizedResource];
    
    NSDictionary *reqDict = @{
                              @"Authorization": authorizationValue,
                              @"Host": hostString,
                              @"Content-Type": @""
                              };
    
    [reqDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [rSerializer setValue:obj forHTTPHeaderField:key];
    }];
    [xamzDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [rSerializer setValue:obj forHTTPHeaderField:key];
    }];
    
    return [self.httpSessionManager DELETE:@"/?formatter=json" parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task, error);
    }];
}

- (NSURLSessionTask *)listAclWithProgress:(void (^)(NSProgress * _Nonnull))downloadProgress
                                  success:(void (^)(NSURLSessionDataTask * _Nonnull, NSDictionary * _Nullable))success
                                  failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure {
    
    AFHTTPRequestSerializer *rSerializer = [AFHTTPRequestSerializer serializer];
    self.httpSessionManager.requestSerializer = rSerializer;
    NSString *dateString = [ERS3Request currentDateStringUseHttpHeaderFormatter];
    NSString *canonicalizedResource = [NSString stringWithFormat:@"/%@/?acl", _bucketName];
    NSString *hostString = [NSString stringWithFormat:@"%@.%@", _bucketName, [self.baseUrl host]];
    NSDictionary *xamzDict = @{
                               @"x-amz-date": dateString,
                               };
    
    NSString *authorizationValue = [ERS3Authorization authorizationValueWithAccessKey:kAccessKey
                                                                      SecretAccessKey:kSecretAccessKey
                                                                             HTTPVerb:@"GET"
                                                                           ContentMD5:@""
                                                                          ContentType:@""
                                                                                 Date:@""
                                                              CanonicalizedAmzHeaders:[ERS3Authorization amzHeaderWithDictionary:xamzDict]
                                                                CanonicalizedResource:canonicalizedResource];
    
    NSDictionary *reqDict = @{
                              @"Authorization": authorizationValue,
                              @"Host": hostString,
                              @"Content-Type": @""
                              };
    
    [reqDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [rSerializer setValue:obj forHTTPHeaderField:key];
    }];
    [xamzDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [rSerializer setValue:obj forHTTPHeaderField:key];
    }];
    
    
    return [self.httpSessionManager GET:@"/?acl&formatter=json" parameters:nil progress:^(NSProgress * _Nonnull d) {
        downloadProgress(d);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task, error);
    }];
    
}

//TODO ACL list
- (NSURLSessionTask *)putAclWithAcl:(NSDictionary *)acl
                              progress:(void (^)(NSProgress *))downloadProgress
                               success:(void (^)(NSURLSessionDataTask *, NSDictionary *))success
                               failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    
    AFHTTPRequestSerializer *rSerializer = [AFJSONRequestSerializer serializer];
    self.httpSessionManager.requestSerializer = rSerializer;
    NSString *dateString = [ERS3Request currentDateStringUseHttpHeaderFormatter];
    NSString *canonicalizedResource = [NSString stringWithFormat:@"/%@/?acl", _bucketName];
    NSString *hostString = [NSString stringWithFormat:@"%@.%@", _bucketName, [self.baseUrl host]];
    NSDictionary *xamzDict = @{
                           @"x-amz-date": dateString,
                           };
    
    NSString *authorizationValue = [ERS3Authorization authorizationValueWithAccessKey:kAccessKey
                                                                      SecretAccessKey:kSecretAccessKey
                                                                             HTTPVerb:@"PUT"
                                                                           ContentMD5:@""
                                                                          ContentType:@""
                                                                                 Date:@""
                                                              CanonicalizedAmzHeaders:[ERS3Authorization amzHeaderWithDictionary:xamzDict]
                                                                CanonicalizedResource:canonicalizedResource];
    
    NSDictionary *reqDict = @{
                              @"Authorization": authorizationValue,
                              @"Host": hostString,
                              @"Content-Type": @""
                              };
    
    [reqDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [rSerializer setValue:obj forHTTPHeaderField:key];
    }];
    [xamzDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [rSerializer setValue:obj forHTTPHeaderField:key];
    }];
    
    return [self.httpSessionManager PUT:@"/?acl&formatter=json" parameters:acl success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task, error);
    }];

}
@end
