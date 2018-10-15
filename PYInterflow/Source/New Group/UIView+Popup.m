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
#import <objc/runtime.h>



static const void *UIViewPopupPointer = &UIViewPopupPointer;

@implementation UIView(Popup)
-(void) setPopupBlockEnd:(void (^)(UIView * _Nullable))blockEnd{
    [self popupParam].blockEnd = blockEnd;
}
-(void (^)(UIView * _Nullable)) popupBlockEnd{
    return [self popupParam].blockEnd;
}
-(void) setPopupBlockStart:(void (^)(UIView * _Nullable))blockStart{
    [self popupParam].blockStart = blockStart;
}
-(void (^)(UIView * _Nullable)) popupBlockStart{
    return [self popupParam].blockStart;
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

-(void) popupShow{
    [self popupShowForHasContentView:YES];
}
-(void) popupShowForHasContentView:(BOOL) hasContentView{
    [self __popupShowForHasContentView:hasContentView windowLevel:UIWindowLevelNormal];
}

-(void) popupHidden{
    @synchronized(self) {
        if (!self.popupIsShow) {
            return;
        }
        self.popupIsShow = false;
        
        BlockPopupAnimation block = [self blockHiddenAnimation];
        if (!block) {
            block = [[self popupParam] creteDefaultBlcokPopupHiddenAnmation];
        }
        BlockPopupEndAnmation blockEnd = [[self popupParam]creteDefaultBlcokPopupHiddenEndAnmation];
        block(self,blockEnd);
        if(self.popupHasEffect) [PYPopupParam REV_EFFECT_VALUE];
    }
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
        [lc setDictionary:[PYViewAutolayoutCenter persistConstraint:self size:s]];
        if(self.popupContentView){
            templc = [PYViewAutolayoutCenter persistConstraint:self.popupContentView relationmargins:UIEdgeInsetsMake(0, 0, 0, 0) relationToItems:PYEdgeInsetsItemNull()];
            for (NSString * key in templc) {
                [lc setObject:templc[key] forKey:key];
            }
        }
        [self popupParam].lc = lc;
    }
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
-(void) setBlockShowAnimation:(BlockPopupAnimation) block{
    [self popupParam].blockShowAnimation = block;
}
-(BlockPopupAnimation) blockShowAnimation{
    return [self popupParam].blockShowAnimation;
}
-(void) setBlockHiddenAnimation:(BlockPopupAnimation) block{
    [self popupParam].blockHiddenAnimation = block;
}
-(BlockPopupAnimation) blockHiddenAnimation{
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

-(void) __popupShowForHasContentView:(BOOL) hasContentView windowLevel:(UIWindowLevel) windowLevel{
    @synchronized(self){
        
        if (self.popupIsShow) return;
        else self.popupIsShow = true;
        
        if (self.popupBaseView == nil){
            self.popupBaseView =  [PYInterflowWindow instanceForFrame:[UIScreen mainScreen].bounds hasEffect:self.popupHasEffect];
            @synchronized([UIWindow class]){
                UIWindow * orgWindow = [UIApplication sharedApplication].keyWindow;
                [((PYInterflowWindow*)self.popupBaseView) makeKeyAndVisible];
                [orgWindow makeKeyWindow];
            }
            ((PYInterflowWindow*)self.popupBaseView).windowLevel = windowLevel;
        }else if([self.popupBaseView isKindOfClass:[PYInterflowWindow class]]){
            @synchronized([UIWindow class]){
                UIWindow * orgWindow = [UIApplication sharedApplication].keyWindow;
                [((PYInterflowWindow*)self.popupBaseView) makeKeyAndVisible];
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
            self.popupContentView.backgroundColor = STATIC_CONTENT_BACKGROUNDCLOLOR;
            [self.popupContentView addSubview:self];
            [self.popupBaseView addSubview:self.popupContentView];
        }else{
            [self.popupBaseView addSubview:self];
        }
        [self resetAutoLayout];
        [self resetTransform];
        
        BlockPopupAnimation blockAnimation = [self blockShowAnimation];
        if (!blockAnimation) {
            blockAnimation = [[self popupParam] creteDefaultBlcokPopupShowAnmation];
        }
        if(self.popupHasEffect) [PYPopupParam ADD_EFFECT_VALUE];
        BlockPopupEndAnmation blockEnd = [[self popupParam] creteDefaultBlcokPopupShowEndAnmation];
        blockAnimation(self, blockEnd);
    }
}
-(void) __popupTapContentView{
    if(self.popupBlockTap){
        self.popupBlockTap(self);
    }else{
        [self popupHidden];
    }
}

@end


