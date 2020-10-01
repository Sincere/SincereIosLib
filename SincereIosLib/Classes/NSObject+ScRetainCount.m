//
//  NSObject+ScRetainCount.m
//  fotocase
//
//  Created by Masamoto Miyata on 2012/12/31.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//

#import "NSObject+ScRetainCount.h"

@implementation NSObject (ScRetainCount)

- (int)retainCountOnARC
{
    return (int)CFGetRetainCount((__bridge CFTypeRef)self);
}

@end
