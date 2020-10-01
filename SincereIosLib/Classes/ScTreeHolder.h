//
//  ScTotemHolder.h
//  fotocase_note
//
//  Created by Miyata Keizo on 2012/08/16.
//  Copyright (c) 2012年 Miyata Keizo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScTreeHolder : NSObject
{
    @private
    NSMutableArray *_children;
    NSMutableDictionary *_keyValue;
}
@property (nonatomic, weak) ScTreeHolder* parent;
@property (nonatomic, readonly) NSInteger childCount;
- (id)initWithValue: (id) value forKey: (NSString *)key;
- (void)addChild:(ScTreeHolder *)holder;
- (ScTreeHolder *)childAtIndex: (NSInteger) index;
- (void) removeChildAtIndex: (NSInteger) index;
- (void) removeChild: (ScTreeHolder *) child;
- (void) removeValueForKey: (NSString *) key;
@end
