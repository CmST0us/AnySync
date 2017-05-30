//
//  SinaStorageDataModel.h
//  AnySync
//
//  Created by CmST0us on 17/5/27.
//  Copyright © 2017年 CmST0us. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SinaStorageDataModel : NSObject

- (instancetype)initWithContentsArray:(NSArray *)contentsArray;
+ (instancetype)dataModelWithContentsArray:(NSArray *)contentsArray;
+ (instancetype)dataModel;

- (void)feedContentsArray:(NSArray *)contentsArray;

- (void)changeDirectoryToNextDirectoryWithName:(NSString *)nextDirectoryName;
- (void)changeDirectoryToRoot;

@end
