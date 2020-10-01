//
//  UIApplication+ScDimensions.m
//  fotocase
//
//  Created by Masamoto Miyata on 2013/01/20.
//  Copyright (c) 2013年 Masamoto Miyata. All rights reserved.
//

#import "UIApplication+ScDimensions.h"

@implementation UIApplication (ScDimensions)
+(CGSize) currentSize
{
    return [UIApplication sizeInOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

+(CGSize) sizeInOrientation:(UIInterfaceOrientation)orientation
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIApplication *application = [UIApplication sharedApplication];
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        size = CGSizeMake(size.height, size.width);
    }
    if (application.statusBarHidden == NO)
    {
        size.height -= MIN(application.statusBarFrame.size.width, application.statusBarFrame.size.height);
    }
    return size;
}
@end
