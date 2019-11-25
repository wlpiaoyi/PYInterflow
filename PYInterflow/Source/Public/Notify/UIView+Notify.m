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
#import "PYInterflowWindow.h"
#import "PYPopupParam.h"


const void * PYNotifyPointer = &PYNotifyPointer;


@interface PYNotifyUIViewcontrollerHookOrientation : NSObject <UIViewcontrollerHookOrientationDelegate>
kPNA BOOL isExcute;
@end

@implementation PYNotifyUIViewcontrollerHookOrientation


-(BOOL) aftlerExcuteShouldAutorotateWithTarget:(nonnull UIViewController *) target result:(BOOL)result{
    if(_isExcute){
        return NO;
    }
    return result;
}

@end

static PYNotifyUIViewcontrollerHookOrientation * xPYNotifyUIViewcontrollerHookOrientation;

@interface UIView()
-(void) __popupShowForHasContentView:(BOOL) hasContentView windowLevel:(UIWindowLevel) windowLevel;
@end

@implementation UIView(Notify)

/**
 通知显示
 */
///=================================>
-(void) notifyShow:(NSUInteger) time message:(nullable NSString *) message blockTap:(nullable PYBlockPopupV_P_V) blockTap{
    [self notifyShow:time attributeMessage:[PYNotifyParam parseNotifyMessage:message color:nil] blockTap:blockTap];
}

-(void) notifyShow:(NSUInteger) time attributeMessage:(nullable NSAttributedString *) attributeMessage blockTap:(nullable PYBlockPopupV_P_V) blockTap{
    [self notifyShow:time attributeMessage:attributeMessage color:nil blockTap:blockTap];
}

-(void) notifyShow:(NSUInteger) time message:(nullable NSString *) message color:(nullable UIColor *) color blockTap:(nullable PYBlockPopupV_P_V) blockTap{
    [self notifyShow:time attributeMessage:[PYNotifyParam parseNotifyMessage:message color:color] blockTap:blockTap];
}
-(void) notifyShow:(NSUInteger) time attributeMessage:(nullable NSAttributedString *) attributeMessage color:(nullable UIColor *) color blockTap:(nullable PYBlockPopupV_P_V) blockTap{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PYNotifyHidden" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyHidden) name:@"PYNotifyHidden" object:nil];
    [self notifyParams].blockTap = blockTap;
    [self notifyParams].message = attributeMessage;
    if(attributeMessage){
        self.frameSize = [[self notifyParams] updateMessageView];
    }
    [self notifyShow];
    [self notifyParams].timeRemainning = time;
    if([self notifyParams].timeRemainning > 0){
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            while ([self notifyParams].timeRemainning) {
                [self notifyParams].timeRemainning--;
                [NSThread sleepForTimeInterval:1];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self notifyHidden];
            });
        });
    }
}
-(void) notifyShow{
    
    static dispatch_once_t onceToken; dispatch_once(&onceToken, ^{
        [UIViewController hookMethodOrientation];
        xPYNotifyUIViewcontrollerHookOrientation = [PYNotifyUIViewcontrollerHookOrientation new];
        [UIViewController addDelegateOrientation:xPYNotifyUIViewcontrollerHookOrientation];
    });
    xPYNotifyUIViewcontrollerHookOrientation.isExcute = true;
    PYEdgeInsetsItem eii = PYEdgeInsetsItemNull();
    eii.topActive = YES;
    self.popupEdgeInsetItems = eii;
    self.popupEdgeInsets = UIEdgeInsetsMake(0, 0, DisableConstrainsValueMAX, DisableConstrainsValueMAX);
    self.popupCenterPoint = CGPointMake(0, DisableConstrainsValueMAX);
    [self setBlockShowAnimation:(^(UIView * _Nonnull view, PYBlockPopupV_P_V _Nullable block){
        view.layer.transform = CATransform3DMakeTranslation(0, -view.frameHeight - view.frameY, 0);
        [UIView animateWithDuration:.5 animations:^{
            [view resetTransform];
            if([view.popupBaseView isKindOfClass:[PYInterflowWindow class]])
                view.popupBaseView.frameHeight = view.frameY + view.frameHeight;
        } completion:^(BOOL finished) {
            block(view);
            if([view.popupBaseView isKindOfClass:[PYInterflowWindow class]])
                view.popupBaseView.frameHeight = view.frameY + view.frameHeight;
        }];
    })];
    [self setBlockHiddenAnimation:(^(UIView * _Nonnull view, PYBlockPopupV_P_V _Nullable block){
        [view resetTransform];
        view.popupBaseView.frameHeight = view.frameY + view.frameHeight;
        [UIView animateWithDuration:.5 animations:^{
            view.layer.transform = CATransform3DMakeTranslation(0, -view.frameHeight - view.frameY, 0);
        } completion:^(BOOL finished) {
            block(view);
        }];
    })];
    self.popupHasEffect = NO;
    [self __popupShowForHasContentView:NO windowLevel:UIWindowLevelStatusBar];
}
///<=================================
-(void) notifyHidden{
    [self notifyParams].timeRemainning = 0;
    xPYNotifyUIViewcontrollerHookOrientation.isExcute = false;
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
