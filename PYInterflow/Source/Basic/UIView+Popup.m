//
//  UIView+Popup.m
//  PYInterchange
//
//  Created by wlpiaoyi on 16/1/21.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "UIView+Popup.h"
#import "UIView+Remove.h"
#import "UIViewPopupParam.h"
#import "pyutilea.h"
#import <objc/runtime.h>

static const void *UIViewPopupPointer = &UIViewPopupPointer;

@implementation UIView(Popup)
-(void) setBlockEnd:(void (^)(UIView * _Nullable))blockEnd{
    [self param].blockEnd = blockEnd;
}
-(void (^)(UIView * _Nullable)) blockEnd{
    return [self param].blockEnd;
}
-(void) setBlockStart:(void (^)(UIView * _Nullable))blockStart{
    [self param].blockStart = blockStart;
}
-(void (^)(UIView * _Nullable)) blockStart{
    return [self param].blockStart;
}
-(CGRect) frameOrg{
    return [self param].frameOrg;
}
-(void) setFrameOrg:(CGRect) frame{
    [self param].frameOrg = frame;
}
-(BOOL) isAnimationing{
    return [self param].isAnimationing;
}
-(void) setIsAnimationing:(BOOL)isAnimationing{
    [self param].isAnimationing = isAnimationing;
}
-(void) popupShow{
    @synchronized(self){
        
        if (self.isShow) return;
        else self.isShow = true;
        
//        [self param].preWidnow = [UIApplication sharedApplication].keyWindow;
        if (self.baseView == nil) [self param].baseView = (UIView*)[[PYPopupWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        if([self.baseView isKindOfClass:[PYPopupWindow class]]){
            [((UIWindow *)self.baseView) makeKeyAndVisible];
        }
        
        [self removeFromSuperview];
        [self.baseView addSubview:self];
        [self resetBoundPoint];
        
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
        
        if (!self.isShow) {
            return;
        }
        self.isShow = false;
        
        BlockPopupAnimation block = [self blockHiddenAnimation];
        if (!block) {
            block = [[self param] creteDefaultBlcokPopupHiddenAnmation];
        }
        BlockPopupEndAnmation blockEnd = [[self param]creteDefaultBlcokPopupHiddenEndAnmation];
        block(self,blockEnd);
    }
}

-(CGPoint) centerPoint{
    return [self param].centerPoint;
}

-(void) setCenterPoint:(CGPoint)center{
    [self param].centerPoint = center;
//    [self param].borderEdgeInsets = UIEdgeInsetsMake(DisableConstrainsValueMAX, DisableConstrainsValueMAX, DisableConstrainsValueMAX, DisableConstrainsValueMAX);
}

-(UIEdgeInsets) borderEdgeInsets{
    return [self param].borderEdgeInsets;
}

-(void) setBorderEdgeInsets:(UIEdgeInsets)borderEdgeInsets{
    [self param].borderEdgeInsets = borderEdgeInsets;
//    [self param].centerPoint = CGPointMake(DisableConstrainsValueMAX, DisableConstrainsValueMAX);
}

-(BOOL) isShow{
    return [self param].isShow;
}
-(void) setIsShow:(BOOL) isShow{
    [self param].isShow = isShow;
}
-(void) resetBoundPoint{
    @synchronized(self) {
        CGSize s = self.frameSize;
        CGPoint p = self.centerPoint;
        UIEdgeInsets e = self.borderEdgeInsets;
        
        for (NSLayoutConstraint * lc in [self param].lc.objectEnumerator) {
            [self.baseView removeConstraint:lc];
            [self removeConstraint:lc];
        }
        NSMutableDictionary<NSString *, NSLayoutConstraint *> * lc =  [NSMutableDictionary new];
        [lc setDictionary:[PYViewAutolayoutCenter persistConstraint:self centerPointer:p]];
        [lc setDictionary:[PYViewAutolayoutCenter persistConstraint:self relationmargins:e relationToItems:PYEdgeInsetsItemNull()]];
        [lc setDictionary:[PYViewAutolayoutCenter persistConstraint:self size:s]];
        [self param].lc = lc;
        
        CATransform3D transform = CATransform3DIdentity;
        transform = CATransform3DScale(transform, 1, 1,1);
        self.layer.transform = transform;
    }
}
-(UIView*) baseView{
    return [self param].baseView;
}
-(void) setBaseView:(UIView*) baseView{
    [self param].baseView = baseView;
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
-(UIViewPopupParam *) param{
    UIViewPopupParam * param = objc_getAssociatedObject(self, UIViewPopupPointer);
    if(param == nil){
        param = [UIViewPopupParam new];
        objc_setAssociatedObject(self, UIViewPopupPointer, param, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return param;
}
@end


