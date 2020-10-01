//
//  ScRemainingTimeCulc.h
//  fotocase
//
//  Created by Masamoto Miyata on 2012/12/09.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScLog.h"

@interface ScRemainingTimeCulc : NSObject
{
    NSDate *_originTime;
    NSDate *_lastUpdateTime;
    NSUInteger _remainingSec;
}

@property (nonatomic) double progress;
@property (nonatomic) NSTimeInterval updateInterval;
@property (strong, nonatomic) NSString *secFormat;
@property (strong, nonatomic) NSString *minFormat;

- (void)reset;
- (NSUInteger)remainingSec;
- (NSString *)formatedRemainingTime;

@end
