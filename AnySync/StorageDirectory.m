//
//  StorageDirectory.m
//  AnySync
//
//  Created by CmST0us on 17/5/27.
//  Copyright © 2017年 CmST0us. All rights reserved.
//

#import "StorageDirectory.h"
#import "StorageFile.h"

@implementation StorageDirectory
#pragma mark - init method
- (instancetype)init {
    self = [super init];
    if (self) {
        _lastDirectory = NULL;
        _nextDirectories = [NSMutableDictionary dictionary];
        _files = [NSMutableDictionary dictionary];
        _name = @"";
    }
    return self;
}

#pragma mark public method
- (void)addFile:(StorageFile *)file {
    file.parentDirectory = self;
    [_files setObject:file forKey:file.name];
}

- (void)addNextDirectory:(StorageDirectory *)subDirectory {
    subDirectory.lastDirectory = self;
    [_nextDirectories setObject:subDirectory forKey:subDirectory.name];
}

- (BOOL)hasNextDirectory:(NSString *)nextDirectoryName {
    if ([_nextDirectories objectForKey:nextDirectoryName] == NULL) {
        return NO;
    }
    return YES;
}

- (BOOL)hasFile:(NSString *)fileName {
    if ([_files objectForKey:fileName] == NULL) {
        return NO;
    }
    return YES;
}

- (StorageDirectory *)nextDirectoryWithName:(NSString *)directoryName {
    return [_nextDirectories objectForKey:directoryName];
}

- (StorageFile *)fileWithName:(NSString *)fileName {
    return [_files objectForKey:fileName];
}
@end
