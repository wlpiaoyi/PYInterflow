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
#import "PYInterflowParams.h"
#import <objc/runtime.h>

NSInteger PYPopupEffectRefreshValue = 0;

BOOL PYPopupEffectHasLayoutSubViews;
int PYPopupEffectLayoutSubViewsCount = 0;
int PYPopupEffectRefreshCount = 0;

@interface UIView(PYPopupEffect)
+(void) _pypopup_hook_ae86;
@end

@implementation UIView(PYPopupEffect)

+(void) _pypopup_hook_ae86{
//    [CALayer _pypopup_hook_ae86];
    [UIView hookInstanceOriginalSel:@selector(layoutSubviews) exchangeSel:@selector(_pypopup_layoutSubviews_ae86)];
}

-(void) _pypopup_layoutSubviews_ae86{
    [self _pypopup_layoutSubviews_ae86];
    [self _pypopup_effect_freshDatas_ae86];
}
-(void) _pypopup_effect_freshDatas_ae86{
    if(PYPopupEffectRefreshValue <= 0) return;
    UIView * responder = self;
    while (responder.superview) responder = responder.superview;
    if(responder != [UIApplication sharedApplication].keyWindow) return;
    PYPopupEffectHasLayoutSubViews = YES;
    PYPopupEffectRefreshCount ++;
}

@end

@implementation PYPopupParam{
    PYInterflowWindow * baseWindow;
}

+(nonnull UIImage *) IMAGE_HORIZONTAL_LINE:(CGColorRef) bgColor{
    NSInteger scale = [UIScreen mainScreen].scale;
    UIImage * image = [UIImage imageWithSize:CGSizeMake(scale, scale) blockDraw:^(CGContextRef  _Nonnull context, CGRect rect) {
        [PYGraphicsDraw drawLineWithContext:context startPoint:CGPointMake(0, 0) endPoint:CGPointMake(rect.size.width, 0) strokeColor:xPYInterflowConfValue.popup.colorLine.CGColor strokeWidth:1 lengthPointer:nil length:0];
    }];
    image = [image setImageSize:CGSizeMake(1, 1) scale:scale];
    return image;
}

+(nonnull UIImage *) IMAGE_VERTICAL_LINE:(CGColorRef) bgColor{
    NSInteger scale = [UIScreen mainScreen].scale;
    UIImage * image = [UIImage imageWithSize:CGSizeMake(scale, scale) blockDraw:^(CGContextRef  _Nonnull context, CGRect rect) {
        [PYGraphicsDraw drawLineWithContext:context startPoint:CGPointMake(0, 0) endPoint:CGPointMake(0, rect.size.height) strokeColor:xPYInterflowConfValue.popup.colorLine.CGColor strokeWidth:1 lengthPointer:nil length:0];
    }];
    image = [image setImageSize:CGSizeMake(1, 1) scale:scale];
    return image;
}

+(void) ADD_EFFECT_VALUE{
    if(!xPYInterflowConfValue.base.hasEffect) return;
    @synchronized(xPYInterflowConfValue.popup.notifyEffcte){
        PYPopupEffectRefreshValue ++;
        threadJoinGlobal(^{
            [self REFRESH_EFFECT];
        });
    }
}
+(void) REV_EFFECT_VALUE{
    if(!xPYInterflowConfValue.base.hasEffect) return;
    @synchronized(xPYInterflowConfValue.popup.notifyEffcte){
        PYPopupEffectRefreshValue --;
    }
}


+(void) RECIRCLE_REFRESH_EFFECT{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [UIView _pypopup_hook_ae86];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            float cpuUsage = 0;
            float maxCpuUsage = xPYInterflowConfValue.base.maxCpuUsage;
            static NSTimeInterval fpsTimeInterval = .05;
            NSTimeInterval timePre = [NSDate timeIntervalSinceReferenceDate];
            NSTimeInterval timeInterval;
            NSTimeInterval sleep = fpsTimeInterval;
            while (true) {
                timePre = [NSDate timeIntervalSinceReferenceDate];
                timeInterval = 0;
                if(PYPopupEffectRefreshValue < 1){
                    [NSThread sleepForTimeInterval:fpsTimeInterval];
                    if(cpuUsage > 0) cpuUsage = 0;
                    continue;
                }
                if(!PYPopupEffectHasLayoutSubViews){
                    [NSThread sleepForTimeInterval:0.035];
                    continue;
                }
                cpuUsage = app_cpu_usage();
                if(cpuUsage < maxCpuUsage){
                    sleep = MAX(.035, cpuUsage / 100.);
                    [PYPopupParam REFRESH_EFFECT];
                    if(cpuUsage > maxCpuUsage){
                        sleep += fpsTimeInterval;
                    }
                }else{
                    sleep = fpsTimeInterval;
                    NSLog(@"%@",@"popup effect out for cup usage");
                }
                [NSThread sleepForTimeInterval:sleep];
#ifdef DEBUG
                    NSLog(@"popup effect excut for cup usage: %.2f%% time:%ims sleep:%ims", cpuUsage * 100, (int)(([NSDate timeIntervalSinceReferenceDate] - timePre) * 1000), (int)(sleep * 1000));
#endif
                sleep = fpsTimeInterval;
            }
        });
    });
    
}
+(void) REFRESH_EFFECT{
    threadJoinMain(^{
        if(PYPopupEffectRefreshCount != 0){
            PYPopupEffectRefreshCount = 0;
            int i = PYPopupEffectLayoutSubViewsCount;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                CGFloat timer = [NSDate timeIntervalSinceReferenceDate];
                while (i == PYPopupEffectLayoutSubViewsCount && [NSDate timeIntervalSinceReferenceDate] - timer < 3) {
                    [NSThread sleepForTimeInterval:0.03];
                }
                if(i != PYPopupEffectLayoutSubViewsCount){
                    return;
                }
                #ifdef DEBUG
                NSLog(@"popup effect layout count: %i ", i);
                #endif
                PYPopupEffectHasLayoutSubViews = NO;
                PYPopupEffectRefreshCount = 0;
            });
        }
        UIWindow * window = [PYUtile getCurrenWindow];
        CGRect bounds = window.bounds;
        UIImage *snapshotImage = [window drawViewWithBounds:bounds scale:[UIScreen mainScreen].scale];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            NSData *imageData = UIImageJPEGRepresentation(snapshotImage, 1);
            UIImage * image = [UIImage imageWithData:imageData];
            image = [image applyEffect:xPYInterflowConfValue.base.floatEffectBlur tintColor:xPYInterflowConfValue.base.colorEffectTint];
            threadJoinMain(^{
                kNOTIF_POST(xPYInterflowConfValue.popup.notifyEffcte, image);
            });
        });
    });
}


-(instancetype) init{
    [PYPopupParam RECIRCLE_REFRESH_EFFECT];
    if(self = [super init]){
        self.centerPoint = CGPointMake(0, 0);
        self.borderEdgeInsets = UIEdgeInsetsMake(DisableConstrainsValueMAX, DisableConstrainsValueMAX, DisableConstrainsValueMAX, DisableConstrainsValueMAX);
        self.frameOrg = CGRectMake(DisableConstrainsValueMAX, DisableConstrainsValueMAX, DisableConstrainsValueMAX, DisableConstrainsValueMAX);
        PYEdgeInsetsItem eii = PYEdgeInsetsItemNull();
        eii.topActive = eii.bottomActive = eii.leftActive = eii.rightActive = true;
        self.borderEdgeInsetItems = eii;
    }
    return self;
}
-(PYBlockPopupV_P_V_BK) creteDefaultBlcokPopupShowAnmation{
    kAssign(self);
    PYBlockPopupV_P_V_BK blockAnimation = ^(UIView *view, PYBlockPopupV_P_V blockEnd){
        kStrong(self);
        @synchronized(view) {
            
            CATransform3D transformx = CATransform3DIdentity;
            transformx = CATransform3DScale(transformx, 2, 2, 1);
            view.layer.transform = transformx;
            view.alpha = 0;
            if([self.baseView isKindOfClass:[PYInterflowWindow class]]){
                self.baseView.alpha = 0;
                self.baseView.userInteractionEnabled = true;
                self.baseView.hidden = false;
            }
        }
        
        self.isAnimationing = true;
        kAssign(self);
        [UIView animateWithDuration:xPYInterflowConfValue.base.animationTime * xPYInterflowConfValue.base.animationTimeOffset animations:^{
            kStrong(self);
            CATransform3D transformx = CATransform3DIdentity;
            transformx = CATransform3DScale(transformx, 1, 1, 1);
            view.layer.transform = transformx;
            view.alpha = 1;
            if([self.baseView isKindOfClass:[PYInterflowWindow class]]){
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
-(PYBlockPopupV_P_V) creteDefaultBlcokPopupShowEndAnmation{
    @unsafeify(self);
    PYBlockPopupV_P_V blockEnd = ^(UIView * view){
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
            if([self.baseView isKindOfClass:[PYInterflowWindow class]]){
                self.baseView.alpha = 1;
            }
        }
        if(self.popupBlockStart) self.popupBlockStart(view);
    };
    return blockEnd;
}

-(PYBlockPopupV_P_V_BK) creteDefaultBlcokPopupHiddenAnmation{
    
    @unsafeify(self);
    PYBlockPopupV_P_V_BK blockAnimation = ^(UIView *view, PYBlockPopupV_P_V blockEnd){
        @strongify(self);
        
        @synchronized(view) {
            CATransform3D transformx = CATransform3DIdentity;
            transformx = CATransform3DScale(transformx, 1, 1, 1);
            view.layer.transform = transformx;
            view.alpha = 1;
            if([self.baseView isKindOfClass:[PYInterflowWindow class]]) {
                [self baseView].alpha = 1;
            }
        }
        
        self.isAnimationing = true;
        @unsafeify(self);
        [UIView animateWithDuration:xPYInterflowConfValue.base.animationTime * xPYInterflowConfValue.base.animationTimeOffset * .2 animations:^{
            
            CATransform3D transformx = CATransform3DIdentity;
            transformx = CATransform3DScale(transformx, 1.2, 1.2, 1);
            view.layer.transform = transformx;
            
        } completion:^(BOOL finished) {
            @strongify(self);
            
            @unsafeify(self);
            [UIView animateWithDuration:xPYInterflowConfValue.base.animationTime * xPYInterflowConfValue.base.animationTimeOffset animations:^{
                @strongify(self);
                CATransform3D transformx = CATransform3DIdentity;
                transformx = CATransform3DScale(transformx, .01, .01, 1);
                view.layer.transform = transformx;
                view.alpha = 0.1;
                if([self.baseView isKindOfClass:[PYInterflowWindow class]]){
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
-(PYBlockPopupV_P_V) creteDefaultBlcokPopupHiddenEndAnmation{
    @unsafeify(self);
    PYBlockPopupV_P_V blockEnd = ^(UIView * view){
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
            if([self.baseView isKindOfClass:[PYInterflowWindow class]]){
                self.baseView.hidden = true;
                [((PYInterflowWindow *)self.baseView) removeSubviews];
            }
            for (NSLayoutConstraint * lc in self.lc.objectEnumerator) {
                [self.baseView removeConstraint:lc];
                [view removeConstraint:lc];
            }
        }
        if(self.popupBlockEnd) self.popupBlockEnd(view);
    };
    return blockEnd;
}

@end
