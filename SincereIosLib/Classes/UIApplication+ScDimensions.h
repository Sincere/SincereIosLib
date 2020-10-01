//
//  UIApplication+ScDimensions.h
//  fotocase
//
//  Created by Masamoto Miyata on 2013/01/20.
//  Copyright (c) 2013年 Masamoto Miyata. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (ScDimensions)
+(CGSize) currentSize;
+(CGSize) sizeInOrientation:(UIInterfaceOrientation)orientation;
@end
