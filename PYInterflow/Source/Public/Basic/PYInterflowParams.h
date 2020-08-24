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

extern void (^_Nullable BlockDialogButtonStyle)(UIButton * _Nonnull button);

extern CGFloat PYPopupEffectCpuUsage;
extern CGFloat PYPopupAnimationTime;
extern CGFloat PYPopupAnimationTimeOffset;
extern CGFloat PYPopupEffectBlur;

extern NSString * _Nonnull STATIC_POPUP_SHOW_NOTIFY;
extern NSString * _Nonnull STATIC_POPUP_HIDEEN_NOTIFY;
extern NSString * _Nonnull STATIC_POPUP_EFFECTE_NOTIFY;
extern BOOL STATIC_POPUP_HASEFFECT;

extern CGFloat STATIC_POPUP_BORDERWIDTH;
extern UIColor * _Nonnull STATIC_POPUP_HIGHLIGHTC;

extern UIColor * _Nonnull STATIC_CONTENT_BACKGROUNDCLOLOR;

extern UIColor * _Nonnull STATIC_DIALOG_BACKGROUNDC;
extern UIColor * _Nonnull STATIC_DIALOG_TEXTCLOLOR;
extern UIFont * _Nonnull STATIC_DIALOG_TITLEFONT;
extern UIFont * _Nonnull STATIC_DIALOG_MESSAGEFONT;
extern UIFont * _Nonnull STATIC_DIALOG_BUTTONFONT;
extern CGFloat STATIC_DIALOG_OFFSETBORDER;
extern CGFloat STATIC_DIALOG_MINWIDTH;
extern CGFloat STATIC_DIALOG_MAXWIDTH;
extern CGFloat STATIC_DIALOG_MAXHEIGHT;
extern CGFloat STATIC_DIALOG_WIDTH;
extern CGFloat STATIC_DIALOG_OFFSETWIDTH;
extern CGFloat STATIC_DIALOG_TITLE_HEIGHT;
extern CGFloat STATIC_DIALOG_BUTTON_HEIGHT;


extern UIColor * _Nonnull STATIC_EFFECT_TINTC;
extern UIColor * _Nonnull STATIC_SHEET_BACKGROUNDH;
extern UIColor * _Nonnull STATIC_SHEET_BACKGROUNDC;
extern UIColor * _Nonnull STATIC_SHEET_TITLEC;
extern UIColor * _Nonnull STATIC_SHEET_ITEMC;
extern UIColor * _Nonnull STATIC_SHEET_ITEMSElECTEDC;
extern UIColor * _Nonnull STATIC_SHEET_CANCELC;
extern UIColor * _Nonnull STATIC_SHEET_CONFIRMC;

extern UIFont * _Nonnull STATIC_SHEET_TITLEFONT;
extern UIFont * _Nonnull STATIC_SHEET_ITEMFONT;
extern UIFont * _Nonnull STATIC_SHEET_CONFIRMFONT;
extern UIFont * _Nonnull STATIC_SHEET_CANCELFONT;

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

