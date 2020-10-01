//
//  ScPagePath.h
//  fotocase
//
//  Created by Masamoto Miyata on 2012/11/12.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScPagePath : NSObject
{
    NSInteger _index;
    NSInteger _length;
}

@property(nonatomic, readonly) NSInteger index;
@property(nonatomic, readonly) NSInteger length;

- (id)initWithIndex:(NSInteger)index length:(NSInteger)length;
- (BOOL)hasMore;

@end
