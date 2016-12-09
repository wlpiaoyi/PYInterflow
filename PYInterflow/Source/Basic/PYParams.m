//
//  PYParams.m
//  PYInterflow
//
//  Created by wlpiaoyi on 2016/12/7.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "PYParams.h"


CGFloat PYPopupAnimationTime = 10.0;
CGFloat PYPopupAnimationTimeOffset = .05;
CGFloat STATIC_POPUP_BORDERWIDTH = .5;
CGFloat STATIC_POPUP_WIDTH = 280;
CGFloat STATIC_POPUP_OFFSETWIDTH = 8;
CGFloat STATIC_POPUP_TITLE_HEIGHT = 38;
CGFloat STATIC_POPUP_BUTTON_HEIGHT = 38;

UIColor * _Nonnull STATIC_DIALOG_BACKGROUNDCLOLOR;
UIColor * _Nonnull STATIC_DIALOG_BORDERCLOLOR;
UIColor * _Nonnull STATIC_DIALOG_TEXTCLOLOR;
UIFont * _Nonnull STATIC_DIALOG_TITLEFONT;
UIFont * _Nonnull STATIC_DIALOG_MESSAGEFONT;
UIFont * _Nonnull STATIC_DIALOG_BUTTONFONT;
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

+(void) loadSheetParamsData{
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
}

+(void) loadDialogParamsData{
    STATIC_DIALOG_BACKGROUNDCLOLOR = [UIColor whiteColor];
    STATIC_DIALOG_BORDERCLOLOR = [UIColor lightGrayColor];
    STATIC_DIALOG_TEXTCLOLOR = [UIColor darkGrayColor];
    STATIC_DIALOG_TITLEFONT = [UIFont systemFontOfSize:18];
    STATIC_DIALOG_MESSAGEFONT = [UIFont italicSystemFontOfSize:14];
    STATIC_DIALOG_BUTTONFONT = [UIFont boldSystemFontOfSize:18];
}

+(void) loadTopbarParamsData{
    STATIC_TOPBAR_MESSAGEC = [UIColor orangeColor];
    STATIC_TOPBAR_BGC = [UIColor colorWithRed:.3 green:.3 blue:.3 alpha:.9];
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