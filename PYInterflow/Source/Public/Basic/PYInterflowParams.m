//
//  PYInterflowParams.m
//  PYInterflow
//
//  Created by wlpiaoyi on 2016/12/7.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "PYInterflowParams.h"
#import "PYUtile.h"
#import "PYPopupParam.h"

void * _Nonnull PY_OBJ_OrgWindow;

void (^BlockDialogButtonStyle)(UIButton * _Nonnull button);
BOOL STATIC_POPUP_HASEFFECT = NO;
CGFloat PYPopupEffectCpuUsage = .05;
CGFloat PYPopupAnimationTime = 10.0;
CGFloat PYPopupAnimationTimeOffset = .05;
CGFloat PYPopupEffectBlur = 0.15f;

CGFloat STATIC_POPUP_BORDERWIDTH = 1;
UIColor * _Nonnull STATIC_POPUP_HIGHLIGHTC;

UIColor * _Nonnull STATIC_CONTENT_BACKGROUNDCLOLOR;
UIColor * _Nonnull STATIC_DIALOG_BACKGROUNDC;
UIColor * _Nonnull STATIC_DIALOG_TEXTCLOLOR;
UIFont * _Nonnull STATIC_DIALOG_TITLEFONT;
UIFont * _Nonnull STATIC_DIALOG_MESSAGEFONT;
UIFont * _Nonnull STATIC_DIALOG_BUTTONFONT;

CGFloat STATIC_DIALOG_OFFSETBORDER = 20;
CGFloat STATIC_DIALOG_MINWIDTH = 260;
CGFloat STATIC_DIALOG_MAXWIDTH = 300;
CGFloat STATIC_DIALOG_MAXHEIGHT = 400;
CGFloat STATIC_DIALOG_WIDTH = 280;
CGFloat STATIC_DIALOG_OFFSETWIDTH = 2;
CGFloat STATIC_DIALOG_TITLE_HEIGHT = 44;
CGFloat STATIC_DIALOG_BUTTON_HEIGHT = 44;


UIColor * _Nonnull STATIC_EFFECT_TINTC;
UIColor * _Nonnull STATIC_SHEET_BACKGROUNDC;
UIColor * _Nonnull STATIC_SHEET_TITLEC;
UIColor * _Nonnull STATIC_SHEET_ITEMC;
UIColor * _Nonnull STATIC_SHEET_ITEMSElECTEDC;
UIColor * _Nonnull STATIC_SHEET_CANCELC;
UIColor * _Nonnull STATIC_SHEET_CONFIRMC;

UIFont * _Nonnull STATIC_SHEET_TITLEFONT;
UIFont * _Nonnull STATIC_SHEET_ITEMFONT;
UIFont * _Nonnull STATIC_SHEET_CANCELFONT;
UIFont * _Nonnull STATIC_SHEET_CONFIRMFONT;

UIColor * _Nonnull STATIC_TOPBAR_MESSAGEC;
UIColor * _Nonnull STATIC_TOPBAR_BGC;
UIFont * _Nonnull STATIC_TOPBAR_MESSAGEFONT;
NSBundle * _Nonnull STATIC_INTERFLOW_BUNDEL;

NSString * STATIC_POPUP_EFFECTE_NOTIFY = @"pypeffn";
NSString * STATIC_POPUP_SHOW_NOTIFY = @"adsfasdfasdf";
NSString * STATIC_POPUP_HIDEEN_NOTIFY = @"adfkididj";
@implementation PYInterflowParams

+(void) loadInterflowParamsData{
//#ifdef DEBUG
//    STATIC_INTERFLOW_BUNDEL =  [NSBundle mainBundle];
//#else
    STATIC_INTERFLOW_BUNDEL =  [NSBundle bundleWithPath:kFORMAT(@"%@/PYInterflow.bundle", bundleDir)];
//#endif
    STATIC_POPUP_BORDERWIDTH = 1.0/[UIScreen mainScreen].scale;
    STATIC_POPUP_HIGHLIGHTC = [UIColor colorWithRGBHex:0xAAAAFF33];
    STATIC_DIALOG_BACKGROUNDC = [UIColor whiteColor];
    STATIC_EFFECT_TINTC = [UIColor colorWithRGBHex:0x55555533];
    STATIC_SHEET_BACKGROUNDC = [UIColor whiteColor];
    STATIC_SHEET_TITLEC = [UIColor grayColor];
    STATIC_SHEET_ITEMSElECTEDC = [UIColor colorWithRGBHex:0xEEEEFFFF];
    STATIC_SHEET_CANCELC = [UIColor colorWithRGBHex:0xca0814ff];
    STATIC_SHEET_CONFIRMC = [UIColor colorWithRGBHex:0x157efaff];
    STATIC_SHEET_ITEMC = STATIC_SHEET_CONFIRMC;
    
    STATIC_SHEET_TITLEFONT = [UIFont systemFontOfSize:13];
    STATIC_SHEET_ITEMFONT = [UIFont systemFontOfSize:16];
    STATIC_SHEET_CANCELFONT = [UIFont boldSystemFontOfSize:16];
    STATIC_SHEET_CONFIRMFONT = STATIC_SHEET_ITEMFONT;
    
    STATIC_CONTENT_BACKGROUNDCLOLOR = [UIColor colorWithRed:0 green:0 blue:0 alpha:.3];
    STATIC_DIALOG_TEXTCLOLOR = [UIColor darkGrayColor];
    STATIC_DIALOG_TITLEFONT = [UIFont systemFontOfSize:18];
    STATIC_DIALOG_MESSAGEFONT = [UIFont italicSystemFontOfSize:14];
    STATIC_DIALOG_BUTTONFONT = [UIFont boldSystemFontOfSize:18];
    
    STATIC_TOPBAR_MESSAGEC = [UIColor colorWithRGBHex:0x000000AA];
    STATIC_TOPBAR_BGC = [UIColor whiteColor];
    STATIC_TOPBAR_MESSAGEFONT = [UIFont systemFontOfSize:14];
    [PYPopupParam RECIRCLE_REFRESH_EFFECT];
}


@end
