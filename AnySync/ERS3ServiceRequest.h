//
//  ERS3ServiceRequest.h
//  extenFun
//
//  Created by CmST0us on 17/5/2.
//  Copyright © 2017年 CmST0us. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ERS3Request.h"

@interface ERS3ServiceRequest : ERS3Request

- (NSURLSessionDataTask *)listBucketsWithProgress:(void (^)(NSProgress *progress))downloadProgress
                                          success:(void (^)(NSURLSessionDataTask *dataTask, NSDictionary *bucketsDictionary))success
                                          failure:(void (^)(NSURLSessionDataTask *dataTask, NSError *error))failure;

@end
