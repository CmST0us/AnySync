//
//  ERS3Authorization.m
//  extenFun
//
//  Created by CmST0us on 17/5/2.
//  Copyright © 2017年 CmST0us. All rights reserved.
//

#import "ERS3Authorization.h"
#import <CommonCrypto/CommonHMAC.h>
@implementation ERS3Authorization

+ (NSString *)hmacsha1:(NSString *)string secret:(NSString *)key {
    
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [string cStringUsingEncoding:NSASCIIStringEncoding];
    
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    
    NSString *hash = [HMAC base64EncodedStringWithOptions:(NSDataBase64EncodingOptions)0];
    
    return hash;
}

+ (NSString *)authorizationValueWithAccessKey:(NSString *)AccessKey SecretAccessKey:(NSString *)SecretAccessKey HTTPVerb:(NSString *)HTTPVerb ContentMD5:(NSString *)ContentMD5 ContentType:(NSString *)ContentType Date:(NSString *)Data CanonicalizedAmzHeaders:(NSString *)CanonicalizedAmzHeaders CanonicalizedResource:(NSString *)CanonicalizedResource{
    
    NSString *stringToSign = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@%@", HTTPVerb, ContentMD5, ContentType, Data, CanonicalizedAmzHeaders, CanonicalizedResource];
    
    NSString *signature = [self hmacsha1:stringToSign secret:SecretAccessKey];
    NSString *ssig = [signature substringWithRange:NSMakeRange(5, 10)];
    NSString *ret = [[NSString alloc]initWithFormat:@"SINA %@:%@", AccessKey, ssig];
    return ret;
}

+ (NSString *)amzHeaderWithDictionary:(NSDictionary *)dictionary {
    NSMutableDictionary *tmpDict = [NSMutableDictionary dictionary];
    NSMutableString *tmpString = [NSMutableString string];
    
    //小写key
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *lowerString = [key lowercaseString];
        [tmpDict setObject:obj forKey:lowerString];
    }];
    //key 字典序排序
    NSArray *sortArray = [[tmpDict allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    [sortArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [tmpString appendFormat:@"%@:%@\n", obj, (NSString *)[tmpDict objectForKey:obj]];
    }];

    return tmpString;
}

+ (NSArray *)dictionaryKeySortUp:(NSDictionary *)tmpDict {
    NSArray *sortArray = [[tmpDict allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    return sortArray;
}

+ (NSString *)urlParamentWithDictionary:(NSDictionary *)dictionary {
    NSArray *sortKey = [self dictionaryKeySortUp:dictionary];
    
    NSMutableString *s= [[NSMutableString alloc] initWithString:@"?"];
    [sortKey enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [s appendFormat:@"%@=%@&", obj, [dictionary objectForKey:obj]];
    }];
    NSString *r = [s substringWithRange:NSMakeRange(0, [s length] == 0 ? 0 : [s length] - 1)];
    return r;
}
@end
