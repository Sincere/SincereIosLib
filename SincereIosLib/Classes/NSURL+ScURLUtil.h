//
//  NSURL+ScURLUtil.h
//  sincere.ios.lib
//
//  Created by Masamoto Miyata on 2012/09/23.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (ScURLUtil)

- (NSURL *)URLByAppendingQueryString:(NSString *)queryString;

@end
