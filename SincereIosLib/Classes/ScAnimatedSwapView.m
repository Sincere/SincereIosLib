//
//  ScScrollingLabelView.m
//  fotocase
//
//  Created by Masamoto Miyata on 2012/12/07.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//

#import "ScAnimatedSwapView.h"

@implementation ScAnimatedSwapView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void)setNextView:(UIView *)view;
{
    [_views addObject:view];
    [self toNextLabel];
}

#pragma mark - private
- (void)toNextLabel
{
    @synchronized(self)
    {
        if(_addingView == nil)
        {
            if([_views count] > 0)
            {
                // メインスレッドで行われないのでクラッシュする。強制的にメインスレッドへ。
                dispatch_async(
                    dispatch_get_main_queue(),
                    ^{
                        _addingView = [_views objectAtIndex:0];
                        
                        [_views removeObjectAtIndex:0];
                        [self addSubview:_addingView];
                        _addingView.frame = _nextFrame;
                        
                        [UIView animateWithDuration:self.animationDuration animations:^{
                           [self scrollRectToVisible:_nextFrame animated:NO];
                        }completion:^(BOOL finished){
                            @synchronized(self)
                            {
                                if(_currentView != nil)
                                {
                                    [_currentView removeFromSuperview];
                                }
                                
                                _currentView = _addingView;
                                _addingView = nil;
                                
                                _currentView.frame = _stageFrame;
                                [self scrollRectToVisible:_stageFrame animated:NO];
                                
                                [self toNextLabel];
                            }
                        }];
                    }
                );
            }
        }
    }
}

- (void)setup
{
    _views = [[NSMutableArray alloc]init];
    
    self.animationDuration = 0.1;
    self.userInteractionEnabled = NO;
    self.backgroundColor = [UIColor clearColor];
    self.pagingEnabled = YES;
    self.scrollEnabled = NO;
    
    
    self.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height * 2);
    
    _stageFrame = self.bounds;
    
    _nextFrame = _stageFrame;
    _nextFrame.origin.y =_nextFrame.origin.y + _nextFrame.size.height;
}



@end
