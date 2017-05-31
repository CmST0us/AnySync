//
//  ERS3Authorization.h
//  extenFun
//
//  Created by CmST0us on 17/5/2.
//  Copyright © 2017年 CmST0us. All rights reserved.
//

#import <Foundation/Foundation.h>

#warning 导入配置
#include "sina.config"
//在sina.config文件中添加AccessKey和SecrectAccessKey
//static NSString *kSecretAccessKey = @"";
//static NSString *kAccessKey = @"";

@interface ERS3Authorization : NSObject
+ (NSString *)authorizationValueWithAccessKey:(NSString *)AccessKey
                              SecretAccessKey:(NSString *)SecretAccessKey
                                     HTTPVerb:(NSString *)HTTPVerb
                                   ContentMD5:(NSString *)ContentMD5
                                  ContentType:(NSString *)ContentType
                                         Date:(NSString *)Data
                      CanonicalizedAmzHeaders:(NSString *)CanonicalizedAmzHeaders
                        CanonicalizedResource:(NSString *)CanonicalizedResource;

+ (NSString *)amzHeaderWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)dictionaryKeySortUp:(NSDictionary *)tmpDict;
+ (NSString *)urlParamentWithDictionary:(NSDictionary *)dictionary;
@end
