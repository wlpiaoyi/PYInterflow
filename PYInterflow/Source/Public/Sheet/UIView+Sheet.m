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

-(void) setSheetSelectedIndexs:(NSArray<NSNumber *>*)sheetIndexs{
    ((PYSheetSelectorView *)[self sheetParam].sheetSelectorView).selectes = sheetIndexs;
}
-(NSArray<NSNumber *>*) sheetSelectedIndexs{
    return [self sheetParam].sheetSelectorView.selectes;
}

-(void) setBlockSelecting:(BOOL (^)(BOOL, NSUInteger))blockSelecting{
    [self sheetParam].blockSelecting = blockSelecting;
}
-(BOOL (^)(BOOL, NSUInteger))blockSelecting{
    return [self sheetParam].blockSelecting;
}

-(void) setSheetTitle:(NSString *)sheetTitle{
    [self sheetParam].attributeTitle = [NSString isEnabled:sheetTitle] ? [PYSheetParam parseTitleName:sheetTitle] : nil;
}
-(NSString *)sheetTitle{
    return [self sheetParam].attributeTitle.string;
}

-(void) setSheetConfirme:(NSString *)sheetConfirme{
    [self sheetParam].attributeConfirme =  (sheetConfirme && sheetConfirme.length > 0) ? [PYSheetParam parseConfirmName:sheetConfirme] : nil;;
}
-(NSString *)sheetConfirme{
    return [self sheetParam].attributeConfirme.string;
}

-(void) setSheetCancel:(NSString *)sheetCancel{
    [self sheetParam].attributeCancel=  (sheetCancel && sheetCancel.length > 0) ? [PYSheetParam parseCancelName:sheetCancel] : nil;;
}
-(NSString *)sheetCancel{
    return [self sheetParam].attributeCancel.string;
}

-(void) setSheetBlockSelecting:(BOOL (^)(BOOL, NSUInteger))sheetBlockSelecting{
    [self sheetParam].blockSelecting = sheetBlockSelecting;
}
-(BOOL (^)(BOOL, NSUInteger))sheetBlockSelecting{
    return [self sheetParam].blockSelecting;
}

-(void) setSheetBlcokOpt:(PYBlockPopupV_P_V_B)sheetBlcokOpt{
    [self sheetParam].blockOpt = sheetBlcokOpt;
}
-(PYBlockPopupV_P_V_B)sheetBlcokOpt{
    return [self sheetParam].blockOpt;
}


-(void) sheetShowWithTitle:(nullable NSString *) title
              previousName:(nullable NSString *) previousName
              nextName:(nullable NSString *) nextName
              blockOpt:(nullable PYBlockPopupV_P_V_I) blcokOpt{
    NSAttributedString * attributeTitle = [PYSheetParam parseTitleName:title];
    NSAttributedString * attributePrevious = (previousName && previousName.length > 0) ? [PYSheetParam parseConfirmName:previousName] : nil;
    NSAttributedString * attributeNext = (nextName && nextName.length > 0) ? [PYSheetParam parseConfirmName:nextName] : nil;
    kAssign(self);
    [self sheetParam].sheetOptionView = [PYSheetOptionView instanceWithTitle:attributeTitle previousName:attributePrevious nextName:attributeNext blockOpt:^(NSUInteger index) {
        kStrong(self);
        if(blcokOpt) blcokOpt(self, index);
    }];
    [self sheetShow];
}
-(void) sheetShow{
    if([self sheetParam].subView == nil){
        [self sheetParam].subView = self;
    }
    [[self sheetParam].showView setBlockShowAnimation:(^(UIView * _Nonnull view, PYBlockPopupV_P_V _Nullable block){
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
    [[self sheetParam].showView setBlockHiddenAnimation:(^(UIView * _Nonnull view, PYBlockPopupV_P_V _Nullable block){
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

-(void)sheetShowWithItemstrings:(NSArray<NSString *> *)itemstrings{
    PYSheetSelectorView * sheetView = nil;

    NSMutableArray * attributeOptions = [NSMutableArray new];
    if([self sheetParam].attributeConfirme && [self sheetParam].attributeConfirme.length) [attributeOptions addObject:[self sheetParam].attributeConfirme];
    if([self sheetParam].attributeCancel && [self sheetParam].attributeCancel.length) [attributeOptions addObject:[self sheetParam].attributeCancel];
    NSMutableArray<NSAttributedString *> * attributeItems = [NSMutableArray new];
    for (NSString * string in itemstrings) {
        NSAttributedString *item = [PYSheetParam parseItemName:string];
        [attributeItems addObject:item];
    }
    sheetView = [PYSheetSelectorView instanceWithTitle:[self sheetParam].attributeTitle items:attributeItems selectes:self.sheetSelectedIndexs options:attributeOptions multipleSelected:([self sheetParam].attributeConfirme && [self sheetParam].attributeConfirme.length)];
    sheetView.frameWidth = boundsWidth();
    [sheetView synFrame];
    kAssign(self);
    sheetView.blockSelectedOptions = ^(PYSheetSelectorView * _Nonnull contextView, NSUInteger index) {
        kStrong(self);
        BOOL isConfirme = NO;
        if([self sheetParam].attributeConfirme && [self sheetParam].attributeConfirme.length){
            isConfirme = index == 0;
        }else{
            isConfirme = NO;
        }
        if([self sheetParam].blockOpt) [self sheetParam].blockOpt(self, isConfirme);
        [self sheetHidden];
    };
    sheetView.blockSelecting = [self sheetParam].blockSelecting;
    [self sheetParam].sheetSelectorView = sheetView;
    [self sheetShow];
}

-(void) sheetHidden{
    [[self sheetParam].showView popupHidden];
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

