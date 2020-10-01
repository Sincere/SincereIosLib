//
//  ScDb.m
//  sincere.ios.lib
//
//  Created by Masamoto Miyata on 2012/11/20.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//

#import "ScDb.h"

@implementation ScDb

-(id)initWithPath:(NSString *)path fromTemplatePath:(NSString *)templatePath
{
    self = [super init];
	if (self != nil)
    {
        NSFileManager *fm = [NSFileManager defaultManager];
        
        _databasePath = path;
        _templatePath = templatePath;
        BOOL __unused res;
        
        //dbが存在してなかったらここが呼ばれて、作成したDBをコピー
        if(![fm fileExistsAtPath:_databasePath])
        {
            //templateDb存在チェック
            res = [fm fileExistsAtPath:_templatePath];
            NSAssert1(res, @"TemplateDatabase %@ is not exists.", _templatePath);
            
            NSError *error;
            res = [fm copyItemAtPath:_templatePath toPath:_databasePath error:&error];
            NSAssert3(res, @"Fail to create database %@ from %@ by [%@]",  _databasePath, _templatePath, [error localizedDescription]);
            
            ScLog(@"Create database %@ from %@", _databasePath, _templatePath);
        }
        
        _db = [FMDatabase databaseWithPath:_databasePath];
        res = [_db open];
        NSAssert1(res, @"Fail to open database %@", _databasePath);
        
        ScLog(@"Open database %@", _databasePath);
	}
	return self;
}

-(void)close
{
    BOOL __unused res = [_db close];
    NSAssert1(res, @"You can't close connection %@", [self description]);
}

-(void)drop
{
    [self close];
    
    NSError *error;
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL __unused res = [fm removeItemAtPath:_databasePath error:&error];
    NSAssert2(res, @"Fail to drop database %@ by %@", _databasePath, [error localizedDescription]);
    
    ScLog(@"Drop database %@", _databasePath);
}

- (BOOL)exists:(ScDbQuery*)sql
{
    ScLog(@"%@", sql);
    ScDbResultSet *rs = [self executeQuery:sql];
    
    BOOL exists = [rs next];
    
    [rs close];
    
    return exists;
}


- (void)executeUpdate:(ScDbQuery *)sql;
{
    ScLog(@"%@", sql);
    BOOL __unused res = [_db executeUpdate:[sql render] withArgumentsInArray:[sql values]];
    NSAssert(res, [[_db lastError] localizedDescription]);
}

- (ScDbResultSet *)executeQuery:(ScDbQuery *)sql
{
    ScLog(@"%@", sql);
    
    ScDbResultSet *rs = [[ScDbResultSet alloc]init];
    [rs setResultSet:[_db executeQuery:[sql render] withArgumentsInArray:[sql values]]];
    NSAssert2([_db lastErrorCode] == 0, @"%@ %@", [_db lastError], sql);

    return rs;
}

- (NSString *)fetchOne:(ScDbQuery *)query
{
    ScDbResultSet *rs = [self executeQuery:query];
    [rs next];
    
    return [rs stringForColumnIndex:0];
}

- (NSMutableArray *)fetchCol:(ScDbQuery *)query
{
    NSMutableArray *cols = [[NSMutableArray alloc]init];
    ScDbResultSet *rs = [self executeQuery:query];
    while ([rs next])
    {
        [cols addObject:[rs stringForColumnIndex:0]];
    }
    
    [rs close];
    
    return cols;
}

- (NSMutableDictionary *)fetchPair:(ScDbQuery *)query
{
    NSMutableDictionary *pair = [[NSMutableDictionary alloc]init];
    ScDbResultSet *rs = [self executeQuery:query];
    while ([rs next])
    {
        [pair setObject:[rs stringForColumnIndex:1] forKey:[rs stringForColumnIndex:0]];
    }
    
    [rs close];
    
    return pair;
    
}

- (NSMutableArray *)fetchRecords:(ScDbQuery *)query recordName:(NSString *)recordName
{
    NSMutableArray *records = [[NSMutableArray alloc]init];
    ScDbResultSet *rs = [self executeQuery:query];
    while ([rs next])
    {
        id rec = [[NSClassFromString(recordName) alloc]initWithDictionary:[rs resultDictionary]];
        NSAssert1(rec != nil, @"%@ record class is not exists", recordName);
        [records addObject:rec];
    }
    
    [rs close];
    
    return records;
}

- (id)findRecord:(ScDbQuery *)query recordName:(NSString *)recordName
{
    ScDbResultSet *rs = [self executeQuery:query];
    id rec = nil;
    while([rs next])
    {
        NSAssert1(rec == nil, @"ResultSet has multilple records %@", rec);
        rec = [[NSClassFromString(recordName) alloc]initWithDictionary:[rs resultDictionary]];
        NSAssert1(rec != nil, @"%@ record class is not exists", recordName);
    }
    
    [rs close];
    
    return rec;
}

- (NSDictionary *)findDictionary:(ScDbQuery *)query
{
    ScDbResultSet *rs = [self executeQuery:query];
    [rs next];
    NSDictionary *dic = [rs resultDictionary];
    [rs close];
    return dic;
}

- (void)rollback
{
    BOOL __unused res = [_db rollback];
    NSAssert(res, [[_db lastError] localizedDescription]);
    
    ScLog(@"rollback");
}

- (void)commit
{
    BOOL __unused res = [_db commit];
    NSAssert(res, [[_db lastError] localizedDescription]);
    
    ScLog(@"commit");
}

- (void)beginTransaction
{
    BOOL __unused res = [_db beginTransaction];
    NSAssert(res, [[_db lastError] localizedDescription]);
    
    ScLog(@"beginTransaction");
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@[%@]", [super description], _databasePath];
}

@end
