//
//  UIView+Notify.h
//  PYInterflow
//
//  Created by wlpiaoyi on 2016/12/9.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView(Notify)
/**
 通知显示
 */
///=================================>
-(void) notifyShow:(CGFloat) time message:(nullable NSString *) message blockTap:(void (^) (UIView * _Nonnull targetView)) blockTap;
-(void) notifyShow:(CGFloat) time attributeMessage:(nullable NSAttributedString *) attributeMessage blockTap:(void (^) (UIView * _Nonnull targetView)) blockTap;
-(void) notifyShow;
///<=================================
-(void) notifyHidden;
@end
