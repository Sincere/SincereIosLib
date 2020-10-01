//
//  NSString+ScStringUtil.m
//  fotocase_note
//
//  Created by Masamoto Miyata on 2012/09/25.
//  Copyright (c) 2012年 Miyata Keizo. All rights reserved.
//

#import "NSString+ScStringUtil.h"

@implementation NSString (ScStringUtil)

- (NSString*)stringUrlEncoded
{
    return [self stringByAddingPercentEncodingWithAllowedCharacters: [NSCharacterSet alphanumericCharacterSet]];
}

- (BOOL)isEqualAsQueryString:(NSString *)queryString
{
    NSArray *selfArray = [self componentsSeparatedByString: @"&"];
    NSArray *targetArray = [queryString componentsSeparatedByString:@"&"];
    
    if([selfArray count] != [targetArray count])
    {
        return NO;
    }
    
    selfArray = [selfArray sortedArrayUsingSelector:@selector(compare:)];
    targetArray = [targetArray sortedArrayUsingSelector:@selector(compare:)];
    
    for (int i=0; i < [selfArray count]; i++)
    {
        if(![[selfArray objectAtIndex:i] isEqual:[targetArray objectAtIndex:i]])
        {
            return NO;
        }
    }
    
    return YES;
}

- (NSArray *)componentsSeparatedByLength:(NSInteger)length
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    int len=0;
    
    while( (len + length)<[self length])
    {
        [array addObject:[self substringWithRange:NSMakeRange(len, length)]];
        len += (length);
    }
    
    [array addObject:[self substringFromIndex:len]];
    
    return array;
}

- (NSString *)ucfirst
{
    return [self stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[self  substringToIndex:1] capitalizedString]];
}
    
@end
