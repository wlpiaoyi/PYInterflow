//
//  UIView+Sheet.m
//  PYInterflow
//
//  Created by wlpiaoyi on 2016/12/6.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "UIView+Sheet.h"
#import "PYInterflowParams.h"
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
-(void) setSheetIndexs:(NSArray<NSNumber *>*)sheetIndexs{
    ((PYSheetSelectorView *)[self sheetParam].sheetSelectorView).selectes = sheetIndexs;
}
-(NSArray<NSNumber *>*) sheetIndexs{
    return [self sheetParam].sheetSelectorView.selectes;
}

-(void) sheetShowWithTitle:(nullable NSString *) title
              previousName:(nullable NSString *) previousName
              nextName:(nullable NSString *) nextName
              blockOpt:(void (^ _Nullable)(UIView * _Nullable view, NSUInteger index)) blcokOpt{
    NSAttributedString * attributeTitle = [PYSheetParam parseTitleName:title];
    NSAttributedString * attributePrevious = (previousName && previousName.length > 0) ? [PYSheetParam parseConfirmName:previousName] : nil;
    NSAttributedString * attributeNext = (nextName && nextName.length > 0) ? [PYSheetParam parseConfirmName:nextName] : nil;
    kAssign(self);
    [self sheetParam].sheetOptionView = [PYSheetOptionView instanceWithTitle:attributeTitle previousName:attributePrevious nextName:attributeNext blockOpt:^(NSUInteger index) {
        kStrong(self);
        if([self sheetParam].blockOpt) [self sheetParam].blockOpt(self, index);
        NSLog(@"");
    }];
    [self sheetParam].blockOpt = blcokOpt;
    [self sheetShow];
}
-(void) sheetShow{
    if([self sheetParam].subView == nil){
        [self sheetParam].subView = self;
    }
    [[self sheetParam].showView setBlockShowAnimation:(^(UIView * _Nonnull view, BlockPopupEndAnmation _Nullable block){
        [view resetAutoLayout];
        [view resetTransform];
        view.transform = CGAffineTransformMakeTranslation(0, view.bounds.size.height);
        [UIView animateWithDuration:.5 animations:^{
            [view resetAutoLayout];
            [view resetTransform];
        } completion:^(BOOL finished) {
            block(view);
        }];
    })];
    kAssign(self);
    [[self sheetParam].showView setBlockHiddenAnimation:(^(UIView * _Nonnull view, BlockPopupEndAnmation _Nullable block){
        kStrong(self);
        [view resetAutoLayout];
        [view resetTransform];
        [view sheetParam].showView.popupBaseView.alpha = 1;
        [UIView animateWithDuration:.5 animations:^{
            view.transform = CGAffineTransformMakeTranslation(0, view.bounds.size.height);
        } completion:^(BOOL finished) {
            block(view);
            [self sheetParam].sheetSelectorView = nil;
            [self sheetParam].subView = nil;
        }];
    })];
    [self sheetParam].showView.frameSize = CGSizeMake(DisableConstrainsValueMAX, self.frameHeight);
    [self sheetParam].showView.popupEdgeInsets = UIEdgeInsetsMake(DisableConstrainsValueMAX, 0, 0, 0);
    [self sheetParam].showView.popupCenterPoint = CGPointMake(DisableConstrainsValueMAX, DisableConstrainsValueMAX);
    [[self sheetParam] mergeTargetView];
    [[self sheetParam].showView setPopupBlockEnd:^(UIView * _Nullable view) {
        kStrong(self);
        [[self sheetParam] clearTargetView];
    }];
    [self sheetParam].showView.popupBaseView = self.popupBaseView;
    [[self sheetParam].showView popupShow];
    [self sheetParam].showView.popupBlockTap = ^(UIView * _Nullable view) {
        kStrong(self);
        if(self.sheetIsHiddenOnClick){
            [self sheetHidden];
        }
    };
    [[self sheetParam] mergesafeOutBottomView];
}
-(void) sheetShowWithTitle:(nullable NSString *) title
            buttonConfirme:(nullable NSString *) confirme
            buttonCancel:(nullable NSString *) canel
            itemStrings:(nullable NSArray<NSString *> *) itemStrings
            blockOpt:(void (^ _Nullable)(UIView * _Nullable view, NSUInteger index)) blcokOpt
            blockSelected:(void (^ _Nullable)(UIView * _Nullable view,  NSUInteger index)) blcokSelected{
    NSAttributedString * attributeTitle = [PYSheetParam parseTitleName:title];
    NSAttributedString * attributeConfirme = (confirme && confirme.length > 0) ? [PYSheetParam parseConfirmName:confirme] : nil;
    NSAttributedString * attributeCancel = (canel && canel.length > 0) ? [PYSheetParam parseCancelName:canel] : nil;
    NSMutableArray<NSAttributedString *> * attributeItems = [NSMutableArray new];
    for (NSString * string in itemStrings) {
        NSAttributedString *item = [PYSheetParam parseItemName:string];
        [attributeItems addObject:item];
    }
    kAssign(self);
    [self sheetShowWithAttributeTitle:attributeTitle attributeItems:attributeItems attributeConfirme:attributeConfirme attributeCancel:attributeCancel mutipleSeleted:NO blockOpt:blcokOpt blockSelecteds:^BOOL(UIView * _Nullable view) {
        kStrong(self);
        if(blcokSelected)blcokSelected(view, self.sheetIndexs.firstObject.integerValue);
        return YES;
    }];
}

-(void) sheetShowWithTitle:(nullable NSString *) title
            buttonConfirme:(nullable NSString *) confirme
            buttonCancel:(nullable NSString *) canel
            itemStrings:(nullable NSArray<NSString *> *) itemStrings
            blockOpts:(void (^ _Nullable)(UIView * _Nullable view, NSUInteger index)) blcokOpts
            blockSelecteds:(BOOL (^ _Nullable)(UIView * _Nullable view)) blockSelecteds;{
    NSAttributedString * attributeTitle = [PYSheetParam parseTitleName:title];
    NSAttributedString * attributeConfirme = (confirme && confirme.length > 0) ? [PYSheetParam parseConfirmName:confirme] : nil;
    NSAttributedString * attributeCancel = (canel && canel.length > 0) ? [PYSheetParam parseCancelName:canel] : nil;
    NSMutableArray<NSAttributedString *> * attributeItems = [NSMutableArray new];
    for (NSString * string in itemStrings) {
        NSAttributedString *item = [PYSheetParam parseItemName:string];
        [attributeItems addObject:item];
    }
    [self sheetShowWithAttributeTitle:attributeTitle attributeItems:attributeItems attributeConfirme:attributeConfirme attributeCancel:attributeCancel mutipleSeleted:YES blockOpt:blcokOpts blockSelecteds:blockSelecteds];
}

-(void) setSheetBlockSelecting:(BOOL (^ _Nullable)(NSMutableArray<NSNumber *> * _Nonnull beforeIndexs, NSUInteger cureentIndex)) blockSelecting{
    [self sheetParam].blockSelecting = blockSelecting;
}
-(BOOL (^ _Nullable)(NSMutableArray<NSNumber *> * _Nonnull beforeIndexs, NSUInteger cureentIndex)) sheetBlockSelecting{
    return [self sheetParam].blockSelecting;
}

-(void) sheetShowWithAttributeTitle:(nullable NSAttributedString *) attributeTitle
                    attributeItems:(nullable NSArray<NSAttributedString *> *) attributeItems
                    attributeConfirme:(nullable NSAttributedString *) attributeConfirme
                    attributeCancel:(nullable NSAttributedString *) attributeCancel
                    mutipleSeleted:(BOOL) mutipleSeleted
                    blockOpt:(void (^ _Nullable)(UIView * _Nullable view, NSUInteger index)) blcokOpt
                    blockSelecteds:(BOOL (^ _Nullable)(UIView * _Nullable view)) blcokSelecteds{
    
    PYSheetSelectorView * sheetView = nil;
    if(attributeTitle || (attributeItems && attributeItems.count) || attributeConfirme || attributeCancel){
    
        [self sheetParam].blockOpt = blcokOpt;
        [self sheetParam].blockSelecteds = blcokSelecteds;
        [self sheetParam].attributeTitle = attributeTitle;
        [self sheetParam].attributeItems = attributeItems;
        [self sheetParam].attributeConfirme = attributeConfirme;
        [self sheetParam].attributeCancel = attributeCancel;
    
        NSMutableArray * attributeOptions = [NSMutableArray new];
        if(attributeConfirme && attributeConfirme.length) [attributeOptions addObject:attributeConfirme];
        if(attributeCancel && attributeCancel.length) [attributeOptions addObject:attributeCancel];
        sheetView = [PYSheetSelectorView instanceWithTitle:attributeTitle items:attributeItems selectes:@[] options:attributeOptions multipleSelected:mutipleSeleted];
        sheetView.frameWidth = boundsWidth();
        [sheetView synFrame];
        kAssign(self);
        sheetView.blockSelectedItems = ^BOOL(PYSheetSelectorView * _Nonnull contextView) {
            kStrong(self);
            BOOL flag = YES;
            if(blcokSelecteds) flag = blcokSelecteds(self);
            if(flag) [self sheetHidden];
            return flag;
        };
        sheetView.blockSelectedOptions = ^(PYSheetSelectorView * _Nonnull contextView, NSUInteger index) {
            kStrong(self);
            if(blcokOpt) blcokOpt(self, index);
            [self sheetHidden];
        };
        sheetView.blockOnSelecting = [self sheetParam].blockSelecting;
    }
    [self sheetParam].sheetSelectorView = sheetView;
    [self sheetShow];
}


-(void) sheetHidden{
    [[self sheetParam].showView popupHidden];
}
-(void) onclickSheet:(UIButton *) button{
    if([self sheetParam].blockOpt){
        [self sheetParam].blockOpt(self, (int)button.tag);
    }
}

-(PYSheetParam *) sheetParam{
    PYSheetParam * param = objc_getAssociatedObject(self, PYSheetPointer);
    if(param == nil){
        param = [[PYSheetParam alloc] init];
        objc_setAssociatedObject(self, PYSheetPointer, param, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return param;
}
-(nonnull UIView *) sheetShowView{
    return [self sheetParam].showView;
}
@end

