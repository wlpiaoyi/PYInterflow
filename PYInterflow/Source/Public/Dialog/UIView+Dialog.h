//
//  UIView+Dialog.h
//  PYInterchange
//
//  Created by wlpiaoyi on 16/1/21.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYInterflowParams.h"
#import "pyutilea.h"

/**
 对话框
 */
@interface UIView(Dialog)
kPNSNA id dialogUserInfo;
#pragma 对话框标题
kPNSNA id dialogTitle;
#pragma 对话框描述
kPNSNA id dialogMessage;
#pragma 对话框普通转态按钮
kPNSNA NSArray<id> * dialogNormalNames;
#pragma 对话框高亮状态按钮
kPNSNA NSArray<id> * dialogHighlightlNames;
#pragma 对话框按钮单击回调
kPNSNA PYBlockPopupV_P_V_I dialogOptBlock;
#pragma 对话框描述文字布局
kPNA NSTextAlignment dialogMessageTextAlignment;
#pragma 对话框用作为控制的
kPNRNN UIView * dialogShowView;

#pragma 显示对话框
//====================================================>
-(void) dialogShow;
-(void) dialogShowWithTitle:(nullable NSString *) title
                    message:(nullable NSString *) message
                    block:(nonnull PYBlockPopupV_P_V_B) block
                    buttonConfirm:(nullable NSString*) buttonConfirm
                    buttonCancel:(nullable NSString*) buttonCancel;
-(void) dialogShowWithTitle:(nullable NSString *) title
                    message:(nullable NSString *) message
                    block:(nullable PYBlockPopupV_P_V_I) block
                    buttonNames:(nonnull NSArray<NSString*>*)buttonNames;
-(void) dialogShowWithAttributeTitle:(nullable NSAttributedString *) attributeTitle
                    attributeMessage:(nullable NSAttributedString *) attributeMessage
                    block:(nullable PYBlockPopupV_P_V_I) block
                    buttonNormalNames:(nonnull NSArray<NSAttributedString*>*)buttonNormalNames
                    buttonHightLightNames:(nonnull NSArray<NSAttributedString*>*)buttonHightLightNames;
-(void) dialogShowWithTitle:(nullable NSString *) title
                    block:(nullable PYBlockPopupV_P_V_I) block
                    buttonNames:(nonnull NSArray<NSString*>*)buttonNames;
-(void) dialogShowWithAttributeTitle:(nullable NSAttributedString *) attributeTitle
                    block:(nullable PYBlockPopupV_P_V_I) block
                    buttonNormalNames:(nonnull NSArray<NSAttributedString*>*)buttonNormalNames
                    buttonHightLightNames:(nonnull NSArray<NSAttributedString*>*)buttonHightLightNames;
///<====================================================

#pragma 隐藏对话框
-(void) dialogHidden;

@end
