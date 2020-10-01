//
//  ScColor.m
//  fotocase
//
//  Created by 宮田　雅元 on 2020/08/16.
//  Copyright © 2020 Masamoto Miyata. All rights reserved.
//

#import "ScColor.h"

@implementation ScColor

+ (UIColor *)defaultLabelColor {
    if (@available(iOS 13.0, *)) {
        return [UIColor labelColor];
    } else {
        return [UIColor whiteColor];
    }
}

@end
