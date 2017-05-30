//
//  SinaStorageDataModel.m
//  AnySync
//
//  Created by CmST0us on 17/5/27.
//  Copyright © 2017年 CmST0us. All rights reserved.
//

#import "SinaStorageDataModel.h"
#import "SinaStorageFile.h"
#import "SinaStorageDirectory.h"

@interface SinaStorageDataModel () {
    SinaStorageDirectory *_rootDirectory;
    SinaStorageDirectory *_currentDirectory;
}

@end

@implementation SinaStorageDataModel

#pragma mark - class method

+ (instancetype)dataModelWithContentsArray:(NSArray *)contentsArray {
    return [[SinaStorageDataModel alloc] initWithContentsArray:contentsArray];
}

+ (instancetype)dataModel {
    return [[SinaStorageDataModel alloc] init];
}

#pragma mark - init method

- (instancetype)init {
    self = [super init];
    if (self) {
        _rootDirectory = [[SinaStorageDirectory alloc] init];
        _currentDirectory = _rootDirectory;
        _isLastDirectoryInDictionary = NO;
        _rootDirectory.isLastDirectoryInDictionary = _isLastDirectoryInDictionary;
    }
    return self;
}

- (instancetype)initWithContentsArray:(NSArray *)contentsArray {
    self = [self init];
    if (self) {
        [self feedContentsArray:contentsArray];
    }
    return self;
}

#pragma mark data source feed method

- (void)feedContentsArray:(NSArray *)contentsArray {
    for (NSDictionary *item in contentsArray) {
        SinaStorageDirectory *pCurrentDirectory = _rootDirectory;
        NSString *objPath = [item objectForKey:@"Name"];
        NSString *fileName = [self _parsePathForFileName:objPath];
        NSArray *directoryArray = [self _parsePathToDirectoryNameArray:objPath];
                                   
        if ([directoryArray count] == 0) {
            //在根目录
            [pCurrentDirectory addFileWithName:fileName infoDictionary:item];
            continue;
        }
        SinaStorageDirectory *next;
        for (NSString *directoryName in directoryArray) {
            //判断目录是否存在
            if (![pCurrentDirectory hasNextDirectory:directoryName]){
                //不存在
#warning 搜集目录信息TODO
                next = [[SinaStorageDirectory alloc] init];
                next.isLastDirectoryInDictionary = _isLastDirectoryInDictionary;
                next.name = directoryName;
                [pCurrentDirectory addNextDirectory:next];
            }
            next = (SinaStorageDirectory *)[pCurrentDirectory nextDirectoryWithName:directoryName];
            pCurrentDirectory = next;
        }
        if (![self _isPathDirectory:objPath]) {
            //添加文件
            [pCurrentDirectory addFileWithName:fileName infoDictionary:item];
        }
    }
}

#pragma mark - instance method
- (void)changeDirectoryToPathFromRoot:(NSString *)path {
    __weak typeof(self) weakSelf = self;
    
    NSArray *directoryHierarchy = [self _parsePathToDirectoryNameArray:path];
    [self changeDirectoryToRoot];
    [directoryHierarchy enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [weakSelf changeDirectoryToNextDirectoryWithName:obj];
    }];
}

- (void)changeDirectoryToPathFromCurrentDirectory:(NSString *)path {
    __weak typeof(self) weakSelf = self;
    
    NSArray *directoryHierarchy = [self _parsePathToDirectoryNameArray:path];
    [directoryHierarchy enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [weakSelf changeDirectoryToNextDirectoryWithName:obj];
    }];
}
- (void)changeDirectoryToNextDirectoryWithName:(NSString *)nextDirectoryName {
    _currentDirectory = (SinaStorageDirectory *)[_currentDirectory nextDirectoryWithName:nextDirectoryName];
}

- (void)changeDirectoryToRoot {
    _currentDirectory = _rootDirectory;
}

- (NSArray<SinaStorageDirectory *> *)directories {
    return (NSArray<SinaStorageDirectory *> *)[[_currentDirectory nextDirectories] allValues];
}

- (NSArray<SinaStorageFile *> *)files {
    return (NSArray<SinaStorageFile *> *)[[_currentDirectory files] allValues];
}


#pragma mark - setter method

#pragma mark - getter method

#pragma mark - private method

- (BOOL)_isPathDirectory:(NSString *)path {
    if ([[path substringFromIndex:[path length] - 1] compare:@"/"] == NSOrderedSame) {
        return YES;
    }
    return NO;
}

- (NSString *)_parsePathForFileName:(NSString *)path {
    return [[path componentsSeparatedByString:@"/"] lastObject];
}

- (NSArray *)_parsePathToDirectoryNameArray:(NSString *)path {
    NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithArray:[path componentsSeparatedByString:@"/"]];
    [tmpArray removeLastObject];
    return tmpArray;
}

@end
