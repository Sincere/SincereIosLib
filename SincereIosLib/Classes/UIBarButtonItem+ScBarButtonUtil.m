//
//  UIBarButtonItem+ScBarButtonUtil.m
//  fotocase_note
//
//  Created by Masamoto Miyata on 2012/11/03.
//  Copyright (c) 2012年 Miyata Keizo. All rights reserved.
//

#import "UIBarButtonItem+ScBarButtonUtil.h"

@implementation UIBarButtonItem (ScBarButtonUtil)

- (UIView *)wrapperView
{
    return (UIView *)[self valueForKey:@"view"];
}

@end
