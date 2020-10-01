//
//  ScRemainingTimeCulc.m
//  fotocase
//
//  Created by Masamoto Miyata on 2012/12/09.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//

#import "ScRemainingTimeCulc.h"

@implementation ScRemainingTimeCulc

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        self.updateInterval = 0.5;
    }
    return self;
}

- (void)reset
{
    _originTime = [NSDate date];
}

- (NSUInteger)remainingSec
{
    NSDate *current = [NSDate date];
    if(_lastUpdateTime == nil || [current timeIntervalSinceDate:_lastUpdateTime] > self.updateInterval)
    {
        NSAssert(_originTime != nil, @"Origin time is empty.You must call reset before this.");
        _lastUpdateTime = current;
        double rest = 1.0 - self.progress;
        double elapsedTime = [current timeIntervalSinceDate:_originTime];
        
        _remainingSec = (NSUInteger)round(rest * (elapsedTime / self.progress));
    }
    
    return _remainingSec;
}

- (NSString *)formatedRemainingTime
{
    if([[NSDate date] timeIntervalSinceDate:_originTime] < 2)
    {
        NSAssert(self.secFormat != nil, @"Second format is empty.");
        return [NSString stringWithFormat:self.secFormat, @"---"];
    }
    
    NSUInteger sec = [self remainingSec];
    if(sec >= 90)
    {
        NSAssert(self.minFormat != nil, @"Minute format is empty.");
        NSString *value = [NSString stringWithFormat:@"%d", (int)round((double) sec / 60.0)];
        return [NSString stringWithFormat:self.minFormat, value];
    }
    else
    {
        NSAssert(self.secFormat != nil, @"Second format is empty.");
        return [NSString stringWithFormat:self.secFormat, [NSString stringWithFormat:@"%lu", (unsigned long)sec]];
    }
}

@end
