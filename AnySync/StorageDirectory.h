//
//  StorageDirectory.h
//  AnySync
//
//  Created by CmST0us on 17/5/27.
//  Copyright © 2017年 CmST0us. All rights reserved.
//

#import <Foundation/Foundation.h>

@class StorageFile;

@interface StorageDirectory : NSObject

@property (nonatomic, strong) StorageDirectory *lastDirectory;
@property (nonatomic, strong) NSMutableDictionary<NSString *, StorageDirectory *> *nextDirectories;
@property (nonatomic, strong) NSMutableDictionary<NSString *, StorageFile *> *files;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSDate *modifyDate;
@property (nonatomic, assign) BOOL isLastDirectoryInDictionary;

- (void)addNextDirectory:(StorageDirectory *)subDirectory;
- (void)addFile:(StorageFile *)file;

- (StorageDirectory *)nextDirectoryWithName:(NSString *)directoryName;
- (StorageFile *)fileWithName:(NSString *)fileName;

- (BOOL)hasNextDirectory:(NSString *)nextDirectoryName;
- (BOOL)hasFile:(NSString *)fileName;

@end
