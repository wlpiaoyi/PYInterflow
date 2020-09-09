//
//  UIView+LeftSlide.m
//  PYInterflow
//
//  Created by wlpiaoyi on 2020/9/4.
//  Copyright © 2020 wlpiaoyi. All rights reserved.
//

#import "UIView+LeftSlide.h"

@implementation UIView (LeftSlide)

-(void) leftSlideShow{
    self.frameSize = CGSizeMake(self.frameWidth, DisableConstrainsValueMAX);
    self.popupEdgeInsets = UIEdgeInsetsMake(0, DisableConstrainsValueMAX, 0, 0);
    self.popupCenterPoint = CGPointMake(DisableConstrainsValueMAX, DisableConstrainsValueMAX);
    kAssign(self);
    [self setBlockShowAnimation:(^(UIView * _Nonnull view, PYBlockPopupV_P_V _Nullable block){
        kStrong(self);
        view.layer.transform = CATransform3DMakeTranslation(self.frameWidth, 0, 0);
          [UIView animateWithDuration:.5 animations:^{
              [view resetTransform];
          } completion:^(BOOL finished) {
              block(view);
          }];
      })];
      [self setBlockHiddenAnimation:(^(UIView * _Nonnull view, PYBlockPopupV_P_V _Nullable block){
          kStrong(self);
          [view resetTransform];
          [UIView animateWithDuration:.5 animations:^{
              view.layer.transform = CATransform3DMakeTranslation(self.frameWidth, 0, 0);
          } completion:^(BOOL finished) {
              block(view);
          }];
      })];
    [self popupShow];
}
-(void) leftSlideHidden{
    [self popupHidden];
}
@end
