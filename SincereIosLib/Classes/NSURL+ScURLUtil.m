//
//  NSURL+ScURLUtil.m
//  sincere.ios.lib
//
//  Created by Masamoto Miyata on 2012/09/23.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//

#import "NSURL+ScURLUtil.h"

@implementation NSURL (ScURLUtil)
- (NSURL *)URLByAppendingQueryString:(NSString *)queryString
{
    if (![queryString length]) {
        return self;
    }
    
    NSString *URLString = [[NSString alloc] initWithFormat:@"%@%@%@", [self absoluteString],
                           [self query] ? @"&" : @"?", queryString];
    NSURL *theURL = [NSURL URLWithString:URLString];
    return theURL;
}

@end
