//
//  PYPopupParams.h
//  PYInterflow
//
//  Created by wlpiaoyi on 2016/11/30.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#ifndef PYInterflowParams_h
#define PYInterflowParams_h
#import <UIKit/UIKit.h>
#import "pyutilea.h"

@class PYInterflowBaseValue, PYInterflowPopupValue, PYInterflowDialogValue, PYInterflowSheetValue, PYInterflowTopbarValue;

@interface PYInterflowConfValue : NSObject

kPNSNA PYInterflowBaseValue * base;
kPNSNA PYInterflowPopupValue * popup;
kPNSNA PYInterflowDialogValue * dialog;
kPNSNA PYInterflowSheetValue * sheet;
kPNSNA PYInterflowTopbarValue * toast;

@end;

/**
 基础配置设置
 */
@interface PYInterflowBaseValue : NSObject

kPNA BOOL hasEffect;
kPNA CGFloat maxCpuUsage;
kPNA CGFloat animationTime;
kPNA CGFloat animationTimeOffset;
kPNA CGFloat floatEffectBlur;
kPNSNA UIColor *  colorEffectTint;
kPNSNA UIColor *  colorContentBg;

@end

/**
 基础弹框设置
 */
@interface PYInterflowPopupValue : NSObject

kPNA CGFloat borderWidth;
kPNSNA UIColor *  colorLine;
kPNSNA UIColor *  colorHighlightBg;
kPNSNA UIColor *  colorHighlightTxt;
kPNSNA NSString * notifyShow;
kPNSNA NSString * notifyHidden;
kPNSNA NSString * notifyEffcte;

@end

/**
 对话弹框设置
 */
@interface PYInterflowDialogValue : NSObject

kPNA CGFloat offsetLine;
kPNA CGFloat offsetBorder;
kPNA CGFloat minWidth;
kPNA CGFloat maxWidth;
kPNA CGFloat maxHeight;
kPNA CGFloat width;
kPNA CGFloat offsetWith;
kPNA CGFloat buttonHeight;

kPNSNA UIColor *  colorBg;
kPNSNA UIColor *  colorTitle;
kPNSNA UIColor *  colorMessage;
kPNSNA UIColor *  colorConfirme;
kPNSNA UIColor *  colorCancel;
kPNSNA UIFont *  fontTitle;
kPNSNA UIFont *  fontMessage;
kPNSNA UIFont *  fontButton;
kPNSNA UIFont *  fontConfirm;
kPNSNA UIFont *  fontCancel;

@end


/**
 薄片弹框设置
 */
@interface PYInterflowSheetValue : NSObject

kPNSNA UIColor *  colorBg;
kPNSNA UIColor *  colorTitle;
kPNSNA UIColor *  colorItem;
kPNSNA UIColor *  colorItemSelected;
kPNSNA UIColor *  colorConfirme;
kPNSNA UIColor *  colorCancel;

kPNSNA UIFont *  fontTitle;
kPNSNA UIFont *  fontItem;
kPNSNA UIFont *  fontConfirm;
kPNSNA UIFont *  fontCancel;

kPNSNA UIImage * imageLine;

@end

/**
 吐司弹框设置
 */
@interface PYInterflowTopbarValue : NSObject

kPNA CGFloat offsetWith;

kPNSNA UIColor *  colorMsg;
kPNSNA UIColor *  colorBg;

kPNSNA UIFont *  fontMsg;

@end

extern PYInterflowConfValue * _Nonnull xPYInterflowConfValue;


extern NSBundle * _Nonnull STATIC_INTERFLOW_BUNDEL;

typedef void (^PYBlockPopupV_P_P_V)(CGPoint touhMove, UIView  * _Nonnull touchView);
typedef void (^PYBlockPopupV_P_V) (UIView * _Nonnull view);
typedef BOOL (^PYBlockPopupB_P_V) (UIView * _Nonnull view);
typedef void (^PYBlockPopupV_P_V_BK) (UIView * _Nonnull view, PYBlockPopupV_P_V _Nullable block);
typedef void(^PYBlockPopupV_P_V_I)(UIView * _Nonnull view, NSUInteger index);
typedef void(^PYBlockPopupV_P_V_B)(UIView * _Nonnull view, BOOL isConfirm);


@interface PYInterflowParams : NSObject
+(void) loadInterflowParamsData;
+(void) loadInterflowParamsData:(nonnull NSBundle *) bundlePath;
//+(void) setView:(nonnull UIView *) view shadowOffset:(CGSize) size;
@end

#endif /* PYPopupParams_h */

