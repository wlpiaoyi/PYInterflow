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

@class PYInterflowBaseValue, PYInterflowPopupValue;

@interface PYInterflowConfValue : NSObject
kPNSNA PYInterflowBaseValue * base;
kPNSNA PYInterflowPopupValue * popup;
@end;

/**
 基础配置设置
 */
@interface PYInterflowBaseValue : NSObject
kPNA CGFloat cpuUseage;
kPNA CGFloat animationTime;
kPNA CGFloat animationTimeOffset;
kPNA CGFloat floatEffectBlur;
kPNA BOOL hasEffect;
@end

/**
 基础弹框设置
 */
@interface PYInterflowPopupValue : NSObject
kPNA CGFloat borderWidth;
kPNSNA UIColor *  colorHighlightBg;
kPNSNA UIColor *  colorHighlightTxt;
kPNSNA NSString * notifyShow;
kPNSNA NSString * notifyHidden;
kPNSNA NSString * notifyEffcte;
@end

extern PYInterflowConfValue * _Nonnull xPYInterflowConfValue;



extern UIColor * _Nonnull STATIC_CONTENT_BACKGROUNDCLOLOR;

extern UIColor * _Nonnull STATIC_DIALOG_BACKGROUNDC;
extern UIColor * _Nonnull STATIC_DIALOG_TEXTCLOLOR;
extern UIFont * _Nonnull STATIC_DIALOG_TITLEFONT;
extern UIFont * _Nonnull STATIC_DIALOG_MESSAGEFONT;
extern UIFont * _Nonnull STATIC_DIALOG_BUTTONFONT;
extern CGFloat STATIC_DIALOG_OFFSETLINE;
extern CGFloat STATIC_DIALOG_OFFSETBORDER;
extern CGFloat STATIC_DIALOG_MINWIDTH;
extern CGFloat STATIC_DIALOG_MAXWIDTH;
extern CGFloat STATIC_DIALOG_MAXHEIGHT;
extern CGFloat STATIC_DIALOG_WIDTH;
extern CGFloat STATIC_DIALOG_OFFSETWIDTH;
extern CGFloat STATIC_DIALOG_BUTTON_HEIGHT;


extern UIColor * _Nonnull STATIC_EFFECT_TINTC;
extern UIColor * _Nonnull STATIC_SHEET_BACKGROUNDH;
extern UIColor * _Nonnull STATIC_SHEET_BACKGROUNDC;
extern UIColor * _Nonnull STATIC_SHEET_TITLEC;
extern UIColor * _Nonnull STATIC_SHEET_ITEMC;
extern UIColor * _Nonnull STATIC_SHEET_ITEMSElECTEDC;
extern UIColor * _Nonnull STATIC_POPUP_REDC;
extern UIColor * _Nonnull STATIC_POPUP_BLUEC;

extern UIFont * _Nonnull STATIC_SHEET_TITLEFONT;
extern UIFont * _Nonnull STATIC_SHEET_ITEMFONT;
extern UIFont * _Nonnull STATIC_SHEET_CONFIRMFONT;
extern UIFont * _Nonnull STATIC_SHEET_CANCELFONT;

extern UIImage * _Nonnull STATIC_SHEET_IMAGE_LINE;

extern UIColor * _Nonnull STATIC_TOPBAR_MESSAGEC;
extern UIColor * _Nonnull STATIC_TOPBAR_BGC;
extern UIFont * _Nonnull STATIC_TOPBAR_MESSAGEFONT;

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

