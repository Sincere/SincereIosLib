//
//  FcFileUtil.h
//  fotocase
//
//  Created by Masamoto Miyata on 2012/11/27.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ScLog.h"
#import "ScSystemVersion.h"
#include <sys/xattr.h>

@interface ScFileUtil : NSObject

+ (BOOL)createDirectoryIfNeed:(NSString *)path;
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;
+ (NSInteger)sizeOfPath:(NSString *)path;

@end
