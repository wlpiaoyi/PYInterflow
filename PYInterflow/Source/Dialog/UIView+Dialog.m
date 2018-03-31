//
//  UIView+Dialog.m
//  PYInterchange
//
//  Created by wlpiaoyi on 16/1/21.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "UIView+Dialog.h"
#import "UIView+Popup.h"
#import "pyutilea.h"
#import <objc/runtime.h>
#import "PYDialogParam.h"

static const void *PYDialogPointer = &PYDialogPointer;

@implementation UIView(Dialog)
-(UIView *) dialogShowView{
    return [self paramDialog].showView;
}
-(void) setDialogUserInfo:(id)dialogUserInfo{
    [self paramDialog].userInfo = dialogUserInfo;
}
-(id) dialogUserInfo{
    return [self paramDialog].userInfo;
}
-(void) setBlockDialogOpt:(BlockDialogOpt) block{
    [self paramDialog].blockDialogOpt = block;
}
-(BlockDialogOpt) blockDialogOpt{
    return [self paramDialog].blockDialogOpt;
}
-(void) dialogShowWithTitle:(nullable NSString *) title message:(nullable NSString *) message block:(nullable BlockDialogOpt) block buttonNames:(nonnull NSArray<NSString*>*)buttonNames{
    [self paramDialog].attributeTitle = [PYDialogParam parseDialogTitle:title];
    [self paramDialog].attributeMessage = [PYDialogParam parseDialogMessage:message];
    [self paramDialog].normalButtonNames = [PYDialogParam parseNormalButtonNames:buttonNames hasStyle:BlockDialogButtonStyle == nil];
    [self paramDialog].hightLightedButtonNames = [PYDialogParam parseHihtLightedButtonName:buttonNames hasStyle:BlockDialogButtonStyle == nil];
    [self dialogShowWithAttributeTitle:[self paramDialog].attributeTitle attributeMessage:[self paramDialog].attributeMessage block:block buttonNormalNames:[self paramDialog].normalButtonNames buttonHightLightNames:[self paramDialog].hightLightedButtonNames];
}
-(void) dialogShowWithAttributeTitle:(nullable NSAttributedString *) attributeTitle attributeMessage:(nullable NSAttributedString *) attributeMessage block:(nullable BlockDialogOpt) block buttonNormalNames:(nonnull NSArray<NSAttributedString*>*)buttonNormalNames buttonHightLightNames:(nonnull NSArray<NSAttributedString*>*)buttonHightLightNames{
    [self paramDialog].attributeTitle = attributeTitle;
    [self paramDialog].attributeMessage = attributeMessage;
    [self paramDialog].normalButtonNames = buttonNormalNames;
    [self paramDialog].hightLightedButtonNames = buttonHightLightNames;
    [self setBlockDialogOpt:block];
    CGSize titleSize = [[self paramDialog] updateTitleView];
    CGSize buttonSize = [[self paramDialog] updateButtonView];
    CGSize dialogSize = [[self paramDialog] updateMessageView];
    [[self paramDialog] mergeTargetView];
    [self paramDialog].showView.frameSize = CGSizeMake(MAX(MAX(titleSize.width, dialogSize.width), buttonSize.width) ,  titleSize.height + dialogSize.height + buttonSize.height);
    [self.superview sendSubviewToBack:self];
    @unsafeify(self);
    [[self paramDialog].showView setPopupBlockEnd:^(UIView * _Nullable view) {
        @strongify(self);
        [[self paramDialog] clearTargetView];
    }];
//    [self paramDialog].showView.moveable = IOS8_OR_LATER;
    [[self paramDialog].showView setBlockTouchEnded:(^(CGPoint p, UIView  * _Nonnull touchView){
        [UIView beginAnimations:nil context:nil]; // 开始动画
        [UIView setAnimationDuration:.5]; // 动画时长
        touchView.transform =
        touchView.transform = CGAffineTransformIdentity;//CGAffineTransformTranslate(touchView.transform, -p.x, -p.y);
        [UIView commitAnimations];
    })];
    [self paramDialog].showView.popupBaseView = self.popupBaseView;
    [[self paramDialog].showView popupShow];
}

-(void) dialogShowWithTitle:(nullable NSString *) title block:(nullable BlockDialogOpt) block buttonNames:(nonnull NSArray<NSString*>*)buttonNames{
    [self paramDialog].attributeTitle = [PYDialogParam parseDialogTitle:title];
    [self paramDialog].normalButtonNames = [PYDialogParam parseNormalButtonNames:buttonNames hasStyle:BlockDialogButtonStyle == nil];
    [self paramDialog].hightLightedButtonNames = [PYDialogParam parseHihtLightedButtonName:buttonNames hasStyle:BlockDialogButtonStyle == nil];
    [self dialogShowWithAttributeTitle:[self paramDialog].attributeTitle block:block buttonNormalNames:[self paramDialog].normalButtonNames buttonHightLightNames:[self paramDialog].hightLightedButtonNames];
}
-(void) dialogShowWithAttributeTitle:(nullable NSAttributedString *) attributeTitle block:(nullable BlockDialogOpt) block buttonNormalNames:(nonnull NSArray<NSAttributedString*>*)buttonNormalNames buttonHightLightNames:(nonnull NSArray<NSAttributedString*>*)buttonHightLightNames{
    [self paramDialog].attributeTitle = attributeTitle;
    [self paramDialog].normalButtonNames = buttonNormalNames;
    [self paramDialog].hightLightedButtonNames = buttonHightLightNames;
    [self setBlockDialogOpt:block];
    CGSize titleSize = [[self paramDialog] updateTitleView];
    CGSize buttonSize = [[self paramDialog] updateButtonView];
    CGSize dialogSize = self.frameSize;
    [[self paramDialog] mergeTargetView];
    [self paramDialog].showView.frameSize = CGSizeMake(MAX(MAX(titleSize.width, dialogSize.width), buttonSize.width) ,  titleSize.height + dialogSize.height + buttonSize.height);
    [self paramDialog].showView.popupEdgeInsets = UIEdgeInsetsMake(DisableConstrainsValueMAX, DisableConstrainsValueMAX, DisableConstrainsValueMAX, DisableConstrainsValueMAX);
    [self paramDialog].showView.popupCenterPoint = CGPointMake(0, 0);
    [self.superview sendSubviewToBack:self];
    [[self paramDialog].showView setPopupBlockEnd:^(UIView * _Nullable view) {
        [[view paramDialog] clearTargetView];
    }];
    [[self paramDialog].showView setBlockTouchEnded:(^(CGPoint p, UIView  * _Nonnull touchView){
        [UIView beginAnimations:nil context:nil]; // 开始动画
        [UIView setAnimationDuration:.5]; // 动画时长
        touchView.transform = CGAffineTransformTranslate(touchView.transform, -p.x, -p.y);
        [UIView commitAnimations];
    })];
    [self paramDialog].showView.popupBaseView = self.popupBaseView;
    [[self paramDialog].showView popupShow];
}

-(void) dialogHidden{
    if(!(IOS8_OR_LATER)){
        @unsafeify(self);
        [[self paramDialog].showView setPopupBlockEnd:^(UIView * _Nullable view) {
            @strongify(self);
            [self removeParam];
        }];
    }
    [[self paramDialog].showView popupHidden];
}

-(void) diloagOnclick:(UIButton*) sender{
    BlockDialogOpt block = [self blockDialogOpt];
    if (block) {
        block(self,sender.tag);
    }
}
-(PYDialogParam *) paramDialog{
    PYDialogParam * param = objc_getAssociatedObject(self, PYDialogPointer);
    if(param == nil){
        param = [[PYDialogParam alloc] initWithTarget:self action:@selector(diloagOnclick:)];
        objc_setAssociatedObject(self, PYDialogPointer, param, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return param;
}
@end


