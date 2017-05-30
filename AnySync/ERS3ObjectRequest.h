//
//  ERS3ObjectRequest.h
//  extenFun
//
//  Created by CmST0us on 17/5/2.
//  Copyright © 2017年 CmST0us. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ERS3Request.h"

@interface ERS3ObjectRequest : ERS3Request

@property (nonatomic, readonly) NSString *bucketName;

- (instancetype)initWithBaseUrl:(NSString *)url
                     bucketName:(NSString *)bucketName;

- (NSURLSessionTask *)listMetaWithPath:(NSString *)path
                               success:(void (^)(NSURLSessionDataTask *task))success
                               failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (NSURLSessionTask *)downloadWithPath:(NSString *)path
                                 range:(NSString *)rangeString
                              progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock
                           destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destinationBlock
                     completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandlerBlock;

- (NSURLSessionTask *)uploadFileWithData:(NSData *)fileData
                                    name:(NSString *)fileName
                                    mime:(NSString *)mime
                               underPath:(NSString *)path
                     optionRequestHeader:(NSDictionary *)option
                                progress:(void (^)(NSProgress *uploadProgress)) uploadProgressBlock
                       completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandlerBlock;

- (NSURLSessionTask *)uploadFileWithURL:(NSURL *)fileURL
                                    mime:(NSString *)mime
                                underPath:(NSString *)path
                     optionRequestHeader:(NSDictionary *)option
                                progress:(void (^)(NSProgress *uploadProgress)) uploadProgressBlock
                       completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandlerBlock;


- (NSURLSessionTask *)createFolderWithName:(NSString *)folderName
                              underPath:(NSString *)path
                    optionRequestHeader:(NSDictionary *)option
                               progress:(void (^)(NSProgress *downloadProgress)) uploadProgressBlock
                      completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandlerBlock;

- (NSURLSessionTask *)deleteAtPath:(NSString *)path
                          progress:(void (^)(NSProgress *progress)) progressBlock
                 completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandlerBlock;
@end
