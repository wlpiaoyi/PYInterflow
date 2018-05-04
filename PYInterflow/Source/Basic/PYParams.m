//
//  PYParams.m
//  PYInterflow
//
//  Created by wlpiaoyi on 2016/12/7.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "PYParams.h"
#import "PYUtile.h"

void * _Nonnull PY_OBJ_OrgWindow;

void (^BlockDialogButtonStyle)(UIButton * _Nonnull button);

CGFloat PYPopupAnimationTime = 10.0;
CGFloat PYPopupAnimationTimeOffset = .05;
CGFloat STATIC_POPUP_BORDERWIDTH = .5;
CGFloat STATIC_POPUP_WIDTH = 280;
CGFloat STATIC_POPUP_OFFSETWIDTH = 2;
CGFloat STATIC_POPUP_TITLE_HEIGHT = 38;
CGFloat STATIC_POPUP_BUTTON_HEIGHT = 38;


UIColor * _Nonnull STATIC_CONTENT_BACKGROUNDCLOLOR;

UIColor * _Nonnull STATIC_DIALOG_BACKGROUNDCLOLOR;
UIColor * _Nonnull STATIC_DIALOG_BORDERCLOLOR;
UIColor * _Nonnull STATIC_DIALOG_TEXTCLOLOR;
UIFont * _Nonnull STATIC_DIALOG_TITLEFONT;
UIFont * _Nonnull STATIC_DIALOG_MESSAGEFONT;
UIFont * _Nonnull STATIC_DIALOG_BUTTONFONT;
CGFloat STATIC_DIALOG_OFFSETBORDER = 12;
CGFloat STATIC_DIALOG_MINWIDTH = 200;
CGFloat STATIC_DIALOG_MAXWIDTH = 280;
CGFloat STATIC_DIALOG_MAXHEIGHT = 400;


UIColor * _Nonnull STATIC_SHEET_TITLEC;
UIColor * _Nonnull STATIC_SHEET_TITLEBGC;
UIColor * _Nonnull STATIC_SHEET_CONTEXTNORMALC;
UIColor * _Nonnull STATIC_SHEET_CONTEXTNORMALBGC;
UIColor * _Nonnull STATIC_SHEET_CONTEXTHIGHTLIGHTC;
UIColor * _Nonnull STATIC_SHEET_CONTEXTHIGHTLIGHTBGC;
UIColor * _Nonnull STATIC_SHEET_CANCELNORMALC;
UIColor * _Nonnull STATIC_SHEET_CANCELNORMALBGC;
UIColor * _Nonnull STATIC_SHEET_CANCELHIGHTLIGHTC;
UIColor * _Nonnull STATIC_SHEET_CANCELHIGHTLIGHTBGC;
UIFont * _Nonnull STATIC_SHEET_TITLEFONT;
UIFont * _Nonnull STATIC_SHEET_CONTEXTFONT;
UIFont * _Nonnull STATIC_SHEET_CANCELFONT;

UIColor * _Nonnull STATIC_TOPBAR_MESSAGEC;
UIColor * _Nonnull STATIC_TOPBAR_BGC;
UIFont * _Nonnull STATIC_TOPBAR_MESSAGEFONT;

@implementation PYParams

+(void) loadInterflowParamsData{
    STATIC_SHEET_TITLEC = [UIColor darkGrayColor];
    STATIC_SHEET_TITLEBGC = [UIColor whiteColor];
    STATIC_SHEET_CONTEXTNORMALC = [UIColor grayColor];
    STATIC_SHEET_CONTEXTNORMALBGC = [UIColor whiteColor];
    STATIC_SHEET_CONTEXTHIGHTLIGHTC = STATIC_SHEET_CONTEXTNORMALBGC;
    STATIC_SHEET_CONTEXTHIGHTLIGHTBGC = STATIC_SHEET_CONTEXTNORMALC;
    STATIC_SHEET_CANCELNORMALC = [UIColor grayColor];
    STATIC_SHEET_CANCELNORMALBGC = [UIColor whiteColor];
    STATIC_SHEET_CANCELHIGHTLIGHTC = STATIC_SHEET_CANCELNORMALBGC;;
    STATIC_SHEET_CANCELHIGHTLIGHTBGC = STATIC_SHEET_CANCELNORMALC;
    STATIC_SHEET_TITLEFONT = [UIFont boldSystemFontOfSize:18];
    STATIC_SHEET_CONTEXTFONT = [UIFont systemFontOfSize:14];
    STATIC_SHEET_CANCELFONT = STATIC_SHEET_CONTEXTFONT;
    STATIC_CONTENT_BACKGROUNDCLOLOR = [UIColor colorWithRed:0 green:0 blue:0 alpha:.3];
    STATIC_DIALOG_BACKGROUNDCLOLOR = [UIColor whiteColor];
    STATIC_DIALOG_BORDERCLOLOR = [UIColor lightGrayColor];
    STATIC_DIALOG_TEXTCLOLOR = [UIColor darkGrayColor];
    STATIC_DIALOG_TITLEFONT = [UIFont systemFontOfSize:18];
    STATIC_DIALOG_MESSAGEFONT = [UIFont italicSystemFontOfSize:14];
    STATIC_DIALOG_BUTTONFONT = [UIFont boldSystemFontOfSize:18];
    
    STATIC_TOPBAR_MESSAGEC = [UIColor orangeColor];
    STATIC_TOPBAR_BGC = kRGBA(60, 65, 70, 250);
    STATIC_TOPBAR_MESSAGEFONT = [UIFont systemFontOfSize:14];
}

+(void) setView:(UIView *) view shadowOffset:(CGSize) size{
    view.layer.shadowRadius = 3;
    view.layer.shadowOpacity = 1 ;
    view.layer.shadowColor = STATIC_DIALOG_BORDERCLOLOR.CGColor;
    view.layer.shadowOffset = size;
    view.clipsToBounds = NO;
}

@end
