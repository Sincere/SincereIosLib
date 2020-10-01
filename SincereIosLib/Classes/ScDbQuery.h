//
//  ScDbQuery.h
//  fotocase
//
//  Created by Masamoto Miyata on 2012/12/10.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScLog.h"

@interface ScDbQuery : NSObject
{
    NSMutableString *_query;
    NSMutableArray *_values;
}

- (id)initWithQuery:(NSString *)query;
- (id)initWithQuery:(NSString *)query values:(NSArray *)values;

- (void)add:(NSString *)query;
- (void)add:(NSString *)query values:(NSArray *)values;
- (void)addQuery:(ScDbQuery *)query;

- (NSString *)render;
- (NSArray *)values;

@end
