//
//  Scr_View_PasswordTextField.m
//  fotocase_note
//
//  Created by 宮田 雅元 on 2012/08/11.
//  Copyright (c) 2012年 Miyata Keizo. All rights reserved.
//

#import "ScPasswordTextFieldView.h"

@implementation ScPasswordTextFieldView

- (id) init
{
    return [self initWithFieldsCount:4];
}

- (id) initWithFieldsCount:(int)count
{
    self = [super init];
    if (self) {
        
        _fields = [[NSMutableArray alloc] init];
        
        int width = 40;
        int height = 40;
        int space = 5;
        int currentX = 0;
        for (int i=0; i<count; i++)
        {
            UITextField *text = [[UITextField alloc] init];
            text.backgroundColor = [UIColor whiteColor];
            text.borderStyle = UITextBorderStyleBezel;
            text.keyboardType = UIKeyboardTypeNumberPad;
            text.returnKeyType = UIReturnKeyDone;
            text.textAlignment = NSTextAlignmentCenter;
            text.font = [UIFont systemFontOfSize:24.0];
            text.secureTextEntry = YES;
            text.delegate = self;
            
            if(0 < i)
            {
                currentX += width + space;
            }
            
            text.frame = CGRectMake(currentX, 0, width, height);
            
            [_fields addObject:text];
            [self addSubview:text];
        }
        
        self.frame = CGRectMake(0, 0, width * count, height);
    
        [[_fields objectAtIndex:0] becomeFirstResponder];

    }
    return self;
}

//選択より前に空のフィールドがあったらそっちへ移動する
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    for (int i=0; i<_fields.count; i++)
    {
        UITextField *text = [_fields objectAtIndex:i];
        
        if(text == textField)
        {
            text.text = @"";
            break;
        }
        else if(text.text.length == 0)
        {
            [text becomeFirstResponder];
            break;
        }
    }
    
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    UITextField *tempTextField;
    int i;
    for (i=0; i<_fields.count; i++)
    {
        tempTextField = [_fields objectAtIndex:i];
        if(tempTextField == textField)
        {
            break;
        }
    }
    
    
    if(range.location == 0)
    {
        tempTextField.text = string;
        
        int next = i+1;
        if(next < _fields.count)
        {
            
            [[_fields objectAtIndex: next] becomeFirstResponder];
        }
        else
        {
            if(_didEndAction != nil && _didEndTarget != nil)
            {
                if([_didEndTarget respondsToSelector: _didEndAction])
                {
                    NSString *resutl = @"";
                    for (i=0; i<_fields.count; i++)
                    {
                        tempTextField = [_fields objectAtIndex:i];
                        resutl = [resutl stringByAppendingString:tempTextField.text];
                    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    [_didEndTarget performSelector:_didEndAction withObject:(ScPasswordTextFieldView*)self withObject:resutl];
#pragma clang diagnostic pop
                }
            }
        }
    }
    
    return NO;
}

- (void) setDidEndTarget: (id) target action: (SEL) action
{
    _didEndAction = action;
    _didEndTarget = target;
}

- (void) removeDidEndTarget
{
    _didEndAction = nil;
    _didEndTarget = nil;
}

@end
