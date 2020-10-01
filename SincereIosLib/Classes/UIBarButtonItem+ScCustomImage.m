//
//  UIBarButtonItem+ScCustomImage.m
//  fotocase
//
//  Created by Masamoto Miyata on 2013/01/18.
//  Copyright (c) 2013年 Masamoto Miyata. All rights reserved.
//

#import "UIBarButtonItem+ScCustomImage.h"

@implementation UIBarButtonItem (ScCustomImage)

- (id)initWithCustomImage:(UIImage *)image target:(id)target action:(SEL)action
{
    UIButton *innerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect rect = CGRectZero;
    rect.size = image.size;
    innerButton.frame = rect;
    [innerButton setImage:image forState:UIControlStateNormal];
    [innerButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    self = [[UIBarButtonItem alloc]initWithCustomView:innerButton];
    if (self != nil)
    {
        
    }
    return self;
}

@end
