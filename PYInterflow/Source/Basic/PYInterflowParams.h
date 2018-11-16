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

extern NSString * STATIC_POPUP_SHOW_NOTIFY;
extern NSString * STATIC_POPUP_HIDEEN_NOTIFY;
extern NSString * STATIC_POPUP_EFFECTE_NOTIFY;
extern BOOL STATIC_POPUP_HASEFFECT;

extern UIColor * _Nonnull STATIC_CONTENT_BACKGROUNDCLOLOR;

extern UIColor * _Nonnull STATIC_DIALOG_BACKGROUNDCLOLOR;
extern UIColor * _Nonnull STATIC_DIALOG_BORDERCLOLOR;
extern UIColor * _Nonnull STATIC_DIALOG_TEXTCLOLOR;
extern UIFont * _Nonnull STATIC_DIALOG_TITLEFONT;
extern UIFont * _Nonnull STATIC_DIALOG_MESSAGEFONT;
extern UIFont * _Nonnull STATIC_DIALOG_BUTTONFONT;
extern CGFloat STATIC_DIALOG_OFFSETBORDER;
extern CGFloat STATIC_DIALOG_MINWIDTH;
extern CGFloat STATIC_DIALOG_MAXWIDTH;
extern CGFloat STATIC_DIALOG_MAXHEIGHT;
extern CGFloat STATIC_DIALOG_BORDERWIDTH;
extern CGFloat STATIC_DIALOG_WIDTH;
extern CGFloat STATIC_DIALOG_OFFSETWIDTH;
extern CGFloat STATIC_DIALOG_TITLE_HEIGHT;
extern CGFloat STATIC_DIALOG_BUTTON_HEIGHT;


extern UIColor * _Nonnull STATIC_SHEET_TITLEC;
extern UIColor * _Nonnull STATIC_SHEET_TITLEBGC;
extern UIColor * _Nonnull STATIC_SHEET_CONTEXTNORMALC;
extern UIColor * _Nonnull STATIC_SHEET_CONTEXTNORMALBGC;
extern UIColor * _Nonnull STATIC_SHEET_CONTEXTHIGHTLIGHTC;
extern UIColor * _Nonnull STATIC_SHEET_CONTEXTHIGHTLIGHTBGC;
extern UIColor * _Nonnull STATIC_SHEET_CANCELNORMALC;
extern UIColor * _Nonnull STATIC_SHEET_CANCELNORMALBGC;
extern UIColor * _Nonnull STATIC_SHEET_CANCELHIGHTLIGHTC;
extern UIColor * _Nonnull STATIC_SHEET_CANCELHIGHTLIGHTBGC;
extern UIFont * _Nonnull STATIC_SHEET_TITLEFONT;
extern UIFont * _Nonnull STATIC_SHEET_CONTEXTFONT;
extern UIFont * _Nonnull STATIC_SHEET_CANCELFONT;


extern UIColor * _Nonnull STATIC_TOPBAR_MESSAGEC;
extern UIColor * _Nonnull STATIC_TOPBAR_BGC;
extern UIFont * _Nonnull STATIC_TOPBAR_MESSAGEFONT;


typedef void (^BlockTouchView)(CGPoint touhMove, UIView  * _Nonnull touchView);
typedef void (^BlockPopupEndAnmation) (UIView * _Nonnull view);
typedef void (^BlockPopupAnimation) (UIView * _Nonnull view, BlockPopupEndAnmation _Nullable block);
typedef void(^BlockDialogOpt)(UIView * _Nonnull view, NSUInteger index);


@interface PYInterflowParams : NSObject
+(void) loadInterflowParamsData;
//+(void) setView:(nonnull UIView *) view shadowOffset:(CGSize) size;
@end

#endif /* PYPopupParams_h */

