//
//  ScBenchmark.h
//  fotocase
//
//  Created by Masamoto Miyata on 2012/11/28.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScLog.h"

@interface ScBenchmark : NSObject
{
    NSDate *_statTime;
}

- (NSString *)formatedSec;
- (void)logSec;
+ (ScBenchmark *) sharedInstance;

@end
