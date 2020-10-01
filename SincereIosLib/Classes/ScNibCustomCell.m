//
//  FcCustomXivCell.m
//  fotocase
//
//  Created by Masamoto Miyata on 2012/12/04.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//

#import "ScNibCustomCell.h"

@implementation ScNibCustomCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
{
    return [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [[NSBundle mainBundle] loadNibNamed:[self nibName] owner:self options:nil];
        [self.contentView addSubview:self.view];
        
        self.view.translatesAutoresizingMaskIntoConstraints = NO;

        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:0];

        [self.contentView addConstraints:@[top, bottom, left, right]];
    }
    return self;
}

- (NSString *)nibName
{
    NSAssert(NO, @"This is an abstract method and should be overridden");
    return nil;
}

@end
