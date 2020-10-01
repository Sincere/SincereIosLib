//
//  FcCustomXivCell.h
//  fotocase
//
//  Created by Masamoto Miyata on 2012/12/04.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScLog.h"

@interface ScNibCustomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *view;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
