//
//  ScDbResultSet.h
//  sincere.ios.lib
//
//  Created by Masamoto Miyata on 2012/11/20.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "ScDb.h"

@interface ScDbResultSet : NSObject
{
    FMResultSet *_resultSet;
    BOOL _closed;
}

- (void)setResultSet:(FMResultSet *)resultSet;

- (BOOL)next;

- (void)close;

- (NSString*)stringForColumnIndex:(int)columnIndex;
- (NSString*)stringForColumn:(NSString*)columnName;
- (int)intForColumn:(NSString*)columnName;
- (NSDictionary*)resultDictionary;

- (NSMutableArray*)arrayOfStringForColumn:(NSString*)columnName;

@end
