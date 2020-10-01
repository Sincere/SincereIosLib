//
//  ScDbRecord.h
//  fotocase
//
//  Created by Masamoto Miyata on 2012/11/24.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScLog.h"

@interface ScDbRecord : NSObject<NSCoding>
{
    NSMutableDictionary *_values;
}

- (id)initWithDictionary:(NSDictionary *)dictionary;

- (id)get:(NSString *)name;
- (void)set:(id)value forKey:(NSString *)key;
- (NSString *)formatedDate:(NSString *)column format:(NSString *)format;
//- (BOOL)is:(NSString *)key;
//- (void)setBool:(BOOL)value forKey:(NSString *)key;

@end
