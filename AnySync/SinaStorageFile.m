//
//  SinaStorageFile.m
//  AnySync
//
//  Created by CmST0us on 17/5/30.
//  Copyright © 2017年 CmST0us. All rights reserved.
//

#import "SinaStorageFile.h"

@implementation SinaStorageFile

#pragma mark - class method
+ (instancetype)storageFileWithInfoDictionary:(NSDictionary *)dictionary {
    SinaStorageFile *storageFile = [[SinaStorageFile alloc] initWithInfoDictionary:dictionary];
    return storageFile;
}

#pragma mark - init method
- (instancetype)initWithInfoDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _infoDictionary = [dictionary copy];
        self.path = [_infoDictionary objectForKey:@"Name"];
        self.SHA1 = [_infoDictionary objectForKey:@"SHA1"];
        self.expirationTime = [_infoDictionary objectForKey:@"Expiration-Time"];
        self.lastModified = [_infoDictionary objectForKey:@"Last-Modified"];
        self.owner = [_infoDictionary objectForKey:@"Owner"];
        self.MD5 = [_infoDictionary objectForKey:@"MD5"];
        self.contentType = [_infoDictionary objectForKey:@"Content-Type"];
        NSNumber *sizeNumber = [_infoDictionary objectForKey:@"Size"];
        self.size = [sizeNumber unsignedIntegerValue];
    }
    return self;
}

- (instancetype)initWithFileName:(NSString *)fileName
                  infoDictionary:(NSDictionary *)dictionary {
    self = [self initWithInfoDictionary:dictionary];
    if (self) {
        self.name = fileName;
    }
    return self;
}
@end
