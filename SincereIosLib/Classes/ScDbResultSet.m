//
//  ScDbResultSet.m
//  sincere.ios.lib
//
//  Created by Masamoto Miyata on 2012/11/20.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//

#import "ScDbResultSet.h"

@implementation ScDbResultSet

- (void)setResultSet:(FMResultSet *)resultSet
{
    if(_resultSet && !_closed)
    {
        [self close];
    }
    
    _closed = NO;
    _resultSet = resultSet;
}

- (BOOL)next
{
    NSAssert(!_closed, @"This set is already closed.");
    
    return [_resultSet next];
}

- (void)close
{
    _closed = YES;
    [_resultSet close];
}

- (int)intForColumn:(NSString*)columnName
{
    return [_resultSet intForColumn:columnName];
}

- (NSString*)stringForColumn:(NSString*)columnName
{
    return [_resultSet stringForColumn:columnName];
}

- (NSString*)stringForColumnIndex:(int)columnIndex
{
    return [_resultSet stringForColumnIndex:columnIndex];
}

- (NSDictionary*)resultDictionary
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    int count = [_resultSet columnCount];
    for (int i = 0; i < count; i++)
    {
        NSString *columnName = [_resultSet columnNameForIndex:i];
        NSString *value = [_resultSet stringForColumn:columnName];
        if(value != nil)
        {
            [dic setObject:value forKey:columnName];
        }
        
    }
    
    return dic;
}

- (NSMutableArray*)arrayOfStringForColumn:(NSString*)columnName
{
    NSMutableArray *values = [[NSMutableArray alloc]init];
    while ([self next])
    {
        [values addObject:[self stringForColumn:columnName]];
    }
    
    [self close];
    
    return values;
}

@end
