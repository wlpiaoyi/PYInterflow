//
//  UIView+Notify.m
//  PYInterflow
//
//  Created by wlpiaoyi on 2016/12/9.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "UIView+Notify.h"
#import "UIView+Popup.h"
#import "pyutilea.h"
#import "PYNotifyParam.h"
#import <objc/runtime.h>
#import "PYPopupWindow.h"


const void * PYNotifyPointer = &PYNotifyPointer;


@implementation UIView(Notify)

/**
 通知显示
 */
///=================================>
-(void) notifyShow:(CGFloat) time message:(nullable NSString *) message blockTap:(void (^) (UIView * _Nonnull targetView)) blockTap{
    [self notifyShow:time attributeMessage:[PYNotifyParam parseNotifyMessage:message] blockTap:blockTap];
}

-(void) notifyShow:(CGFloat) time attributeMessage:(nullable NSAttributedString *) attributeMessage blockTap:(void (^) (UIView * _Nonnull targetView)) blockTap{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PYNotifyHidden" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyHidden) name:@"PYNotifyHidden" object:nil];
    [self notifyParams].blockTap = blockTap;
    [self notifyParams].message = attributeMessage;
    if(attributeMessage){
        self.frameSize = [[self notifyParams] updateMessageView];
    }
    [self notifyShow];
    if(time > 0){
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [NSThread sleepForTimeInterval:time];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self notifyHidden];
            });
        });
    }
}
-(void) notifyShow{
    
    self.popupEdgeInsets = UIEdgeInsetsMake(0, DisableConstrainsValueMAX, DisableConstrainsValueMAX, DisableConstrainsValueMAX);
    self.popupCenterPoint = CGPointMake(0, DisableConstrainsValueMAX);
    [self setBlockShowAnimation:(^(UIView * _Nonnull view, BlockPopupEndAnmation _Nullable block){
        view.alpha = 0;
        view.layer.transform = CATransform3DMakeTranslation(0, -view.frameHeight, 0);
        if(IOS8_OR_LATER){
            [UIView animateWithDuration:.5 animations:^{
                [view resetAutoLayout];
                [view resetTransform];
                view.alpha = 1;
            } completion:^(BOOL finished) {
                block(view);
                view.popupBaseView.frameHeight = view.frameY + view.frameHeight;
            }];
        }else{
            view.alpha = 0;
            [UIView animateWithDuration:.5 animations:^{
                view.alpha = 1;
            } completion:^(BOOL finished) {
                block(view);
                view.popupBaseView.frameHeight = view.frameY + view.frameHeight;
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
                view.alpha = 0;
                view.layer.transform = CATransform3DMakeTranslation(0, -view.frameHeight, 0);
            } completion:^(BOOL finished) {
                block(view);
            }];
        }else{
            view.alpha = 1;
            [UIView animateWithDuration:.5 animations:^{
                view.alpha = 0;
                view.alpha = 0;
                view.layer.transform = CATransform3DMakeTranslation(0, -view.frameHeight, 0);
            } completion:^(BOOL finished) {
                block(view);
            }];
        }
    })];
    [self popupShowForHasContentView:NO];
    self.popupBaseView.frameHeight = self.frameHeight;
    
}
///<=================================
-(void) notifyHidden{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self popupHidden];
}
-(PYNotifyParam *) notifyParams{
    PYNotifyParam * param = objc_getAssociatedObject(self, PYNotifyPointer);
    if(param == nil){
        param = [[PYNotifyParam alloc] initWithTargetView:self];
        objc_setAssociatedObject(self, PYNotifyPointer, param, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return param;
}
@end
