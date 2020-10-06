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

-(void) setToastTintColor:(UIColor *)toastTintColor{
    [self toastParams].tintColor = toastTintColor;
}

-(UIColor *) toastTintColor{
    return [self toastParams].tintColor;
}


-(void) toastShow:(CGFloat) time{
    self.popupCenterPoint = CGPointMake(0, 0);
    self.popupBaseView = [UIApplication sharedApplication].keyWindow;
    
    [self setBlockShowAnimation:(^(UIView * _Nonnull view, PYBlockPopupV_P_V _Nullable block){
        view.alpha = 0;
        [UIView animateWithDuration:.5 animations:^{
            [view resetAutoLayout];
            [view resetTransform];
            view.alpha = 1;
        } completion:^(BOOL finished) {
            block(view);
        }];
    })];
    [self setBlockHiddenAnimation:(^(UIView * _Nonnull view, PYBlockPopupV_P_V _Nullable block){
        [view resetAutoLayout];
        [view resetTransform];
        view.alpha = 1;
        [UIView animateWithDuration:.5 animations:^{
            view.alpha = 0;
        } completion:^(BOOL finished) {
            block(view);
        }];
    })];
    [self popupShowForHasContentView:NO];
    if (time > 0) {
        [self toastParams].timer = [NSTimer scheduledTimerWithTimeInterval:time repeats:NO block:^(NSTimer * _Nonnull timer) {
            [self toastHidden];
        }];
    }
}

-(void) toastShow:(CGFloat) time message:(nullable NSString *) message{
    [self toastShow:time message:message image:nil];
}

-(void) toastShow:(CGFloat) time message:(nullable NSString *) message  image:(nullable UIImage *) image{
    [self toastShow:time attributeMessage:[PYToastParam parseTopbarMessage:message] image:image];
}

-(void) toastShow:(CGFloat) time attributeMessage:(nullable NSAttributedString *) attributeMessage{
    [self toastShow:time attributeMessage:attributeMessage image:nil];
}

-(void) toastShow:(CGFloat) time attributeMessage:(nullable NSAttributedString *) attributeMessage image:(nullable UIImage *) image{
    if(attributeMessage && attributeMessage.length){
        [self toastParams].message = attributeMessage;
    }
    if(image){
        [self toastParams].image = image;
    }
    self.frameSize = [[self toastParams] updateMessageView];
    [self toastShow:time];
    
}

-(void) toastHidden{
    [self popupHidden];
    [[self toastParams].timer invalidate];
    [self toastParams].timer = nil;
}
-(PYToastParam *) toastParams{
    PYToastParam * param = objc_getAssociatedObject(self, PYTopbarPointer);
    if(param == nil){
        param = [[PYToastParam alloc] initWithTargetView:self];
        objc_setAssociatedObject(self, PYTopbarPointer, param, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return param;
}
@end

