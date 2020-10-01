//
//  UIView+ScViewUtil.m
//  fotocase
//
//  Created by 宮田　雅元 on 2020/08/29.
//  Copyright © 2020 Masamoto Miyata. All rights reserved.
//

#import "UIView+ScViewUtil.h"

@implementation UIView (ScViewUtil)

- (UIViewController *)parentViewController {
    UIResponder *responder = self;
    while ([responder isKindOfClass:[UIView class]])
        responder = [responder nextResponder];
    return (UIViewController *)responder;
}

@end
