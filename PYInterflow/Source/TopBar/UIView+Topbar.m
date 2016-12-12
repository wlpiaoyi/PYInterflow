//
//  UIView+Topbar.m
//  PYInterflow
//
//  Created by wlpiaoyi on 2016/12/9.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "UIView+Topbar.h"
#import "UIView+Popup.h"
#import "pyutilea.h"
#import "PYTopbarParam.h"
#import <objc/runtime.h>
#import "PYPopupWindow.h"

const void * PYTopbarPointer = &PYTopbarPointer;

@implementation UIView(Topbar)

-(void) topbarShow:(CGFloat) time{
    [self topbarShow:time attributeMessage:nil];
}

-(void) topbarShow:(CGFloat) time message:(nullable NSString *) message{
    [self topbarShow:time attributeMessage:[PYTopbarParam parseTopbarMessage:message]];
}

-(void) topbarShow:(CGFloat) time attributeMessage:(nullable NSAttributedString *) attributeMessage{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(topbarHidden) name:@"PYTopbarNotify" object:nil];
    [self topbarParams].message = attributeMessage;
    if(attributeMessage){
        self.frameSize = [[self topbarParams] updateMessageView];
    }
    self.borderEdgeInsets = UIEdgeInsetsMake(0, DisableConstrainsValueMAX, DisableConstrainsValueMAX, DisableConstrainsValueMAX);
    self.centerPoint = CGPointMake(0, DisableConstrainsValueMAX);
    
    PYPopupWindow * window =  [[PYPopupWindow alloc] initWithFrame:CGRectMake(0, 0, boundsWidth(), self.frameHeight) windowLevel:UIWindowLevelStatusBar];
    self.baseView = window;
    
    [self setBlockShowAnimation:(^(UIView * _Nonnull view, BlockPopupEndAnmation _Nullable block){
        if(IOS8_OR_LATER){
            view.alpha = 0;
            view.transform = CGAffineTransformMakeTranslation(0, -view.bounds.size.height);
            [UIView animateWithDuration:.5 animations:^{
                [view resetBoundPoint];
                view.alpha = 1;
            } completion:^(BOOL finished) {
                block(view);
            }];
        }else{
            block(view);
        }
    })];
    [self setBlockHiddenAnimation:(^(UIView * _Nonnull view, BlockPopupEndAnmation _Nullable block){
        if(IOS8_OR_LATER){
            [view resetBoundPoint];
            view.alpha = 1;
            [UIView animateWithDuration:.5 animations:^{
                view.transform = CGAffineTransformMakeTranslation(0, -view.bounds.size.height);
                view.alpha = 0;
            } completion:^(BOOL finished) {
                block(view);
            }];
        }else{
            block(view);
        }
    })];
    [self popupShow];
                                                                              
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:time];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self topbarHidden];
        });
    });
}
-(void) topbarHidden{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self popupHidden];
}
-(PYTopbarParam *) topbarParams{
    PYTopbarParam * param = objc_getAssociatedObject(self, PYTopbarPointer);
    if(param == nil){
        param = [[PYTopbarParam alloc] initWithTargetView:self];
        objc_setAssociatedObject(self, PYTopbarPointer, param, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return param;
}
@end
