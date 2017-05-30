//
//  SinaStorageDirectory.m
//  AnySync
//
//  Created by CmST0us on 17/5/30.
//  Copyright © 2017年 CmST0us. All rights reserved.
//

#import "SinaStorageDirectory.h"
#import "SinaStorageFile.h"

@implementation SinaStorageDirectory


- (void)addFileWithName:(NSString *)fileName
              infoDictionary:(NSDictionary *)infoDictionary{
    SinaStorageFile *storageFile = [[SinaStorageFile alloc] initWithFileName:fileName infoDictionary:infoDictionary];
    [self addFile:storageFile];
}

- (void)addNextDirectoryWithName:(NSString *)directoryName
                  infoDictionary:(NSDictionary *)infoDictionary {
    SinaStorageDirectory *nextDirectory = [[SinaStorageDirectory alloc] init];
    [self addNextDirectory:nextDirectory];
}
@end
