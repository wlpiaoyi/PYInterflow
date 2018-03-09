//
//  UIView+Popup.m
//  PYInterchange
//
//  Created by wlpiaoyi on 16/1/21.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "UIView+Popup.h"
#import "UIView+Remove.h"
#import "PYPopupParam.h"
#import "pyutilea.h"
#import <objc/runtime.h>

static const void *UIViewPopupPointer = &UIViewPopupPointer;

@implementation UIView(Popup)
-(void) setPopupBlockEnd:(void (^)(UIView * _Nullable))blockEnd{
    [self param].blockEnd = blockEnd;
}
-(void (^)(UIView * _Nullable)) popupBlockEnd{
    return [self param].blockEnd;
}
-(void) setPopupBlockStart:(void (^)(UIView * _Nullable))blockStart{
    [self param].blockStart = blockStart;
}
-(void (^)(UIView * _Nullable)) popupBlockStart{
    return [self param].blockStart;
}
-(CGRect) frameOrg{
    return [self param].frameOrg;
}
-(void) setFrameOrg:(CGRect) frame{
    [self param].frameOrg = frame;
}
-(BOOL) popupisAnimation{
    return [self param].isAnimationing;
}
-(void) setPopupisAnimation:(BOOL)isAnimationing{
    [self param].isAnimationing = isAnimationing;
}

-(void) popupShow{
    [self popupShowForHasContentView:YES];
}
-(void) popupShowForHasContentView:(BOOL) hasContentView{
    @synchronized(self){
        self.moveable = self.moveable;
        if (self.popupIsShow) return;
        else self.popupIsShow = true;
        [self removeFromSuperview];
        
        if (self.popupBaseView == nil) self.popupBaseView = (UIView*)[PYPopupWindow instanceForFrame:[UIScreen mainScreen].bounds];
        
        if([self.popupBaseView isKindOfClass:[PYPopupWindow class]]){
            [((UIWindow *)self.popupBaseView) makeKeyAndVisible];
        }
        if(hasContentView){
            [self param].contentView = [UIView new];
            self.popupContentView.backgroundColor = [UIColor clearColor];
            [self.popupContentView addSubview:self];
            [self.popupBaseView addSubview:self.popupContentView];
        }else{
            [self.popupBaseView addSubview:self];
        }
        [self resetAutoLayout];
        [self resetTransform];
        
        BlockPopupAnimation blockAnimation = [self blockShowAnimation];
        if (!blockAnimation) {
            blockAnimation = [[self param] creteDefaultBlcokPopupShowAnmation];
        }
        BlockPopupEndAnmation blockEnd = [[self param] creteDefaultBlcokPopupShowEndAnmation];
        blockAnimation(self, blockEnd);
    }
}

-(void) popupHidden{
    @synchronized(self) {
        if (!self.popupIsShow) {
            return;
        }
        self.popupIsShow = false;
        
        BlockPopupAnimation block = [self blockHiddenAnimation];
        if (!block) {
            block = [[self param] creteDefaultBlcokPopupHiddenAnmation];
        }
        BlockPopupEndAnmation blockEnd = [[self param]creteDefaultBlcokPopupHiddenEndAnmation];
        block(self,blockEnd);
    }
}

-(CGPoint) popupCenterPoint{
    return [self param].centerPoint;
}

-(void) setPopupCenterPoint:(CGPoint)center{
    [self param].centerPoint = center;
}

-(UIEdgeInsets) popupEdgeInsets{
    return [self param].borderEdgeInsets;
}

-(void) setPopupEdgeInsets:(UIEdgeInsets)borderEdgeInsets{
    [self param].borderEdgeInsets = borderEdgeInsets;
}

-(BOOL) popupIsShow{
    return [self param].isShow;
}
-(void) setPopupIsShow:(BOOL) isShow{
    [self param].isShow = isShow;
}
-(void) resetTransform{
    @synchronized(self) {
        CATransform3D transform = CATransform3DIdentity;
        transform = CATransform3DScale(transform, 1, 1,1);
        self.layer.transform = transform;
    }
}
-(void) resetAutoLayout{
    @synchronized(self) {
        CGSize s = self.frameSize;
        CGPoint p = self.popupCenterPoint;
        UIEdgeInsets e = self.popupEdgeInsets;
        
        for (NSLayoutConstraint * lc in [self param].lc.objectEnumerator) {
            [self.popupBaseView removeConstraint:lc];
            [self removeConstraint:lc];
        }
        NSMutableDictionary<NSString *, NSLayoutConstraint *> * lc =  [NSMutableDictionary new];
        NSDictionary<NSString *, NSLayoutConstraint *> * templc = [PYViewAutolayoutCenter persistConstraint:self centerPointer:p];
        for (NSString * key in templc) {
            [lc setObject:templc[key] forKey:key];
        }
        PYEdgeInsetsItem eii = PYEdgeInsetsItemNull();
        eii.topActive = eii.bottomActive = eii.leftActive = eii.rightActive = true;
        templc = [PYViewAutolayoutCenter persistConstraint:self relationmargins:e relationToItems:eii];
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
        [self param].lc = lc;
    }
}

-(UIView*) popupBaseView{
    return [self param].baseView;
}
-(void) setPopupBaseView:(UIView*) view{
    [self param].baseView = view;
}
-(UIView*) popupContentView{
    return [self param].contentView;
}
-(void) setBlockShowAnimation:(BlockPopupAnimation) block{
    [self param].blockShowAnimation = block;
}
-(BlockPopupAnimation) blockShowAnimation{
    return [self param].blockShowAnimation;
}
-(void) setBlockHiddenAnimation:(BlockPopupAnimation) block{
    [self param].blockHiddenAnimation = block;
}
-(BlockPopupAnimation) blockHiddenAnimation{
    return [self param].blockHiddenAnimation;
}
-(PYPopupParam *) param{
    PYPopupParam * param = objc_getAssociatedObject(self, UIViewPopupPointer);
    if(param == nil){
        param = [PYPopupParam new];
        objc_setAssociatedObject(self, UIViewPopupPointer, param, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return param;
}
@end


