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
@implementation PYInterflowDialogValue @end
@implementation PYInterflowSheetValue @end
@implementation PYInterflowTopbarValue @end

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
    xPYInterflowConfValue.base.animationTime = 10.0;
    xPYInterflowConfValue.base.animationTimeOffset = .05;
    xPYInterflowConfValue.base.floatEffectBlur = .014;
    xPYInterflowConfValue.base.maxCpuUsage = 1.5;
    
    xPYInterflowConfValue.popup = [PYInterflowPopupValue new];
    xPYInterflowConfValue.popup.borderWidth = 1.0/[UIScreen mainScreen].scale;
    xPYInterflowConfValue.popup.notifyEffcte = @"notifyEffcte";
    xPYInterflowConfValue.popup.notifyShow = @"notifyShow";
    xPYInterflowConfValue.popup.notifyHidden = @"notifyHidden";
    
    xPYInterflowConfValue.dialog = [PYInterflowDialogValue new];
    xPYInterflowConfValue.dialog.offsetLine = 5;
    xPYInterflowConfValue.dialog.offsetBorder = 18;
    xPYInterflowConfValue.dialog.minWidth = 260;
    xPYInterflowConfValue.dialog.maxWidth = 300;
    xPYInterflowConfValue.dialog.maxHeight = 400;
    xPYInterflowConfValue.dialog.width = 280;
    xPYInterflowConfValue.dialog.offsetWith = 2;
    xPYInterflowConfValue.dialog.buttonHeight = 44;
    xPYInterflowConfValue.dialog.fontTitle = [UIFont boldSystemFontOfSize:18];
    xPYInterflowConfValue.dialog.fontMessage = [UIFont italicSystemFontOfSize:15];
    xPYInterflowConfValue.dialog.fontButton = [UIFont boldSystemFontOfSize:18];
    xPYInterflowConfValue.dialog.fontCancel = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
    xPYInterflowConfValue.dialog.fontConfirm = [UIFont systemFontOfSize:18 weight:UIFontWeightRegular];
    
    xPYInterflowConfValue.sheet = [PYInterflowSheetValue new];
    xPYInterflowConfValue.sheet.fontTitle = [UIFont systemFontOfSize:14];
    xPYInterflowConfValue.sheet.fontItem = [UIFont systemFontOfSize:16];
    xPYInterflowConfValue.sheet.fontCancel = xPYInterflowConfValue.dialog.fontCancel;
    xPYInterflowConfValue.sheet.fontConfirm = xPYInterflowConfValue.dialog.fontConfirm;
    
    xPYInterflowConfValue.toast = [PYInterflowTopbarValue new];
    
    
    xPYInterflowConfValue.toast.fontMsg = [UIFont systemFontOfSize:14];
    xPYInterflowConfValue.toast.offsetWith = 15;
    
    [PYPopupParam RECIRCLE_REFRESH_EFFECT];
    if (@available(iOS 13.0, *)) {
        xPYInterflowConfValue.base.colorEffectTint = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if(UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark)
                return[UIColor colorWithHexNumber:0xAAAAAA33];
            else
                return [UIColor colorWithHexNumber:0x55555533];
        }];
        xPYInterflowConfValue.base.colorContentBg =[UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
               if(UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark)
                   return [UIColor colorWithHexNumber:0xBBBBBB22];
               else
                   return [UIColor colorWithHexNumber:0x44444422];
        }];
        xPYInterflowConfValue.popup.colorLine = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if(UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark)
                return[UIColor colorWithHexNumber:0xAAAAAAFF];
            else
                return [UIColor colorWithHexNumber:0x666666FF];
        }];
        xPYInterflowConfValue.popup.colorHighlightBg = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if(UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark)
                return[UIColor colorWithHexNumber:0x44445599];
            else
                return [UIColor colorWithHexNumber:0xAAAABB99];
        }];
        xPYInterflowConfValue.popup.colorHighlightTxt = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if(UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark)
                return[UIColor colorWithHexNumber:0xDDDDDD55];
            else
                return [UIColor colorWithHexNumber:0x33333355];
        }];
        xPYInterflowConfValue.dialog.colorBg = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if(UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark)
                return[UIColor colorWithHexNumber:0x1E1E1E99];
            else
                return[UIColor colorWithHexNumber:0xFFFFFF99];
        }];
        xPYInterflowConfValue.dialog.colorMessage = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if(UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark)
                return[UIColor colorWithHexNumber:0xDDDDDDFF];
            else
                return [UIColor colorWithHexNumber:0x333333FF];
        }];
        xPYInterflowConfValue.dialog.colorCancel = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if(UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark)
                return[UIColor colorWithHexNumber:0xF73C3Cff];
            else
                return [UIColor colorWithHexNumber:0xca0814ff];
        }];
        xPYInterflowConfValue.dialog.colorConfirme = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if(UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark)
                return[UIColor colorWithHexNumber:0x2EA1FCff];
            else
                return [UIColor colorWithHexNumber:0x157efaff];
        }];
        xPYInterflowConfValue.sheet.colorItemSelected = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if(UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark)
                return[UIColor colorWithHexNumber:0x33334499];
            else
                return [UIColor colorWithHexNumber:0xEEEEFF99];
        }];
        xPYInterflowConfValue.sheet.colorTitle = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if(UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark)
                return[UIColor lightGrayColor];
            else
                return [UIColor grayColor];
        }];
        xPYInterflowConfValue.sheet.colorTitle = [UIColor systemGrayColor];
        xPYInterflowConfValue.toast.colorBg = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if(UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark)
                return[UIColor colorWithHexNumber:0xFFFFFF99];
            else
                return [UIColor colorWithHexNumber:0x00000099];
        }];
        xPYInterflowConfValue.toast.colorMsg = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if(UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark)
                return [UIColor colorWithHexNumber:0x000000BB];
            else
                return[UIColor colorWithHexNumber:0xFFFFFFFF];
        }];
        
    } else {
        xPYInterflowConfValue.base.colorEffectTint = [UIColor colorWithHexNumber:0x55555533];
        xPYInterflowConfValue.base.colorContentBg = [UIColor colorWithRed:0 green:0 blue:0 alpha:.3];
        xPYInterflowConfValue.popup.colorLine =  [UIColor colorWithHexNumber:0x666666FF];
        xPYInterflowConfValue.popup.colorHighlightTxt = [UIColor colorWithHexNumber:0x33333355];
        xPYInterflowConfValue.popup.colorHighlightBg = [UIColor colorWithHexNumber:0xAAAABB99];
        xPYInterflowConfValue.dialog.colorMessage = [UIColor darkGrayColor];
        xPYInterflowConfValue.dialog.colorBg = [UIColor colorWithHexNumber:0xFFFFFF99];
        xPYInterflowConfValue.dialog.colorCancel = [UIColor colorWithHexNumber:0xca0814ff];
        xPYInterflowConfValue.dialog.colorConfirme = [UIColor colorWithHexNumber:0x157efaff];
        xPYInterflowConfValue.sheet.colorTitle = [UIColor grayColor];
        xPYInterflowConfValue.sheet.colorItemSelected = [UIColor colorWithHexNumber:0xEEEEFF99];
        xPYInterflowConfValue.toast.colorBg = [UIColor colorWithHexNumber:0x00000099];
        xPYInterflowConfValue.toast.colorMsg = [UIColor colorWithHexNumber:0xFFFFFFFF];
    }

    xPYInterflowConfValue.dialog.colorTitle = xPYInterflowConfValue.dialog.colorMessage;
    xPYInterflowConfValue.sheet.colorConfirme = xPYInterflowConfValue.dialog.colorConfirme;
    xPYInterflowConfValue.sheet.colorCancel = xPYInterflowConfValue.dialog.colorCancel;
    xPYInterflowConfValue.sheet.colorBg = xPYInterflowConfValue.dialog.colorBg;
    xPYInterflowConfValue.sheet.colorItem = xPYInterflowConfValue.dialog.colorConfirme;
    UIImage * image = [UIImage imageWithSize:CGSizeMake([UIScreen mainScreen].scale, [UIScreen mainScreen].scale) blockDraw:^(CGContextRef  _Nonnull context, CGRect rect) {
        UIColor * color = [UIColor colorWithHexNumber:0x8888AA88];
        [PYGraphicsDraw drawLineWithContext:context startPoint:CGPointMake(0, [UIScreen mainScreen].scale) endPoint:CGPointMake(rect.size.width, [UIScreen mainScreen].scale) strokeColor:color.CGColor strokeWidth:1 lengthPointer:nil length:0];
    }];
    image = [image setImageSize:CGSizeMake(1, 1) scale:[UIScreen mainScreen].scale];
    xPYInterflowConfValue.sheet.imageLine = image;
}


@end
