//
//  ScTotemHolder.m
//  fotocase_note
//
//  Created by Miyata Keizo on 2012/08/16.
//  Copyright (c) 2012年 Miyata Keizo. All rights reserved.
//

#import "ScTreeHolder.h"

@implementation ScTreeHolder

- (id) init
{
    self = [super init];
    if(self != nil)
    {
        _children = [[NSMutableArray alloc] init];
        _keyValue = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (id)initWithValue: (id) value forKey: (NSString *)key
{
    ScTreeHolder *_self = [self init];
    if(_self != nil)
    {
        [_self setValue:value forKey:key];
    }
    
    return _self;
}

- (void)addChild:(ScTreeHolder *)child
{
    if(child.parent)
    {
        [NSException raise:@"ScTreeHolderException" format:@"[%@] already has parent.", child];
        //[child.parent removeChild:child];
    }
    
    child.parent = self;
    [_children addObject: child];
}

- (void) removeChildAtIndex: (NSInteger) index
{
    ScTreeHolder *child = [_children objectAtIndex:index];
    child.parent = nil;
    [_children removeObjectAtIndex:index];
}

- (void) removeChild: (ScTreeHolder *) child
{
    NSInteger index = [_children indexOfObject: child];
    if(index != NSNotFound)
    {
        [self removeChildAtIndex:index];
    }
}

- (ScTreeHolder *)childAtIndex: (NSInteger) index
{
    return [_children objectAtIndex:index];
}

- (void) setValue:(id)value forUndefinedKey:(NSString *)key
{
    [_keyValue setObject:value forKey:key];
}

- (id) valueForUndefinedKey:(NSString *)key
{
    return [_keyValue objectForKey:key];
}

- (NSInteger) childCount
{
    return _children.count;
}

- (void) removeValueForKey: (NSString *) key
{
    [_keyValue removeObjectForKey:key];
}

@end
