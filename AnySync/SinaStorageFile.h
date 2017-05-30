//
//  SinaStorageFile.h
//  AnySync
//
//  Created by CmST0us on 17/5/30.
//  Copyright © 2017年 CmST0us. All rights reserved.
//

#import "StorageFile.h"

@interface SinaStorageFile : StorageFile

@property (nonatomic, readonly) NSDictionary *infoDictionary;

+ (instancetype)storageFileWithInfoDictionary:(NSDictionary *)dictionary;

- (instancetype)initWithInfoDictionary:(NSDictionary *)dictionary;
- (instancetype)initWithFileName:(NSString *)fileName
                   infoDictionary:(NSDictionary *)dictionary;

@end
