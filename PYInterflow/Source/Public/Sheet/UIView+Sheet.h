//
//  UIView+Sheet.h
//  PYInterflow
//
//  Created by wlpiaoyi on 2016/12/6.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pyutilea.h"
#import "PYInterflowParams.h"

@interface UIView(Sheet)

/**
 基础层
 */
kPNRNN UIView * sheetShowView;
/**
 点击空白区域隐藏, 默认true
 */
kPNA BOOL sheetIsHiddenOnClick;
/**
 当前选择的项目
 */
kPNCNA NSArray<NSNumber *> * sheetSelectedIndexs;
/**
 标题
 */
kPNSNA NSString * sheetTitle;
/**
 确认按钮
 */
kPNSNA NSString * sheetConfirme;
/**
 取消按钮
 */
kPNSNA NSString * sheetCancel;
/**
 选择过程中的回调

 */
kPNCNA BOOL(^sheetBlockSelecting)(BOOL isSelected, NSUInteger cureentIndex);
/**
 
 */
kPNCNA void(^sheetBlcokOpt)(UIView * _Nonnull view, BOOL isConfirm);

-(void) sheetShow;

-(void) sheetShowWithTitle:(nullable NSString *) title
            previousName:(nullable NSString *) previousName
            nextName:(nullable NSString *) nextName
            blockOpt:(nullable PYBlockPopupV_P_V_I) blcokOpt;

-(void) sheetShowWithItemstrings:(nullable NSArray<NSString *> *) itemstrings;

-(void) sheetHidden;
@end
