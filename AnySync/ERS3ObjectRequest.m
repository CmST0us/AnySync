//
//  ERS3ObjectRequest.m
//  extenFun
//
//  Created by CmST0us on 17/5/2.
//  Copyright © 2017年 CmST0us. All rights reserved.
//

#import "ERS3ObjectRequest.h"
#import "NSString+NSString_URLEncode.h"
@implementation ERS3ObjectRequest

- (instancetype)initWithBaseUrl:(NSString *)url bucketName:(NSString *)bucketName {
    self = [super initWithBaseUrl:url];
    if (self) {
        _bucketName = bucketName;
    }
    return self;
}

- (NSURLSessionTask *)listMetaWithPath:(NSString *)path
                               success:(void (^)(NSURLSessionDataTask *))success
                               failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    path = [path URLEncodedString];
    AFHTTPRequestSerializer *rSerializer = [AFHTTPRequestSerializer serializer];
    self.httpSessionManager.requestSerializer = rSerializer;
    NSString *dateString = [ERS3Request currentDateStringUseHttpHeaderFormatter];
    NSString *canonicalizedResource = [NSString stringWithFormat:@"/%@/%@", _bucketName, path];
    NSString *hostString = [NSString stringWithFormat:@"%@.%@", _bucketName, [self.baseUrl host]];
    NSString *objUrlString = [NSString stringWithFormat:@"/%@?formatter=json", path];
    NSDictionary *xamzDict = @{
                               @"x-amz-date": dateString,
                               };
    
    NSString *authorizationValue = [ERS3Authorization authorizationValueWithAccessKey:kAccessKey
                                                                      SecretAccessKey:kSecretAccessKey
                                                                             HTTPVerb:@"HEAD"
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
    
    return [self.httpSessionManager HEAD:objUrlString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task) {
        success(task);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task, error);
    }];
}

- (NSURLSessionTask *)downloadWithPath:(NSString *)path
                                 range:(NSString *)rangeString
                              progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock
                           destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destinationBlock
                     completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandlerBlock {
    
    path = [path URLEncodedString];
    NSString *dateString = [ERS3Request currentDateStringUseHttpHeaderFormatter];
    NSString *canonicalizedResource = [NSString stringWithFormat:@"/%@/%@", _bucketName, path];
    NSString *hostString = [NSString stringWithFormat:@"%@.%@", _bucketName, [self.baseUrl host]];
    NSString *bytesString = [NSString stringWithFormat:@"bytes=%@",rangeString]; //Reference to https://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.35
    NSString *objUrlString = [NSString stringWithFormat:@"/%@?formatter=json", path];
    
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
                              @"Content-Type": @"",
                              @"Range": bytesString,
                              };
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:objUrlString relativeToURL:self.baseUrl]];
    [request setHTTPMethod:@"GET"];
    
    [reqDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [request setValue:obj forHTTPHeaderField:key];
    }];
    [xamzDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [request setValue:obj forHTTPHeaderField:key];
    }];
    
    
    NSURLSessionDownloadTask *dt = [self.urlSessionManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull d) {
        downloadProgressBlock(d);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return destinationBlock(targetPath, response);
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        completionHandlerBlock(response, filePath, error);
    }];
    [dt resume];
    return dt;
}

- (NSURLSessionTask *)uploadFileWithData:(NSData *)fileData
                                    name:(NSString *)fileName
                                    mime:(NSString *)mime
                               underPath:(NSString *)path
                     optionRequestHeader:(NSDictionary *)option
                                progress:(void (^)(NSProgress *)) uploadProgressBlock
                       completionHandler:(void (^)(NSURLResponse *, id, NSError *))completionHandlerBlock {
    NSString *dateString = [ERS3Request currentDateStringUseHttpHeaderFormatter];
    NSString *filePath = [[NSString stringWithFormat:@"%@%@", path, fileName] URLEncodedString];
    NSString *fileLenString = [[NSNumber numberWithUnsignedInteger:[fileData length]] stringValue];
    NSString *canonicalizedResource = [NSString stringWithFormat:@"/%@/%@", _bucketName, filePath];
    NSString *hostString = [NSString stringWithFormat:@"%@.%@", _bucketName, [self.baseUrl host]];
    NSString *objUrlString = [NSString stringWithFormat:@"/%@?formatter=json", filePath];
    
    NSDictionary *xamzDict = @{
                               @"x-amz-date": dateString,
                               };
    
    NSString *authorizationValue = [ERS3Authorization authorizationValueWithAccessKey:kAccessKey
                                                                      SecretAccessKey:kSecretAccessKey
                                                                             HTTPVerb:@"PUT"
                                                                           ContentMD5:@""
                                                                          ContentType:mime
                                                                                 Date:@""
                                                              CanonicalizedAmzHeaders:[ERS3Authorization amzHeaderWithDictionary:xamzDict]
                                                                CanonicalizedResource:canonicalizedResource];
    
    NSDictionary *reqDict = @{
                              @"Authorization": authorizationValue,
                              @"Host": hostString,
                              @"Content-Type": mime,
                              @"Content-Length": fileLenString,
                              };
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:objUrlString relativeToURL:self.baseUrl]];
    [request setHTTPMethod:@"PUT"];
    
    [reqDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [request setValue:obj forHTTPHeaderField:key];
    }];
    [xamzDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [request setValue:obj forHTTPHeaderField:key];
    }];
    [option enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [request setValue:obj forHTTPHeaderField:key];
    }];
    
    NSURLSessionUploadTask *ut = [self.urlSessionManager uploadTaskWithRequest:request fromData:fileData progress:^(NSProgress * _Nonnull uploadProgress) {
        uploadProgressBlock(uploadProgress);
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        completionHandlerBlock(response, responseObject, error);
    }];
    [ut resume];
    return ut;
}

- (NSURLSessionTask *)uploadFileWithURL:(NSURL *)fileURL
                                   mime:(NSString *)mime
                              underPath:(NSString *)path
                     optionRequestHeader:(NSDictionary *)option
                                progress:(void (^)(NSProgress *)) uploadProgressBlock
                       completionHandler:(void (^)(NSURLResponse *, id, NSError *))completionHandlerBlock {
    NSString *dateString = [ERS3Request currentDateStringUseHttpHeaderFormatter];
    NSString *filePath = [[NSString stringWithFormat:@"%@%@", path, [fileURL lastPathComponent]] URLEncodedString];
    NSString *canonicalizedResource = [NSString stringWithFormat:@"/%@/%@", _bucketName, filePath];
    NSString *hostString = [NSString stringWithFormat:@"%@.%@", _bucketName, [self.baseUrl host]];
    NSString *objUrlString = [NSString stringWithFormat:@"/%@?formatter=json", filePath];
    
    NSDictionary *xamzDict = @{
                               @"x-amz-date": dateString,
                               };
    
    NSString *authorizationValue = [ERS3Authorization authorizationValueWithAccessKey:kAccessKey
                                                                      SecretAccessKey:kSecretAccessKey
                                                                             HTTPVerb:@"PUT"
                                                                           ContentMD5:@""
                                                                          ContentType:mime
                                                                                 Date:@""
                                                              CanonicalizedAmzHeaders:[ERS3Authorization amzHeaderWithDictionary:xamzDict]
                                                                CanonicalizedResource:canonicalizedResource];
    
    NSDictionary *reqDict = @{
                              @"Authorization": authorizationValue,
                              @"Host": hostString,
                              @"Content-Type": mime,
                              };
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:objUrlString relativeToURL:self.baseUrl]];
    [request setHTTPMethod:@"PUT"];
    
    [reqDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [request setValue:obj forHTTPHeaderField:key];
    }];
    [xamzDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [request setValue:obj forHTTPHeaderField:key];
    }];
    [option enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [request setValue:obj forHTTPHeaderField:key];
    }];
    
    
    
    NSURLSessionUploadTask *ut = [self.urlSessionManager uploadTaskWithRequest:request fromFile:fileURL progress:^(NSProgress * _Nonnull uploadProgress) {
        uploadProgressBlock(uploadProgress);
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        completionHandlerBlock(response, responseObject, error);
    }];
    [ut resume];
    return ut;
}

- (NSURLSessionTask *)createFolderWithName:(NSString *)folderName underPath:(NSString *)path optionRequestHeader:(NSDictionary *)option progress:(void (^)(NSProgress *))uploadProgressBlock completionHandler:(void (^)(NSURLResponse *, id, NSError *))completionHandlerBlock {
    
    NSString *fn = folderName;
    if ([folderName length] > 0 && [[folderName substringFromIndex:[folderName length] - 1] compare:@"/"] != NSOrderedSame) {
        fn = [folderName stringByAppendingString:@"/"];
    }
    return [self uploadFileWithData:[NSData data] name:fn mime:@"" underPath:path optionRequestHeader:option progress:uploadProgressBlock completionHandler:completionHandlerBlock];
}

- (NSURLSessionTask *)deleteAtPath:(NSString *)path
                          progress:(void (^)(NSProgress *)) progressBlock
                 completionHandler:(void (^)(NSURLResponse *, id, NSError *))completionHandlerBlock {
    path = [path URLEncodedString];
    NSString *dateString = [ERS3Request currentDateStringUseHttpHeaderFormatter];
    NSString *canonicalizedResource = [NSString stringWithFormat:@"/%@/%@", _bucketName, path];
    NSString *hostString = [NSString stringWithFormat:@"%@.%@", _bucketName, [self.baseUrl host]];
    NSString *objUrlString = [NSString stringWithFormat:@"/%@?formatter=json", path];
    
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
                              };
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:objUrlString relativeToURL:self.baseUrl]];
    [request setHTTPMethod:@"DELETE"];
    
    [reqDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [request setValue:obj forHTTPHeaderField:key];
    }];
    [xamzDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [request setValue:obj forHTTPHeaderField:key];
    }];
    
    
    NSURLSessionTask *t = [self.urlSessionManager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        if (progressBlock) {
            progressBlock(downloadProgress);
        }
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (completionHandlerBlock) {
            completionHandlerBlock(responseObject, responseObject, error);
        }
    }];
    
    [t resume];
    return t;
}
@end
