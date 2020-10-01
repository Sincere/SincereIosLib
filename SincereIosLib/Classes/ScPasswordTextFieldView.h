//
//  Scr_View_PasswordTextField.h
//  fotocase_note
//
//  Created by 宮田 雅元 on 2012/08/11.
//  Copyright (c) 2012年 Miyata Keizo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScPasswordTextFieldView : UIView <UITextFieldDelegate>
{
    @private
        id _didEndTarget;
        SEL _didEndAction;
        NSMutableArray *_fields;
}

- (id) initWithFieldsCount: (int) count;

- (void) setDidEndTarget: (id) target action: (SEL) action;
- (void) removeDidEndTarget;

@end
