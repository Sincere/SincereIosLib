//
//  ScDb.h
//  sincere.ios.lib
//
//  Created by Masamoto Miyata on 2012/11/20.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "ScLog.h"
#import "ScDbResultSet.h"
#import "NSData+ScDataShortDescription.h"
#import "ScDbQuery.h"
#import "ScDbRecord.h"

@class ScDbResultSet;
@interface ScDb : NSObject
{
    @private
    NSString *_templatePath;
    NSString *_databasePath;
    FMDatabase *_db;
}


- (id)initWithPath:(NSString *)path fromTemplatePath:(NSString *)templatePath;
- (void)close;
- (void)drop;

- (NSString *)fetchOne:(ScDbQuery *)query;
- (NSMutableArray *)fetchCol:(ScDbQuery *)query;
- (NSMutableDictionary *)fetchPair:(ScDbQuery *)query;
- (NSMutableArray *)fetchRecords:(ScDbQuery *)query recordName:(NSString *)recordName;
- (id)findRecord:(ScDbQuery *)query recordName:(NSString *)recordName;
- (NSDictionary *)findDictionary:(ScDbQuery *)query;

- (BOOL)exists:(ScDbQuery*)sql;

- (ScDbResultSet *)executeQuery:(ScDbQuery *)sql;

- (void)executeUpdate:(ScDbQuery *)sql;


- (void)rollback;
- (void)commit;
- (void)beginTransaction;
@end
