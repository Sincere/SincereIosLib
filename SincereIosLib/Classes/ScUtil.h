//
//  Header.h
//  fotocase
//
//  Created by 宮田　雅元 on 2020/09/17.
//  Copyright © 2020 Masamoto Miyata. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ScUtil : NSObject

+ (void) fixButtonLabelConstraints: (nonnull UIButton *) button;
+ (nonnull UIAlertController *) createAlert: (nonnull NSString *)message;
+ (nonnull UIAlertController *) createAlert: (nonnull NSString *)message withTitle: (nullable NSString *)title;
+ (nonnull UIAlertController *) createAlert: (nonnull NSString *)message withTitle: (nullable NSString *)title handler:(void (^ __nullable)(UIAlertAction * _Nullable action))handler;
+ (void) showAlert: (nonnull NSString *)message;
+ (void) showAlert: (nonnull NSString *)message withTitle: (nullable NSString *)title;
+ (void) showAlert: (nonnull NSString *)message withTitle: (nullable NSString *)title handler:(void (^ __nullable)(UIAlertAction * _Nullable action))handler;
@end
