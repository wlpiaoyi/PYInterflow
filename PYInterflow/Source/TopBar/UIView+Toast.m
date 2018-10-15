//
//  UIView+Toast.m
//  PYInterflow
//
//  Created by wlpiaoyi on 2016/12/9.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "UIView+Toast.h"
#import "UIView+Popup.h"
#import "pyutilea.h"
#import "PYToastParam.h"
#import <objc/runtime.h>
#import "PYInterflowWindow.h"

const void * PYTopbarPointer = &PYTopbarPointer;

@implementation UIView(Toast)

-(void) toastShow:(CGFloat) time{
    [self toastShow:time attributeMessage:nil];
}

-(void) toastShow:(CGFloat) time message:(nullable NSString *) message{
    [self toastShow:time attributeMessage:[PYToastParam parseTopbarMessage:message]];
}

-(void) toastShow:(CGFloat) time attributeMessage:(nullable NSAttributedString *) attributeMessage{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PYToastNotify" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PYToastNotify" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toastHidden) name:@"PYToastNotify" object:nil];
    [self topbarParams].message = attributeMessage;
    if(attributeMessage){
        self.frameSize = [[self topbarParams] updateMessageView];
    }
    self.popupEdgeInsets = UIEdgeInsetsMake(DisableConstrainsValueMAX, DisableConstrainsValueMAX, 50, DisableConstrainsValueMAX);
    self.popupCenterPoint = CGPointMake(0, DisableConstrainsValueMAX);
    
    self.popupBaseView = [PYUtile getCurrenWindow];
    
    [self setBlockShowAnimation:(^(UIView * _Nonnull view, BlockPopupEndAnmation _Nullable block){
        if(IOS8_OR_LATER){
            view.alpha = 0;
            [UIView animateWithDuration:.5 animations:^{
                [view resetAutoLayout];
                [view resetTransform];
                view.alpha = 1;
            } completion:^(BOOL finished) {
                block(view);
            }];
        }else{
            view.alpha = 0;
            [UIView animateWithDuration:.5 animations:^{
                view.alpha = 1;
            } completion:^(BOOL finished) {
                block(view);
            }];
        }
    })];
    [self setBlockHiddenAnimation:(^(UIView * _Nonnull view, BlockPopupEndAnmation _Nullable block){
        if(IOS8_OR_LATER){
            [view resetAutoLayout];
            [view resetTransform];
            view.alpha = 1;
            [UIView animateWithDuration:.5 animations:^{
                view.alpha = 0;
            } completion:^(BOOL finished) {
                block(view);
            }];
        }else{
            view.alpha = 1;
            [UIView animateWithDuration:.5 animations:^{
                view.alpha = 0;
            } completion:^(BOOL finished) {
                block(view);
            }];
        }
    })];
    self.popupHasEffect = NO;
    [self popupShowForHasContentView:NO];
    if(time > 0){
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [NSThread sleepForTimeInterval:time];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self toastHidden];
            });
        });
    }
}
-(void) toastHidden{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PYToastNotify" object:nil];
    [self popupHidden];
}
-(PYToastParam *) topbarParams{
    PYToastParam * param = objc_getAssociatedObject(self, PYTopbarPointer);
    if(param == nil){
        param = [[PYToastParam alloc] initWithTargetView:self];
        objc_setAssociatedObject(self, PYTopbarPointer, param, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return param;
}
@end

@implementation UIView(Topbar)

-(void) topbarShow:(CGFloat) time{
    [self topbarShow:time attributeMessage:nil];
}

-(void) topbarShow:(CGFloat) time message:(nullable NSString *) message{
    [self topbarShow:time attributeMessage:[PYToastParam parseTopbarMessage:message]];
}

-(void) topbarShow:(CGFloat) time attributeMessage:(nullable NSAttributedString *) attributeMessage{
    [self toastShow:time attributeMessage:attributeMessage];
}
@end
