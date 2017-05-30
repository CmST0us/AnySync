//
//  StorageFile.h
//  AnySync
//
//  Created by CmST0us on 17/5/27.
//  Copyright © 2017年 CmST0us. All rights reserved.
//

#import <Foundation/Foundation.h>
@class StorageDirectory;
@interface StorageFile : NSObject

@property (nonatomic, strong) StorageDirectory *parentDirectory;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *contentType;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) NSString *SHA1;
@property (nonatomic, copy) NSString *expirationTime;
@property (nonatomic, copy) NSString *lastModified;
@property (nonatomic, copy) NSString *owner;
@property (nonatomic, copy) NSString *MD5;
@property (nonatomic, assign) NSUInteger size;

@end
