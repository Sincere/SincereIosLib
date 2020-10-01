//
//  UIImage+ScResize.h
//  ScrollView
//
//  Created by Masamoto Miyata on 2012/10/19.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ScUtil)

- (CGSize)sizeWithResizedByWidth:(CGFloat) width;

- (CGSize)sizeWithResizedByHeight:(CGFloat) height;

- (UIImage *)imageWithResizeByWidth:(CGFloat) width;

- (UIImage *)imageWithResizeByHeight:(CGFloat) height;

- (UIImage *)imageWithResize:(CGSize) size;

- (BOOL)isOverflowed:(CGSize) maxSize;

- (UIImage *)imageWithResizeByMaxSize:(CGSize) maxSize;

- (UIImage *)imageWithCrop:(CGRect)rect;

- (UIImage *)normalizeForMask;

- (UIImage *)imageWithMask:(UIImage *)maskImage;


@end
