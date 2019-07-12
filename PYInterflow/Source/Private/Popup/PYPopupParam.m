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

static NSInteger PYPopupEffectRefreshValue = 0;
@implementation PYPopupParam{
    PYInterflowWindow * baseWindow;
}
static UIImage * PY_POPUP_IMG;
static UIImage * PY_POPUP_IMG_BTM_LINE;
static UIImage * PY_POPUP_IMG_CET_LINE;


+(UIImage *) IMAGE_BOTTOM_LINE{
    if(PY_POPUP_IMG_BTM_LINE) return PY_POPUP_IMG_BTM_LINE;
    PY_POPUP_IMG_BTM_LINE = [UIImage  imageWithColor:STATIC_POPUP_HIGHLIGHTC];
    return PY_POPUP_IMG_BTM_LINE;
}

+(UIImage *) IMAGE_CET_LINE{
    if(PY_POPUP_IMG_CET_LINE) return PY_POPUP_IMG_CET_LINE;
    PY_POPUP_IMG_CET_LINE = [UIImage  imageWithColor:STATIC_POPUP_HIGHLIGHTC];
    return PY_POPUP_IMG_CET_LINE;
}

+(void) ADD_EFFECT_VALUE{
    @synchronized(STATIC_POPUP_EFFECTE_NOTIFY){
        PYPopupEffectRefreshValue ++;
        threadJoinGlobal(^{
            [self REFRESH_EFFECT];
        });
    }
}
+(void) REV_EFFECT_VALUE{
    @synchronized(STATIC_POPUP_EFFECTE_NOTIFY){
        PYPopupEffectRefreshValue --;
    }
}

+(void) RECIRCLE_REFRESH_EFFECT{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
        dispatch_async(queue, ^{
        
            float cpuUsage = 0;
            static NSTimeInterval fpsTimeInterval = .05;
            NSTimeInterval timePre = [NSDate timeIntervalSinceReferenceDate];
            NSTimeInterval timeInterval;
            while (true) {
                timeInterval = 0;
                if(PYPopupEffectRefreshValue < 1){
                    [NSThread sleepForTimeInterval:fpsTimeInterval];
                    if(cpuUsage > 0) cpuUsage = 0;
                    continue;
                }
                if(cpuUsage < PYPopupEffectCpuUsage){
                    timePre = [NSDate timeIntervalSinceReferenceDate];
                    [PYPopupParam REFRESH_EFFECT];
                    cpuUsage = app_cpu_usage();
                    timeInterval = [NSDate timeIntervalSinceReferenceDate] - timePre;
                    if(timeInterval < fpsTimeInterval){
                        timeInterval = fpsTimeInterval - timeInterval;
                    }
                    if(cpuUsage > PYPopupEffectCpuUsage){
                        timeInterval += cpuUsage * 3;
                    }
#ifdef DEBUG
                    kPrintLogln("popup effect excut for cup usage: %.2f%% time:%ims", cpuUsage * 100, (int)(timeInterval * 1000));
#endif
                }else{
                    cpuUsage = app_cpu_usage();
                    timeInterval = fpsTimeInterval;
#ifdef DEBUG
                    kPrintLogln("popup effect continue for cup usage: %.2f%% time:%ims", cpuUsage * 100, (int)(timeInterval * 1000));
#endif
                }
                [NSThread sleepForTimeInterval:timeInterval];
            }
        });
    });
}
+(void) REFRESH_EFFECT{
    static dispatch_semaphore_t semaphore;
    kDISPATCH_ONCE_BLOCK(^{
        semaphore = dispatch_semaphore_create(1);
    });
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    threadJoinMain(^{
        UIWindow * window = [UIApplication sharedApplication].delegate.window;
        CGRect bounds = window.bounds;
        __block UIImage * image = [window drawViewWithBounds:bounds scale:1];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            image = [image applyEffect:PYPopupEffectBlur tintColor:STATIC_EFFECT_TINTC];
            PY_POPUP_IMG = image;
            threadJoinMain(^{
                kNOTIF_POST(STATIC_POPUP_EFFECTE_NOTIFY, PY_POPUP_IMG);
                dispatch_semaphore_signal(semaphore);
            });
        });
    });
}


-(instancetype) init{
    [PYPopupParam RECIRCLE_REFRESH_EFFECT];
    if(self = [super init]){
        _hasEffect = STATIC_POPUP_HASEFFECT;
        self.centerPoint = CGPointMake(0, 0);
        self.borderEdgeInsets = UIEdgeInsetsMake(DisableConstrainsValueMAX, DisableConstrainsValueMAX, DisableConstrainsValueMAX, DisableConstrainsValueMAX);
        self.frameOrg = CGRectMake(DisableConstrainsValueMAX, DisableConstrainsValueMAX, DisableConstrainsValueMAX, DisableConstrainsValueMAX);
        PYEdgeInsetsItem eii = PYEdgeInsetsItemNull();
        eii.topActive = eii.bottomActive = eii.leftActive = eii.rightActive = true;
        self.borderEdgeInsetItems = eii;
    }
    return self;
}
-(PYBlockPopupingAnimation) creteDefaultBlcokPopupShowAnmation{
    @unsafeify(self);
    PYBlockPopupingAnimation blockAnimation = ^(UIView *view, PYBlockPopupendAnimation blockEnd){
        @strongify(self);
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
        @unsafeify(self);
        [UIView animateWithDuration:PYPopupAnimationTime * PYPopupAnimationTimeOffset animations:^{
            @strongify(self);
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
-(PYBlockPopupendAnimation) creteDefaultBlcokPopupShowEndAnmation{
    @unsafeify(self);
    PYBlockPopupendAnimation blockEnd = ^(UIView * view){
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

-(PYBlockPopupingAnimation) creteDefaultBlcokPopupHiddenAnmation{
    
    @unsafeify(self);
    PYBlockPopupingAnimation blockAnimation = ^(UIView *view, PYBlockPopupendAnimation blockEnd){
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
-(PYBlockPopupendAnimation) creteDefaultBlcokPopupHiddenEndAnmation{
    @unsafeify(self);
    PYBlockPopupendAnimation blockEnd = ^(UIView * view){
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
