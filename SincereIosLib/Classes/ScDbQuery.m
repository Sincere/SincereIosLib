//
//  ScDbQuery.m
//  fotocase
//
//  Created by Masamoto Miyata on 2012/12/10.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//

#import "ScDbQuery.h"

@implementation ScDbQuery

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        _query = [[NSMutableString alloc]init];
        _values = [[NSMutableArray alloc]init];
    }
    return self;
}

- (id)initWithQuery:(NSString *)query
{
    self = [self init];
    if (self != nil)
    {
        [self add:query];
    }
    return self;
}

- (id)initWithQuery:(NSString *)query values:(NSArray *)values;
{
    self = [self init];
    if (self != nil)
    {
        [self add:query values:values];
    }
    return self;
}

- (void)add:(NSString *)query
{
    [_query appendString:query];
}

- (void)add:(NSString *)query values:(NSArray *)values
{
    int index = 0;
    for (id value in values)
    {
        if([value isKindOfClass:[NSString class]])
        {
            if([value isEqualToString:@"<null>"])
            {
                NSMutableArray *split = [NSMutableArray arrayWithArray:[query componentsSeparatedByString:@"?"]];
                [split setObject:[NSString stringWithFormat:@"%@NULL%@", [split objectAtIndex:index], [split objectAtIndex:index + 1]] atIndexedSubscript:index];
                [split removeObjectAtIndex:index + 1];
                query = [split componentsJoinedByString:@"?"];
                
                --index;
            }
            else
            {
                [_values addObject:value];
            }
        }
        else if([value isKindOfClass:[NSArray class]])
        {
            query = [self replaceInStatement:query values:value];
            [_values addObjectsFromArray:value];
        }
        
    
        ++index;
    }

    

    [self add:query];
}

- (NSString *)render
{
    return _query;
}

- (NSArray *)values
{
    return _values;
}

- (NSString *)description
{
    if([_values count] > 0)
    {
        return [NSString stringWithFormat:@"%@ %@", _query, _values];
    }
    else
    {
        return [NSString stringWithFormat:@"%@", _query];
    }
}

- (void)addQuery:(ScDbQuery *)query
{
    [self add:[query render] values:[query values]];
}

#pragma mark - private
- (NSString *)replaceInStatement:(NSString *)query values:(NSArray *)values
{
    
    NSMutableString *inStatement = [NSMutableString stringWithCapacity:100];
    [inStatement appendString:@"(?"];
    for (int i = 0; i < [values count] - 1; i++)
    {
        [inStatement appendString:@", ?"];
    }
    
    [inStatement appendString:@")"];
    
    NSRange first = [query rangeOfString:@"(?)"];
    NSAssert(first.location != NSNotFound, @"Not found (?)");
    
    return [query stringByReplacingCharactersInRange:first withString:inStatement];
}

@end
