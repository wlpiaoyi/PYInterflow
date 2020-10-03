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

@implementation PYInterflowConfValue  @end
@implementation PYInterflowBaseValue @end
@implementation PYInterflowPopupValue @end

UIColor * _Nonnull STATIC_CONTENT_BACKGROUNDCLOLOR;
UIColor * _Nonnull STATIC_DIALOG_BACKGROUNDC;
UIColor * _Nonnull STATIC_DIALOG_TEXTCLOLOR;
UIFont * _Nonnull STATIC_DIALOG_TITLEFONT;
UIFont * _Nonnull STATIC_DIALOG_MESSAGEFONT;
UIFont * _Nonnull STATIC_DIALOG_BUTTONFONT;

CGFloat STATIC_DIALOG_OFFSETLINE = 5;
CGFloat STATIC_DIALOG_OFFSETBORDER = 18;
CGFloat STATIC_DIALOG_MINWIDTH = 260;
CGFloat STATIC_DIALOG_MAXWIDTH = 300;
CGFloat STATIC_DIALOG_MAXHEIGHT = 400;
CGFloat STATIC_DIALOG_WIDTH = 280;
CGFloat STATIC_DIALOG_OFFSETWIDTH = 2;
CGFloat STATIC_DIALOG_BUTTON_HEIGHT = 44;


UIColor * _Nonnull STATIC_EFFECT_TINTC;
UIColor * _Nonnull STATIC_SHEET_BACKGROUNDH;
UIColor * _Nonnull STATIC_SHEET_BACKGROUNDC;
UIColor * _Nonnull STATIC_SHEET_TITLEC;
UIColor * _Nonnull STATIC_SHEET_ITEMC;
UIColor * _Nonnull STATIC_SHEET_ITEMSElECTEDC;
UIColor * _Nonnull STATIC_POPUP_REDC;
UIColor * _Nonnull STATIC_POPUP_BLUEC;

UIFont * _Nonnull STATIC_SHEET_TITLEFONT;
UIFont * _Nonnull STATIC_SHEET_ITEMFONT;
UIFont * _Nonnull STATIC_SHEET_CANCELFONT;
UIFont * _Nonnull STATIC_SHEET_CONFIRMFONT;
UIImage * _Nonnull STATIC_SHEET_IMAGE_LINE;

UIColor * _Nonnull STATIC_TOPBAR_MESSAGEC;
UIColor * _Nonnull STATIC_TOPBAR_BGC;
UIFont * _Nonnull STATIC_TOPBAR_MESSAGEFONT;
NSBundle * _Nonnull STATIC_INTERFLOW_BUNDEL;

PYInterflowConfValue  * xPYInterflowConfValue;
@implementation PYInterflowParams

+(void) loadInterflowParamsData{
    if([kAppBundleIdentifier isEqual:@"wlpiaoyi.PYInterflow"])
        STATIC_INTERFLOW_BUNDEL =  [NSBundle mainBundle];
    else
        STATIC_INTERFLOW_BUNDEL =  [NSBundle bundleWithPath:kFORMAT(@"%@/PYInterflow.bundle", bundleDir)];
    [self loadInterflowParamsData:STATIC_INTERFLOW_BUNDEL];

}
+(void) loadInterflowParamsData:(nonnull NSBundle *) bundlePath{
    STATIC_INTERFLOW_BUNDEL =  bundlePath;
    xPYInterflowConfValue = [PYInterflowConfValue new];
    
    xPYInterflowConfValue.base = [PYInterflowBaseValue new];
    xPYInterflowConfValue.base.cpuUseage = .05;
    xPYInterflowConfValue.base.animationTime = 10.0;
    xPYInterflowConfValue.base.animationTimeOffset = .05;
    xPYInterflowConfValue.base.floatEffectBlur = .15;
    
    xPYInterflowConfValue.popup = [PYInterflowPopupValue new];
    xPYInterflowConfValue.popup.borderWidth = 1.0/[UIScreen mainScreen].scale;
    xPYInterflowConfValue.popup.notifyEffcte = @"notifyEffcte";
    xPYInterflowConfValue.popup.notifyShow = @"notifyShow";
    xPYInterflowConfValue.popup.notifyHidden = @"notifyHidden";
    
    
    kDISPATCH_ONCE_BLOCK(^{
        STATIC_SHEET_TITLEFONT = [UIFont systemFontOfSize:14];
        STATIC_SHEET_ITEMFONT = [UIFont systemFontOfSize:16];
        STATIC_SHEET_CANCELFONT = [UIFont boldSystemFontOfSize:16];
        STATIC_SHEET_CONFIRMFONT = STATIC_SHEET_ITEMFONT;
        
        STATIC_DIALOG_TITLEFONT = [UIFont boldSystemFontOfSize:18];
        STATIC_DIALOG_MESSAGEFONT = [UIFont italicSystemFontOfSize:15];
        STATIC_DIALOG_BUTTONFONT = [UIFont boldSystemFontOfSize:18];
        
        STATIC_TOPBAR_MESSAGEFONT = [UIFont systemFontOfSize:14];
        
        [PYPopupParam RECIRCLE_REFRESH_EFFECT];
    });
    
    if (@available(iOS 13.0, *)) {
        STATIC_DIALOG_BACKGROUNDC = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if(UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark)
                return[UIColor colorWithHexNumber:0x1E1E1EFF];
            else
                return [UIColor whiteColor];
        }];
        STATIC_SHEET_ITEMSElECTEDC = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if(UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark)
                return[UIColor colorWithHexNumber:0x333322FF];
            else
                return [UIColor colorWithHexNumber:0xEEEEFFFF];
        }];
        STATIC_TOPBAR_MESSAGEC = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if(UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark)
                return[UIColor colorWithHexNumber:0xFFFFFFAA];
            else
                return [UIColor colorWithHexNumber:0x000000AA];
        }];
        STATIC_SHEET_TITLEC = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if(UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark)
                return[UIColor lightGrayColor];
            else
                return [UIColor grayColor];
        }];
        STATIC_DIALOG_TEXTCLOLOR = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if(UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark)
                return[UIColor lightGrayColor];
            else
                return [UIColor darkGrayColor];
        }];
        STATIC_POPUP_REDC = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if(UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark)
                return[UIColor colorWithHexNumber:0xF73C3Cff];
            else
                return [UIColor colorWithHexNumber:0xca0814ff];
        }];
        STATIC_POPUP_BLUEC = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if(UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark)
                return[UIColor colorWithHexNumber:0x2EA1FCff];
            else
                return [UIColor colorWithHexNumber:0x157efaff];
        }];
        STATIC_EFFECT_TINTC = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if(UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark)
                return[UIColor colorWithHexNumber:0xAAAAAA33];
            else
                return [UIColor colorWithHexNumber:0x55555533];
        }];
        STATIC_CONTENT_BACKGROUNDCLOLOR = [UIColor colorWithRed:0 green:0 blue:0 alpha:.3];
        STATIC_SHEET_TITLEC = [UIColor systemGrayColor];
        
    } else {
        STATIC_EFFECT_TINTC = [UIColor colorWithHexNumber:0x55555533];
        STATIC_CONTENT_BACKGROUNDCLOLOR = [UIColor colorWithRed:0 green:0 blue:0 alpha:.3];
        STATIC_DIALOG_TEXTCLOLOR = [UIColor darkGrayColor];
        STATIC_TOPBAR_MESSAGEC = [UIColor colorWithHexNumber:0x000000AA];
        STATIC_SHEET_ITEMSElECTEDC = [UIColor colorWithHexNumber:0xEEEEFFFF];
        STATIC_POPUP_REDC = [UIColor colorWithHexNumber:0xca0814ff];
        STATIC_POPUP_BLUEC = [UIColor colorWithHexNumber:0x157efaff];
        STATIC_DIALOG_BACKGROUNDC = [UIColor whiteColor];
        STATIC_SHEET_TITLEC = [UIColor grayColor];
    }
    
    xPYInterflowConfValue.popup.colorHighlightBg = [UIColor colorWithHexNumber:0x8888AAAA];
    xPYInterflowConfValue.popup.colorHighlightTxt = [UIColor colorWithHexNumber:0xDDDDDDFF];
    
    STATIC_TOPBAR_BGC = STATIC_DIALOG_BACKGROUNDC;
    STATIC_SHEET_BACKGROUNDC = STATIC_DIALOG_BACKGROUNDC;
    STATIC_SHEET_ITEMC = STATIC_POPUP_BLUEC;
    STATIC_SHEET_BACKGROUNDH =  xPYInterflowConfValue.popup.colorHighlightBg;
    
     UIImage * image = [UIImage imageWithSize:CGSizeMake([UIScreen mainScreen].scale, [UIScreen mainScreen].scale) blockDraw:^(CGContextRef  _Nonnull context, CGRect rect) {
          [PYGraphicsDraw drawLineWithContext:context startPoint:CGPointMake(0, [UIScreen mainScreen].scale) endPoint:CGPointMake(rect.size.width, [UIScreen mainScreen].scale) strokeColor:xPYInterflowConfValue.popup.colorHighlightBg.CGColor strokeWidth:1 lengthPointer:nil length:0];
    }];
    image = [image setImageSize:CGSizeMake(1, 1) scale:[UIScreen mainScreen].scale];
    STATIC_SHEET_IMAGE_LINE = image;
}


@end
