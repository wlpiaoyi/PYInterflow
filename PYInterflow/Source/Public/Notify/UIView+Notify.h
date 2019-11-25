//
//  UIView+Notify.h
//  PYInterflow
//
//  Created by wlpiaoyi on 2016/12/9.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYInterflowParams.h"

@interface UIView(Notify)
/**
 文字通知显示
 */
///=================================>
-(void) notifyShow:(NSUInteger) time message:(nullable NSString *) message blockTap:(nullable PYBlockPopupV_P_V) blockTap;
-(void) notifyShow:(NSUInteger) time attributeMessage:(nullable NSAttributedString *) attributeMessage blockTap:(nullable PYBlockPopupV_P_V) blockTap;
-(void) notifyShow:(NSUInteger) time message:(nullable NSString *) message color:(nullable UIColor *) color blockTap:(nullable PYBlockPopupV_P_V) blockTap;
-(void) notifyShow:(NSUInteger) time attributeMessage:(nullable NSAttributedString *) attributeMessage color:(nullable UIColor *) color blockTap:(nullable PYBlockPopupV_P_V) blockTap;
///<=================================

-(void) notifyShow;
-(void) notifyHidden;
@end
