//
//  ScPagePath.m
//  fotocase
//
//  Created by Masamoto Miyata on 2012/11/12.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//

#import "ScPagePath.h"

@implementation ScPagePath

@synthesize index = _index;
@synthesize length = _length;

- (id)initWithIndex:(NSInteger)index length:(NSInteger)length
{
    self = [super init];
    
    if (self)
    {
        _index = index;
        _length = length;
    }
    
    return self;
    
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ index:%ld length:%ld", [super description], (long)_index, (long)_length];
}

- (BOOL)hasMore
{
    return _length > _index;
}

@end
