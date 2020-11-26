//
//  UIView+LeftSlide.m
//  PYInterflow
//
//  Created by wlpiaoyi on 2020/9/4.
//  Copyright © 2020 wlpiaoyi. All rights reserved.
//

#import "UIView+LeftSlide.h"

static const void *UIViewLeftSlideCtxViewPointer = &UIViewLeftSlideCtxViewPointer;

@interface UIView (LeftSlide)

kPNA UIView * leftSildeCtxView;

@end

@implementation UIView (LeftSlide)

-(UIView *) leftSildeCtxView{
    UIView * leftSildeCtxView = objc_getAssociatedObject(self, UIViewLeftSlideCtxViewPointer);
    return leftSildeCtxView;
}

-(void) setLeftSildeCtxView:(UIView *)leftSildeCtxView{
    objc_setAssociatedObject(self, UIViewLeftSlideCtxViewPointer, leftSildeCtxView, OBJC_ASSOCIATION_ASSIGN);
}

-(void) leftSlideShow{
    UIView * leftSlideView = [UIView new];
    leftSlideView.frameSize = CGSizeMake(self.frameWidth, DisableConstrainsValueMAX);
    leftSlideView.popupEdgeInsets = UIEdgeInsetsMake(0, DisableConstrainsValueMAX, 0, 0);
    leftSlideView.popupCenterPoint = CGPointMake(DisableConstrainsValueMAX, DisableConstrainsValueMAX);
    [leftSlideView addSubview:self];
    [self py_makeConstraints:^(PYConstraintMaker * _Nonnull make) {
        make.top.left.bottom.right.py_constant(0);
    }];
    
    UIView * topView = topView = [UIView new];
    [leftSlideView addSubview:topView];
    kAssign(self);
    [topView py_makeConstraints:^(PYConstraintMaker * _Nonnull make) {
        kStrong(self);
        make.left.right.py_constant(0);
        make.bottom.py_toItem(self).py_constant(0);
        make.height.py_constant(100);
    }];
    UIView * bottomView = [UIView new];
    [leftSlideView addSubview:bottomView];
    self.leftSildeCtxView = leftSlideView;
    
    [bottomView py_makeConstraints:^(PYConstraintMaker * _Nonnull make) {
        make.left.right.py_constant(0);
        make.top.py_toItem(self).py_constant(0);
        make.height.py_constant(100);
    }];
    topView.backgroundColor = self.backgroundColor;
    bottomView.backgroundColor = self.backgroundColor;
    [leftSlideView setBlockShowAnimation:(^(UIView * _Nonnull view, PYBlockPopupV_P_V _Nullable block){
        kStrong(self);
        view.layer.transform = CATransform3DMakeTranslation(self.leftSildeCtxView.frameWidth, 0, 0);
          [UIView animateWithDuration:.5 animations:^{
              [view resetTransform];
          } completion:^(BOOL finished) {
              block(view);
          }];
        })];
    [leftSlideView setBlockHiddenAnimation:(^(UIView * _Nonnull view, PYBlockPopupV_P_V _Nullable block){
        kStrong(self);
        [view resetTransform];
        [UIView animateWithDuration:.5 animations:^{
            view.layer.transform = CATransform3DMakeTranslation(self.leftSildeCtxView.frameWidth, 0, 0);
        } completion:^(BOOL finished) {
            block(view);
            self.leftSildeCtxView = nil;
        }];
    })];
    [leftSlideView popupShow];
}
-(void) leftSlideHidden{
    [self.leftSildeCtxView popupHidden];
}
@end
