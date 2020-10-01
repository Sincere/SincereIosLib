//
//  ScLabel.m
//  fotocase
//
//  Created by Masamoto Miyata on 2012/12/05.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//

#import "ScPaddingLabel.h"

@implementation ScPaddingLabel

- (void)drawTextInRect:(CGRect)rect
{
    UIEdgeInsets insets = {self.paddingTop, self.paddingLeft,
        self.paddingBottom, self.paddingRight};
    
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
