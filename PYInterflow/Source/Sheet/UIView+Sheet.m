//
//  UIView+Sheet.m
//  PYInterflow
//
//  Created by wlpiaoyi on 2016/12/6.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "UIView+Sheet.h"
#import "PYParams.h"
#import "UIView+Remove.h"
#import "UIView+Popup.h"
#import "pyutilea.h"
#import "PYSheetParam.h"
#import <objc/runtime.h>

static const void *PYSheetPointer = &PYSheetPointer;

@implementation UIView(Sheet)
-(void) sheetShow{
    [self sheetShowWithTitle:nil buttonConfirme:nil buttonCancel:nil block:nil];
}
-(void) sheetShowWithTitle:(nullable NSString *) title
            buttonConfirme:(nullable NSString *) confirme
            buttonCancel:(nullable NSString *) canel
            block:(void (^)(UIView * _Nullable view, int index)) blcok{
    NSAttributedString * attitle = [PYSheetParam parseDialogTitle:title];
   NSAttributedString * confirmNormal = [PYSheetParam parseNormalButtonName:confirme];
   NSAttributedString * confirmHighlighted = [PYSheetParam parseHightlightedButtonName:confirme];
   NSAttributedString * cancelNormal = [PYSheetParam parseNormalButtonName:canel];;
   NSAttributedString * cancelHighlighted = [PYSheetParam parseHightlightedButtonName:canel];
    [self sheetShowWithAttributeTitle:attitle buttonNormalAttributeConfirme:confirmNormal buttonNormalAttributeCancel:cancelNormal buttonHighlightedAttributeConfirme:confirmHighlighted buttonHighlightedAttributeCancel:cancelHighlighted block:blcok];
}
-(void) sheetShowWithAttributeTitle:(nullable NSAttributedString *) attributeTitle
        buttonNormalAttributeConfirme:(nullable NSAttributedString *) normalConfirme
        buttonNormalAttributeCancel:(nullable NSAttributedString *) normalCanel
        buttonHighlightedAttributeConfirme:(nullable NSAttributedString *) highlightedconfirme
        buttonHighlightedAttributeCancel:(nullable NSAttributedString *) highlightedCanel
        block:(void (^)(UIView * _Nullable view, int index)) blcok{
    [self sheetParam].block = blcok;
    [[self sheetParam].showView setBlockShowAnimation:(^(UIView * _Nonnull view, BlockPopupEndAnmation _Nullable block){
        if(IOS8_OR_LATER){
            view.alpha = 0;
            view.transform = CGAffineTransformMakeTranslation(0, view.bounds.size.height);
            [UIView animateWithDuration:.5 animations:^{
                [view resetBoundPoint];
                view.alpha = 1;
            } completion:^(BOOL finished) {
                block(view);
            }];
        }else{
            view.alpha = 0;
            [UIView animateWithDuration:.5 animations:^{
                view.alpha = 1;
            } completion:^(BOOL finished) {
                block(view);
            }];
        }
    })];
    [[self sheetParam].showView setBlockHiddenAnimation:(^(UIView * _Nonnull view, BlockPopupEndAnmation _Nullable block){
        if(IOS8_OR_LATER){
            [view resetBoundPoint];
            [UIView animateWithDuration:.5 animations:^{
                view.transform = CGAffineTransformMakeTranslation(0, view.bounds.size.height);
                view.alpha = 0;
            } completion:^(BOOL finished) {
                block(view);
            }];
        }else{
            view.alpha = 1;
            [UIView animateWithDuration:.5 animations:^{
                view.alpha = 0;
            } completion:^(BOOL finished) {
                block(view);
            }];
        }
    })];
    [self sheetParam].title = attributeTitle;
    [self sheetParam].confirmNormal = normalConfirme;
    [self sheetParam].confirmHighlighted = highlightedconfirme;
    [self sheetParam].cancelNormal = normalCanel;
    [self sheetParam].cancelHighlighted = highlightedCanel;
    CGFloat headHeight =  [[self sheetParam] updateHeadView];
    [self sheetParam].showView.frameSize = CGSizeMake(DisableConstrainsValueMAX, headHeight + self.frameHeight);
    [self sheetParam].showView.borderEdgeInsets = UIEdgeInsetsMake(DisableConstrainsValueMAX, 0, 0, 0);
    [self sheetParam].showView.centerPoint = CGPointMake(DisableConstrainsValueMAX, DisableConstrainsValueMAX);
    [[self sheetParam] mergeTargetView];
    @unsafeify(self);
    [[self sheetParam].showView setBlockEnd:^(UIView * _Nullable view) {
        @strongify(self);
        [[self sheetParam] clearTargetView];
    }];
    [[self sheetParam].showView popupShow];
}
-(void) sheetHidden{
    if(!(IOS8_OR_LATER)){
        @unsafeify(self);
        [[self sheetParam].showView setBlockEnd:^(UIView * _Nullable view) {
            @strongify(self);
            [self removeParams];
        }];
    }
    [[self sheetParam].showView popupHidden];
}
-(void) onclickSheet:(UIButton *) button{
    if([self sheetParam].block){
        [self sheetParam].block(self, (int)button.tag);
    }
    [self sheetHidden];
}

-(PYSheetParam *) sheetParam{
    PYSheetParam * param = objc_getAssociatedObject(self, PYSheetPointer);
    if(param == nil){
        param = [[PYSheetParam alloc] initWithTarget:self action:@selector(onclickSheet:)];
        objc_setAssociatedObject(self, PYSheetPointer, param, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return param;
}

@end
