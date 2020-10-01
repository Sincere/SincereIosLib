//
//  ScDebug.h
//  sincere.ios.lib
//
//  Created by Masamoto Miyata on 2012/11/04.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//
#import <Foundation/Foundation.h>
#ifndef sincere_ios_lib_ScDebug_h
#define sincere_ios_lib_ScDebug_h

#ifdef DEBUG
#define ScLog(s, ...) NSLog(@"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])
#else
#define ScLog(s, ...)
#endif

#endif

NSString* ScStringFromBOOL(BOOL value);

void ScMemoryReport();
