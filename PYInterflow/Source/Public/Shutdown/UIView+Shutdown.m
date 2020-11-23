//
//  UIView+Shutdown.m
//  PYInterflow
//
//  Created by wlpiaoyi on 2020/11/22.
//  Copyright © 2020 wlpiaoyi. All rights reserved.
//

#import "UIView+Shutdown.h"
#import "pyutilea.h"
#import "PYShutdownPopupView.h"
#import "PYShutdownItemView.h"
#import "PYShutdownItemCell.h"
#import <objc/runtime.h>

static const void *UIViewShutdownPopupPointer = &UIViewShutdownPopupPointer;

@interface PYShutdownPopupParams : NSObject

kPNA CGFloat shutdownHeight;
kPNA CGFloat shutdownSelectedIndex;
kPNSNA NSArray<NSString *> * shutdownItems;
kPNSNA PYShutdownItemView * itemView;

kPNCNA void (^blockShutdownSelectedItem) (UIView * view);
kPNCNA void (^blockBeforeShutdownShow) (UIView * view);
kPNCNA void (^blockAfterShutdownHidden) (UIView * view);
kPNSNA PYShutdownPopupView * ctxView;

@end

@implementation PYShutdownPopupParams

-(instancetype) init{
    if(self = [super init]){
        self.shutdownHeight = -1;
    }
    return self;
}

@end

@interface UIView (Shutdown)

kPNRNA PYShutdownPopupParams * shutdownParams;

@end

@implementation UIView (Shutdown)


-(PYShutdownPopupParams *) shutdownParams{
    PYShutdownPopupParams * shutdownParams =  objc_getAssociatedObject(self, UIViewShutdownPopupPointer);
    if(shutdownParams) return shutdownParams;
    shutdownParams = [PYShutdownPopupParams new];
    objc_setAssociatedObject(self, UIViewShutdownPopupPointer, shutdownParams, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    shutdownParams.ctxView = [PYShutdownPopupView instance];
    shutdownParams.shutdownSelectedIndex = -1;
    return shutdownParams;
}

-(void) setShutdownHeight:(CGFloat)shutdownHeight{
    self.shutdownParams.shutdownHeight = shutdownHeight;
    self.shutdownParams.ctxView.shutdownHeight = shutdownHeight;
}
-(CGFloat) shutdownHeight{
    return self.shutdownParams.shutdownHeight;
}

-(void) setShutdownSelectedIndex:(NSInteger) shutdownSelectedIndex{
    self.shutdownParams.shutdownSelectedIndex = shutdownSelectedIndex;
}
-(NSInteger) shutdownSelectedIndex{
    return self.shutdownParams.shutdownSelectedIndex;
}

-(void) setShutdownItems:(NSArray<NSString *> *)shutdownItems{
    self.shutdownParams.shutdownItems = shutdownItems;
}
-(NSArray<NSString *> *) shutdownItems{
    return self.shutdownParams.shutdownItems;
}

-(void) setBlockShutdownSelectedItem:(void (^)(UIView * _Nonnull))blockShutdownSelectedItem{
    self.shutdownParams.blockShutdownSelectedItem = blockShutdownSelectedItem;
}
-(void (^)(UIView * _Nonnull))blockShutdownSelectedItem{
    return self.shutdownParams.blockShutdownSelectedItem;
}

-(void) setBlockBeforeShutdownShow:(void (^)(UIView * _Nonnull))blockBeforeShutdown{
    self.shutdownParams.blockBeforeShutdownShow = blockBeforeShutdown;
    if(!self.blockBeforeShutdownShow) return;
    kAssign(self);
    self.shutdownParams.ctxView.blockBeforeShutdownShow = ^(PYShutdownPopupView * _Nonnull shutdownPopupView) {
        kStrong(self);
        if(!self.blockBeforeShutdownShow) return;
        self.blockBeforeShutdownShow(self);
    };
}
-(void (^)(UIView * _Nonnull)) blockBeforeShutdownShow{
    return self.shutdownParams.blockBeforeShutdownShow;
}

-(void) setBlockAfterShutdownHidden:(void (^)(UIView * _Nonnull))blockBeforeShutdown{
    self.shutdownParams.blockAfterShutdownHidden = blockBeforeShutdown;
    kAssign(self);
    self.shutdownParams.ctxView.blockAfterShutdownHidden = ^(PYShutdownPopupView * _Nonnull shutdownPopupView) {
        kStrong(self);
        if(self.blockAfterShutdownHidden) self.blockAfterShutdownHidden(self);
        self.shutdownParams.ctxView = nil;
    };
}
-(void (^)(UIView * _Nonnull)) blockAfterShutdownHidden{
    return self.shutdownParams.blockAfterShutdownHidden;
}


-(void) shutdownShowWithSuperView:(nonnull UIView *) superView topConstant:(CGFloat) topConstant{
    [self shutdownShowWithSuperView:superView topItem:nil topConstant:topConstant];
}

-(void) shutdownShowWithSuperView:(nonnull UIView *) superView topItem:(nullable UIView *) topItem topConstant:(CGFloat) topConstant{
    threadJoinMain(^{
        if(self.shutdownHeight < 0){
            self.shutdownHeight = self.frameHeight;
        }
        if(self.shutdownItems && self.shutdownItems.count){
            PYShutdownItemView * itemView = self.shutdownParams.itemView;;
            if(itemView== nil){
                itemView = [PYShutdownItemView new];
                [self addSubview:itemView];
                [itemView py_makeConstraints:^(PYConstraintMaker * _Nonnull make) {
                    make.top.left.bottom.right.py_constant(0);
                }];
                self.shutdownParams.itemView = itemView;
            }
            kAssign(self);
            itemView.blockSelectedOpt = ^(PYShutdownItemView * _Nonnull itemView) {
                kStrong(self);
                self.shutdownSelectedIndex = itemView.selectedIndex;
                if(self.blockShutdownSelectedItem) self.blockShutdownSelectedItem(self);
            };
            CGFloat maxItemHeight = boundsHeight() - ([topItem getAbsoluteOrigin:superView].y + topConstant);
            if (@available(iOS 11.0, *)) {
                maxItemHeight -= ABS(superView.safeAreaInsets.top);
                maxItemHeight -= ABS(superView.safeAreaInsets.bottom);
            }
            
            itemView.itemMaxCount = maxItemHeight / [PYShutdownItemCell getHeight] - 1;
            itemView.items = self.shutdownItems;
            itemView.selectedIndex = self.shutdownSelectedIndex;
            self.shutdownHeight = itemView.frameHeight;
        }
        if(!self.blockAfterShutdownHidden){
            self.blockAfterShutdownHidden = self.blockAfterShutdownHidden;
        }
        [self.shutdownParams.ctxView showWithSubView:self superView:superView topItem:topItem topConstant:topConstant];
        self.shutdownParams.ctxView.shutdownHeight = self.shutdownHeight;
    });
}

-(void) shutdownHidden{
    [self.shutdownParams.ctxView hidden];
}

@end
