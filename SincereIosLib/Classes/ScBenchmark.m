//
//  ScBenchmark.m
//  fotocase
//
//  Created by Masamoto Miyata on 2012/11/28.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//

#import "ScBenchmark.h"

@implementation ScBenchmark

static ScBenchmark *_sharedInstance;

+ (ScBenchmark *) sharedInstance
{
    @synchronized(self)
    {
        if(_sharedInstance == nil)
        {
            _sharedInstance = [[ScBenchmark alloc] init];
        }
        else
        {
            [_sharedInstance reset];
        }
    }
    
    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        _statTime = [NSDate date];
    }
    return self;
}

- (NSString *)formatedSec;
{
    NSAssert(_statTime != nil, @"Start time is nil.Call to reset method before this.");
    NSDate *now = [NSDate date];
    return [NSString stringWithFormat:@"%1.5fsec", [now timeIntervalSinceDate:_statTime]];
}

- (void)logSec
{
    ScLog(@"SdxBenchmark %@", [self formatedSec]);
}

#pragma mark - private
- (void)reset
{
    _statTime = nil;
    _statTime = [NSDate date];
}

@end
