//
//  ScUtil.m
//  fotocase
//
//  Created by 宮田　雅元 on 2020/09/17.
//  Copyright © 2020 Masamoto Miyata. All rights reserved.
//

#import "ScUtil.h"
#import "ScLog.h"

@implementation ScUtil

+ (void) fixButtonLabelConstraints: (nonnull UIButton *) button
{
    if (@available(iOS 11.0, *)) {
        UILayoutGuide* guide = button.superview.safeAreaLayoutGuide;
        button.translatesAutoresizingMaskIntoConstraints = NO;
        [button.leadingAnchor constraintEqualToAnchor:guide.leadingAnchor].active = YES;
        [button.trailingAnchor constraintEqualToAnchor:guide.trailingAnchor].active = YES;
        [button.topAnchor constraintEqualToAnchor:guide.topAnchor].active = YES;
        [button.bottomAnchor constraintEqualToAnchor:guide.bottomAnchor].active = YES;
    }
}

+ (nonnull UIAlertController *) createAlert: (nonnull NSString *)message
{
    return [self createAlert:message withTitle:nil];
}


+ (nonnull UIAlertController *) createAlert: (nonnull NSString *)message withTitle: (nullable NSString *)title
{
    return [self createAlert:message withTitle:title handler:nil];
}

+ (nonnull UIAlertController *) createAlert: (nonnull NSString *)message withTitle: (nullable NSString *)title handler:(void (^ __nullable)(UIAlertAction * _Nullable action))handler
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle: title
                                        message: message
                                 preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                             style: UIAlertActionStyleDefault
                           handler: handler];
    [alert addAction: ok];
    
    return alert;
}

+ (void) showAlert: (nonnull NSString *)message
{
    [self showAlert:message withTitle:nil];
}

+ (void) showAlert: (nonnull NSString *)message withTitle: (nullable NSString *)title
{
    [self showAlert:message withTitle:title handler:nil];
}

+ (void) showAlert: (nonnull NSString *)message withTitle: (nullable NSString *)title handler:(void (^ __nullable)(UIAlertAction * _Nullable action))handler
{
    UIViewController *rootController = [[[[UIApplication sharedApplication]delegate] window] rootViewController];
    UIAlertController *alert = [self createAlert:message withTitle:title handler: handler];
    if(rootController.presentedViewController != nil){
        [rootController.presentedViewController presentViewController:alert animated:YES completion:nil];
    } else {
        [rootController presentViewController:alert animated:YES completion:nil];
    }
    
}

@end
