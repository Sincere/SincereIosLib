//
//  UIImage+ScResize.m
//  ScrollView
//
//  Created by Masamoto Miyata on 2012/10/19.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//

#import "UIImage+ScUtil.h"

static CGImageRef createMaskWithImage(CGImageRef image)
{
    int maskWidth               = (int)CGImageGetWidth(image);
    int maskHeight              = (int)CGImageGetHeight(image);
    //  round bytesPerRow to the nearest 16 bytes, for performance's sake
    int bytesPerRow             = (maskWidth + 15) & 0xfffffff0;
    int bufferSize              = bytesPerRow * maskHeight;
	
    //  we use CFData instead of malloc(), because the memory has to stick around
    //  for the lifetime of the mask. if we used malloc(), we'd have to
    //  tell the CGDataProvider how to dispose of the memory when done. using
    //  CFData is just easier and cleaner.
	
    CFMutableDataRef dataBuffer = CFDataCreateMutable(kCFAllocatorDefault, 0);
    CFDataSetLength(dataBuffer, bufferSize);
	
    //  the data will be 8 bits per pixel, no alpha
    CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef ctx            = CGBitmapContextCreate(CFDataGetMutableBytePtr(dataBuffer),
                                                        maskWidth, maskHeight,
                                                        8, bytesPerRow, colourSpace, kCGImageAlphaNone);
    //  drawing into this context will draw into the dataBuffer.
    CGContextDrawImage(ctx, CGRectMake(0, 0, maskWidth, maskHeight), image);
    CGContextRelease(ctx);
	
    //  now make a mask from the data.
    CGDataProviderRef dataProvider  = CGDataProviderCreateWithCFData(dataBuffer);
    CGImageRef mask                 = CGImageMaskCreate(maskWidth, maskHeight, 8, 8, bytesPerRow,
                                                        dataProvider, NULL, FALSE);
	
    CGDataProviderRelease(dataProvider);
    CGColorSpaceRelease(colourSpace);
    CFRelease(dataBuffer);
	
    return mask;
}

@implementation UIImage (ScUtil)
- (CGSize)sizeWithResizedByWidth:(CGFloat) width
{
    return CGSizeMake(width, self.size.height * (width / self.size.width));
}

- (CGSize)sizeWithResizedByHeight:(CGFloat) height
{
    return CGSizeMake(self.size.width * (height / self.size.height), height);
}

-(UIImage *)imageWithResizeByWidth:(CGFloat) width
{
    CGSize size = [self sizeWithResizedByWidth:width];
    
    return [self imageWithResize:size];
}

-(UIImage *)imageWithResizeByHeight:(CGFloat) height
{
    CGSize size = [self sizeWithResizedByHeight:height];
    
    return [self imageWithResize:size];
}

- (BOOL)isOverflowed:(CGSize) maxSize
{
    return self.size.height > maxSize.height || self.size.width > maxSize.width;
}

- (UIImage *)imageWithResizeByMaxSize:(CGSize) maxSize
{
    CGSize newSize = [self sizeWithResizedByWidth:maxSize.width];
    if(newSize.height > maxSize.height)
    {
        return [self imageWithResizeByHeight:maxSize.height];
    }
    else
    {
        return [self imageWithResizeByWidth:maxSize.width];
    }
}

-(UIImage *)imageWithResize:(CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)imageWithCrop:(CGRect)rect
{
    
    rect = CGRectMake(rect.origin.x*self.scale,
                      rect.origin.y*self.scale,
                      rect.size.width*self.scale,
                      rect.size.height*self.scale);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef
                                          scale:self.scale
                                    orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return result;
}

- (UIImage *) normalizeForMask
{
    CGImageRef mask = createMaskWithImage([self CGImage]);
    return [UIImage imageWithCGImage:mask];
}

- (UIImage *) imageWithMask:(UIImage *)maskImage
{
	CGImageRef masked = CGImageCreateWithMask([self CGImage], [maskImage CGImage]);
	return [UIImage imageWithCGImage:masked];
}

@end
