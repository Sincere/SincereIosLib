//
//  NSObject+ScRetainCount.h
//  fotocase
//
//  Created by Masamoto Miyata on 2012/12/31.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ScRetainCount)

- (int)retainCountOnARC;

@end
