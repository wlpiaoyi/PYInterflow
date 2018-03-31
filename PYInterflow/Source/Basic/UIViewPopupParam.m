//
//  PYPopupParam.m
//  PYInterflow
//
//  Created by wlpiaoyi on 2016/12/8.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "PYPopupParam.h"
#import "pyutilea.h"
#import "UIView+Popup.h"
#import <objc/runtime.h>

@implementation PYPopupParam{
    PYPopupWindow * baseWindow;
}
-(instancetype) init{
    if(self = [super init]){
        self.centerPoint = CGPointMake(0, 0);
        self.borderEdgeInsets = UIEdgeInsetsMake(DisableConstrainsValueMAX, DisableConstrainsValueMAX, DisableConstrainsValueMAX, DisableConstrainsValueMAX);
        self.frameOrg = CGRectMake(DisableConstrainsValueMAX, DisableConstrainsValueMAX, DisableConstrainsValueMAX, DisableConstrainsValueMAX);
    }
    return self;
}
-(BlockPopupAnimation) creteDefaultBlcokPopupShowAnmation{
    @unsafeify(self);
    BlockPopupAnimation blockAnimation = ^(UIView *view, BlockPopupEndAnmation blockEnd){
        @strongify(self);
        @synchronized(view) {
            
            CATransform3D transformx = CATransform3DIdentity;
            transformx = CATransform3DScale(transformx, 2, 2, 1);
            view.layer.transform = transformx;
            view.alpha = 0;
            if([self.baseView isKindOfClass:[PYPopupWindow class]]){
                self.baseView.alpha = 0;
                self.baseView.userInteractionEnabled = true;
                self.baseView.hidden = false;
            }
        }
        
        self.isAnimationing = true;
        @unsafeify(self);
        [UIView animateWithDuration:PYPopupAnimationTime * PYPopupAnimationTimeOffset animations:^{
            @strongify(self);
            CATransform3D transformx = CATransform3DIdentity;
            transformx = CATransform3DScale(transformx, 1, 1, 1);
            view.layer.transform = transformx;
            view.alpha = 1;
            if([self.baseView isKindOfClass:[PYPopupWindow class]]){
                [self baseView].alpha = 1;
            }
        } completion:^(BOOL finished) {
            if (!view) return;
            @synchronized(view) {
                if(blockEnd)blockEnd(view);
            }
        }];
        
    };
    return blockAnimation;
}
-(BlockPopupEndAnmation) creteDefaultBlcokPopupShowEndAnmation{
    @unsafeify(self);
    BlockPopupEndAnmation blockEnd = ^(UIView * view){
        @strongify(self);
        self.isAnimationing = false;
        if(self.blockStart){
            self.blockStart(view);
        }
        if ([self isShow]) {
            CATransform3D transformx = CATransform3DIdentity;
            transformx = CATransform3DScale(transformx, 1, 1, 1);
            view.layer.transform = transformx;
            view.alpha = 1;
            if([self.baseView isKindOfClass:[PYPopupWindow class]]){
                self.baseView.alpha = 1;
            }
        }
    };
    return blockEnd;
}

-(BlockPopupAnimation) creteDefaultBlcokPopupHiddenAnmation{
    
    @unsafeify(self);
    BlockPopupAnimation blockAnimation = ^(UIView *view, BlockPopupEndAnmation blockEnd){
        @strongify(self);
        
        @synchronized(view) {
            CATransform3D transformx = CATransform3DIdentity;
            transformx = CATransform3DScale(transformx, 1, 1, 1);
            view.layer.transform = transformx;
            view.alpha = 1;
            if([self.baseView isKindOfClass:[PYPopupWindow class]]) {
                [self baseView].alpha = 1;
            }
        }
        
        self.isAnimationing = true;
        @unsafeify(self);
        [UIView animateWithDuration:PYPopupAnimationTime * PYPopupAnimationTimeOffset * .2 animations:^{
            
            CATransform3D transformx = CATransform3DIdentity;
            transformx = CATransform3DScale(transformx, 1.2, 1.2, 1);
            view.layer.transform = transformx;
            
        } completion:^(BOOL finished) {
            @strongify(self);
            
            @unsafeify(self);
            [UIView animateWithDuration:PYPopupAnimationTime * PYPopupAnimationTimeOffset animations:^{
                @strongify(self);
                CATransform3D transformx = CATransform3DIdentity;
                transformx = CATransform3DScale(transformx, .01, .01, 1);
                view.layer.transform = transformx;
                view.alpha = 0.1;
                if([self.baseView isKindOfClass:[PYPopupWindow class]]){
                    [self baseView].alpha = 0.1;
                }
                
            } completion:^(BOOL finished) {
                @strongify(self);
                self.isAnimationing = false;
                if (!view) return;
                @synchronized(view) {
                    if(blockEnd)blockEnd(view);
                }
            }];
        }];
        
    };
    
    return blockAnimation;
}
-(BlockPopupEndAnmation) creteDefaultBlcokPopupHiddenEndAnmation{
    @unsafeify(self);
    BlockPopupEndAnmation blockEnd = ^(UIView * view){
        @strongify(self);
        self.isAnimationing = false;
        if(self.blockEnd){
            self.blockEnd(view);
        }
        if (self.isShow == false) {
            [view removeFromSuperview];
            [self.contentView removeFromSuperview];
            CATransform3D transformx = CATransform3DIdentity;
            transformx = CATransform3DScale(transformx, 1, 1, 1);
            view.layer.transform = transformx;
            if([self.baseView isKindOfClass:[PYPopupWindow class]]){
                self.baseView.hidden = true;
            }
            for (NSLayoutConstraint * lc in self.lc.objectEnumerator) {
                [self.baseView removeConstraint:lc];
                [view removeConstraint:lc];
            }
        }
        if(!(IOS8_OR_LATER)){
            [view removeParam];
        }
    };
    return blockEnd;
}

@end
