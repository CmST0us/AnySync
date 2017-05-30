//
//  SinaStorageDirectory.h
//  AnySync
//
//  Created by CmST0us on 17/5/30.
//  Copyright © 2017年 CmST0us. All rights reserved.
//

#import "StorageDirectory.h"

@interface SinaStorageDirectory : StorageDirectory


- (void)addFileWithName:(NSString *)fileName
              infoDictionary:(NSDictionary *)infoDictionary;

- (void)addNextDirectoryWithName:(NSString *)directoryName
                  infoDictionary:(NSDictionary *)infoDictionary;

@end
