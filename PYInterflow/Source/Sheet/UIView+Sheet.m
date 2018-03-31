//
//  UIView+Sheet.m
//  PYInterflow
//
//  Created by wlpiaoyi on 2016/12/6.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "UIView+Sheet.h"
#import "PYParams.h"
#import "UIView+Popup.h"
#import "pyutilea.h"
#import "PYSheetParam.h"
#import <objc/runtime.h>


static const void *PYSheetPointer = &PYSheetPointer;

@implementation UIView(Sheet)
-(void) setSheetIsHiddenOnClick:(BOOL)sheetIsHiddenOnClick{
    [self sheetParam].isHiddenOnClick = sheetIsHiddenOnClick;
}
-(BOOL) sheetIsHiddenOnClick{
    return [self sheetParam].isHiddenOnClick;
}
-(void) sheetShow{
    [self sheetShowWithTitle:nil buttonConfirme:nil buttonCancel:nil blockOpt:nil];
}
-(void) sheetShowWithTitle:(nullable NSString *) title
                    buttonConfirme:(nullable NSString *) confirme
                    buttonCancel:(nullable NSString *) canel
                    blockOpt:(void (^ _Nullable)(UIView * _Nullable view, NSUInteger index)) blcokOpt{
    [self sheetShowWithTitle:title buttonConfirme:confirme buttonCancel:canel itemStrings:nil blockOpt:blcokOpt blockSelected:nil];
}

-(void) sheetShowWithTitle:(nullable NSString *) title
            buttonConfirme:(nullable NSString *) confirme
            buttonCancel:(nullable NSString *) canel
            itemStrings:(nullable NSArray<NSString *> *) itemStrings
            blockOpt:(void (^ _Nullable)(UIView * _Nullable view, NSUInteger index)) blcokOpt
            blockSelected:(void (^ _Nullable)(UIView * _Nullable view, NSUInteger index)) blcokSelected;{
    NSAttributedString * attitle = [PYSheetParam parseDialogTitle:title];
    NSAttributedString * confirmNormal = (confirme && confirme.length > 0) ? [PYSheetParam parseNormalButtonName:confirme] : nil;
    NSAttributedString * confirmHighlighted = (confirme && confirme.length > 0) ? [PYSheetParam parseHightlightedButtonName:confirme] : nil;
    NSAttributedString * cancelNormal = (canel && canel.length > 0) ? [PYSheetParam parseNormalButtonName:canel] : nil;
    NSAttributedString * cancelHighlighted = (canel && canel.length > 0) ? [PYSheetParam parseHightlightedButtonName:canel] : nil;
    NSMutableArray<NSAttributedString *> * itemAttributes = [NSMutableArray new];
    for (NSString * string in itemStrings) {
        NSMutableAttributedString *item = [[NSMutableAttributedString alloc] initWithString:string];
        NSRange range = NSMakeRange(0, item.length);
        NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [item addAttribute:NSForegroundColorAttributeName value:STATIC_DIALOG_TEXTCLOLOR range:range];//颜色
        [item addAttribute:NSFontAttributeName value:STATIC_DIALOG_MESSAGEFONT range:range];
        [item addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
        [itemAttributes addObject:item];
    }
    [self sheetShowWithAttributeTitle:attitle buttonNormalAttributeConfirme:confirmNormal buttonNormalAttributeCancel:cancelNormal buttonHighlightedAttributeConfirme:confirmHighlighted buttonHighlightedAttributeCancel:cancelHighlighted itemAttributes:itemAttributes blockOpt:blcokOpt blockSelected:blcokSelected];
}
-(void) sheetShowWithAttributeTitle:(nullable NSAttributedString *) attributeTitle
        buttonNormalAttributeConfirme:(nullable NSAttributedString *) normalConfirme
        buttonNormalAttributeCancel:(nullable NSAttributedString *) normalCanel
        buttonHighlightedAttributeConfirme:(nullable NSAttributedString *) highlightedconfirme
        buttonHighlightedAttributeCancel:(nullable NSAttributedString *) highlightedCanel
        itemAttributes:(nullable NSArray<NSAttributedString *> *) itemAttributes
        blockOpt:(void (^ _Nullable)(UIView * _Nullable view, NSUInteger index)) blcokOpt
        blockSelected:(void (^ _Nullable)(UIView * _Nullable view, NSUInteger index)) blcokSelected{
    [self sheetParam].blockOpt = blcokOpt;
    [self sheetParam].blockSelected = blcokSelected;
    [[self sheetParam].showView setBlockShowAnimation:(^(UIView * _Nonnull view, BlockPopupEndAnmation _Nullable block){
        if(IOS8_OR_LATER){
            view.alpha = 0;
            view.transform = CGAffineTransformMakeTranslation(0, view.bounds.size.height);
            [UIView animateWithDuration:.5 animations:^{
                [view resetAutoLayout];
                [view resetTransform];
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
            [view resetAutoLayout];
            [view resetTransform];
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
    [self sheetParam].showView.popupEdgeInsets = UIEdgeInsetsMake(DisableConstrainsValueMAX, 0, 0, 0);
    [self sheetParam].showView.popupCenterPoint = CGPointMake(DisableConstrainsValueMAX, DisableConstrainsValueMAX);
    [[self sheetParam] mergeTargetView];
    @unsafeify(self);
    [[self sheetParam].showView setPopupBlockEnd:^(UIView * _Nullable view) {
        @strongify(self);
        [[self sheetParam] clearTargetView];
    }];
    [self sheetParam].showView.popupBaseView = self.popupBaseView;
    if(itemAttributes && itemAttributes.count > 0){
        UITableView * tableView = [[UITableView alloc]init];
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        tableView.separatorColor = [UIColor lightGrayColor];
        [[self sheetParam].targetView addSubview:tableView];
        [self sheetParam].itemDelegate = [[PYSheetItemDelegate alloc] initWithTableView:tableView itemAttributes:itemAttributes blockSelected:^(NSUInteger index) {
            @strongify(self);
            if([self sheetParam].blockSelected) [self sheetParam].blockSelected(self, index);
            [self sheetHidden];
        }];
        PYEdgeInsetsItem e = PYEdgeInsetsItemNull();
        tableView.scrollEnabled = itemAttributes.count > 8;
        [PYViewAutolayoutCenter persistConstraint:tableView relationmargins:UIEdgeInsetsZero relationToItems:e];
        [self sheetParam].showView.frameSize = CGSizeMake(DisableConstrainsValueMAX, headHeight + MIN(8, itemAttributes.count) * [PYSheetItemDelegate getCellHeight]);
    }
    [[self sheetParam].showView popupShow];
    [[self sheetParam] mergesafeOutBottomView];
}
-(void) sheetHidden{
    if(!(IOS8_OR_LATER)){
        @unsafeify(self);
        [[self sheetParam].showView setPopupBlockEnd:^(UIView * _Nullable view) {
            @strongify(self);
            [self removeParam];
        }];
    }
    [[self sheetParam].showView popupHidden];
}
-(void) onclickSheet:(UIButton *) button{
    if([self sheetParam].blockOpt){
        [self sheetParam].blockOpt(self, (int)button.tag);
    }
    if([self sheetParam].isHiddenOnClick)[self sheetHidden];
}

-(PYSheetParam *) sheetParam{
    PYSheetParam * param = objc_getAssociatedObject(self, PYSheetPointer);
    if(param == nil){
        param = [[PYSheetParam alloc] initWithTarget:self action:@selector(onclickSheet:)];
        objc_setAssociatedObject(self, PYSheetPointer, param, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return param;
}
-(nonnull UIView *) sheetShowView{
    return [self sheetParam].showView;
}
@end

