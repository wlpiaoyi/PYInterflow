//
//  PYMoveView.h
//  PYInterflow
//
//  Created by wlpiaoyi on 2018/3/31.
//  Copyright © 2018年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pyutilea.h"
#import "PYInterflowParams.h"

@interface PYMoveView : UIView
//是否可以移动
kPNA BOOL isMoveable;
//是否可以垂直移动
kPNA BOOL isVerticalMoveabel;
//是否可以水平移动
kPNA BOOL isHorizontalMoveabel;
/**
 touch block 回调
 */
///===================================>
kPNCNA PYBlockPopupV_P_P_V blockTouchBegin;
kPNCNA PYBlockPopupV_P_P_V blockTouchMoved;
kPNCNA PYBlockPopupV_P_P_V blockTouchEnded;
kPNCNA PYBlockPopupV_P_P_V blockTouchCancelled;
///<===================================
@end
