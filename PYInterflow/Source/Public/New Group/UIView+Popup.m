//
//  UIView+Popup.m
//  PYInterchange
//
//  Created by wlpiaoyi on 16/1/21.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "UIView+Popup.h"
#import "PYPopupParam.h"
#import "pyutilea.h"
#import "AppDelegate.h"
#import <objc/runtime.h>



static const void *UIViewPopupPointer = &UIViewPopupPointer;

@implementation UIView(Popup)
-(void) setPopupBlockEnd:(void (^)(UIView * _Nullable))blockEnd{
    [self popupParam].popupBlockEnd = blockEnd;
}
-(void (^)(UIView * _Nullable)) popupBlockEnd{
    return [self popupParam].popupBlockEnd;
}
-(void) setPopupBlockStart:(void (^)(UIView * _Nullable))blockStart{
    [self popupParam].popupBlockStart = blockStart;
}
-(void (^)(UIView * _Nullable)) popupBlockStart{
    return [self popupParam].popupBlockStart;
}
-(CGRect) frameOrg{
    return [self popupParam].frameOrg;
}
-(void) setFrameOrg:(CGRect) frame{
    [self popupParam].frameOrg = frame;
}
-(BOOL) popupisAnimation{
    return [self popupParam].isAnimationing;
}
-(void) setPopupisAnimation:(BOOL)isAnimationing{
    [self popupParam].isAnimationing = isAnimationing;
}

-(BOOL) popupShow{
    [UIResponder hookWithMethodNames:nil];
    return [self popupShowForHasContentView:YES];
}
-(BOOL) popupShowForHasContentView:(BOOL) hasContentView{
    return [self __popupShowForHasContentView:hasContentView windowLevel:UIWindowLevelAlert];
}

-(BOOL) popupHidden{
    @synchronized(self) {
        if (!self.popupIsShow) {
            return NO;
        }
        self.popupIsShow = false;
        kNOTIF_POST(xPYInterflowConfValue.popup.notifyHidden, self);
        PYBlockPopupV_P_V_BK block = [self blockHiddenAnimation];
        if (!block) {
            block = [[self popupParam] creteDefaultBlcokPopupHiddenAnmation];
        }
        PYBlockPopupV_P_V blockEnd = [[self popupParam]creteDefaultBlcokPopupHiddenEndAnmation];
        block(self,blockEnd);
        if(self.popupHasEffect) [PYPopupParam REV_EFFECT_VALUE];
    }
    return YES;
}

-(CGPoint) popupCenterPoint{
    return [self popupParam].centerPoint;
}

-(void) setPopupCenterPoint:(CGPoint)center{
    [self popupParam].centerPoint = center;
}

-(UIEdgeInsets) popupEdgeInsets{
    return [self popupParam].borderEdgeInsets;
}

-(void) setPopupEdgeInsets:(UIEdgeInsets)borderEdgeInsets{
    [self popupParam].borderEdgeInsets = borderEdgeInsets;
}
-(PYEdgeInsetsItem) popupEdgeInsetItems{
    return [self popupParam].borderEdgeInsetItems;
}
-(void) setPopupEdgeInsetItems:(PYEdgeInsetsItem)popupEdgeInsetItems{
    [self popupParam].borderEdgeInsetItems = popupEdgeInsetItems;
}

-(BOOL) popupIsShow{
    return [self popupParam].isShow;
}
-(void) setPopupIsShow:(BOOL) isShow{
    [self popupParam].isShow = isShow;
}
-(void) resetTransform{
    @synchronized(self) {
        CATransform3D transform = CATransform3DIdentity;
        transform = CATransform3DScale(transform, 1, 1, 1);
        self.layer.transform = transform;
    }
}
-(void) resetAutoLayout{
    @synchronized(self) {
        CGSize s = self.frameSize;
        CGPoint p = self.popupCenterPoint;
        UIEdgeInsets e = self.popupEdgeInsets;
        
        for (NSLayoutConstraint * lc in [self popupParam].lc.objectEnumerator) {
            [self.popupBaseView removeConstraint:lc];
            [self.popupContentView removeConstraint:lc];
            [self.superview removeConstraint:lc];
            [self.popupContentView.superview removeConstraint:lc];
            [self removeConstraint:lc];
        }
        
        if(self.superview == nil) return;
        NSMutableDictionary<NSString *, NSLayoutConstraint *> * lc =  [NSMutableDictionary new];
        NSDictionary<NSString *, NSLayoutConstraint *> * templc = [PYViewAutolayoutCenter persistConstraint:self centerPointer:p];
        for (NSString * key in templc) {
            [lc setObject:templc[key] forKey:key];
        }
        templc = [PYViewAutolayoutCenter persistConstraint:self relationmargins:e relationToItems:self.popupEdgeInsetItems];
        for (NSString * key in templc) {
            [lc setObject:templc[key] forKey:key];
        }
        templc = [PYViewAutolayoutCenter persistConstraint:self size:s];
        
        for (NSString * key in templc) {
            [lc setObject:templc[key] forKey:key];
        }
        if(self.popupContentView){
            templc = [PYViewAutolayoutCenter persistConstraint:self.popupContentView relationmargins:UIEdgeInsetsMake(0, 0, 0, 0) relationToItems:PYEdgeInsetsItemNull()];
            for (NSString * key in templc) {
                [lc setObject:templc[key] forKey:key];
            }
        }
        [self popupParam].lc = lc;
    }
}
-(nullable NSDictionary<NSString *, NSLayoutConstraint *> *) lcPopups{
    return [self popupParam].lc;
}
-(void) setPopupBlockTap:(void (^)(UIView * _Nullable))popupBlockTap{
    [self popupParam].popupBlockTap = popupBlockTap;
}
-(void (^)(UIView * _Nullable)) popupBlockTap{
    return [self popupParam].popupBlockTap;
}
-(UIView*) popupBaseView{
    return [self popupParam].baseView;
}
-(void) setPopupBaseView:(UIView*) view{
    [self popupParam].baseView = view;
}
-(BOOL) popupHasEffect{
    return  [self popupParam].hasEffect;
}
-(void) setPopupHasEffect:(BOOL)popupHasEffect{
    [self popupParam].hasEffect = popupHasEffect;
}
-(UIView*) popupContentView{
    return [self popupParam].contentView;
}
-(void) setBlockShowAnimation:(PYBlockPopupV_P_V_BK) block{
    [self popupParam].blockShowAnimation = block;
}
-(PYBlockPopupV_P_V_BK) blockShowAnimation{
    return [self popupParam].blockShowAnimation;
}
-(void) setBlockHiddenAnimation:(PYBlockPopupV_P_V_BK) block{
    [self popupParam].blockHiddenAnimation = block;
}
-(PYBlockPopupV_P_V_BK) blockHiddenAnimation{
    return [self popupParam].blockHiddenAnimation;
}
-(PYPopupParam *) popupParam{
    PYPopupParam * param = objc_getAssociatedObject(self, UIViewPopupPointer);
    if(param == nil){
        param = [PYPopupParam new];
        objc_setAssociatedObject(self, UIViewPopupPointer, param, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return param;
}

-(BOOL) __popupShowForHasContentView:(BOOL) hasContentView windowLevel:(UIWindowLevel) windowLevel{
    @synchronized(self){
        if (self.popupIsShow) return NO;
        else self.popupIsShow = true;
        kNOTIF_POST(xPYInterflowConfValue.popup.notifyShow, self);
        self.popupHasEffect = hasContentView && xPYInterflowConfValue.popup.notifyEffcte;
        if (self.popupBaseView == nil){
            self.popupBaseView =  [PYInterflowWindow instanceForFrame:[UIScreen mainScreen].bounds hasEffect:self.popupHasEffect];
        }
        
        if([self.popupBaseView isKindOfClass:[PYInterflowWindow class]]){
            @synchronized([UIWindow class]){
                UIWindow * orgWindow = [UIApplication sharedApplication].keyWindow;
                PYInterflowWindow * interflowWindow = ((PYInterflowWindow*)self.popupBaseView);
                [interflowWindow makeKeyAndVisible];
                [orgWindow makeKeyWindow];
            }
            ((PYInterflowWindow*)self.popupBaseView).windowLevel = windowLevel;
        }
        
        if(hasContentView){
            [self popupParam].contentView = [UIView new];
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = [UIColor clearColor];
            button.tag = 186186100;
            [button addTarget:self action:@selector(__popupTapContentView) forControlEvents:UIControlEventTouchDown];
            [self.popupContentView addSubview:button];
            [PYViewAutolayoutCenter persistConstraint:button relationmargins:UIEdgeInsetsZero relationToItems:PYEdgeInsetsItemNull()];
            self.popupContentView.backgroundColor = xPYInterflowConfValue.base.colorContentBg;
            [self.popupContentView addSubview:self];
            [self.popupBaseView addSubview:self.popupContentView];
        }else{
            [self.popupBaseView addSubview:self];
        }
        [self resetAutoLayout];
        [self resetTransform];
        
        PYBlockPopupV_P_V_BK blockAnimation = [self blockShowAnimation];
        if (!blockAnimation) {
            blockAnimation = [[self popupParam] creteDefaultBlcokPopupShowAnmation];
        }
        if(self.popupHasEffect) [PYPopupParam ADD_EFFECT_VALUE];
        PYBlockPopupV_P_V blockEnd = [[self popupParam] creteDefaultBlcokPopupShowEndAnmation];
        blockAnimation(self, blockEnd);
    }
    
    return YES;
}
-(void) __popupTapContentView{
    if(self.popupBlockTap){
        self.popupBlockTap(self);
    }else{
        [self popupHidden];
    }
}

@end


