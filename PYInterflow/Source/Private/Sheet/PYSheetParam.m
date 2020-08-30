//
//  PYSheetParam.m
//  PYInterflow
//
//  Created by wlpiaoyi on 2016/12/8.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "PYSheetParam.h"
#import "PYInterflowParams.h"
#import "pyutilea.h"
#import "UIView+Popup.h"
#import "PYMoveView.h"
@interface PYSheetTableView : UITableView
kPNANA NSArray<NSNumber *>* selectedIndexs;
kSOULDLAYOUTPForType(PYSheetTableView)
@end

@interface PYSheetParam()
@property (nonatomic, assign, nonnull) id  target;
@property (nonatomic, strong) NSLayoutConstraint * lcHeadViewHight;
@property (nonatomic, strong, nullable) NSMutableArray<NSLayoutConstraint *> * lcsSafe;
@property (nonatomic, strong, nullable) NSMutableArray<NSLayoutConstraint *> * lcsContext;
@end


@implementation PYSheetParam
-(nullable instancetype) init{
    if(self = [super init]){
        _showView = [UIView new];
        _safeOutBottomView = [UIView new];
        _safeOutRightView = [UIView new];
        _safeOutLeftView = [UIView new];
        self.isHiddenOnClick = true;
        self.showView.backgroundColor = [UIColor clearColor];
        self.safeOutBottomView.backgroundColor =
        self.safeOutRightView.backgroundColor =
        self.safeOutLeftView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void) mergeTargetView{
    [self clearTargetView];
    PYEdgeInsetsItem e = PYEdgeInsetsItemNull();
    if(self.sheetSelectorView){
        self.subView.frameHeight = self.sheetSelectorView.frameHeight;
        [self.subView addSubview:self.sheetSelectorView];
        [self.lcsContext addObjectsFromArray:[PYViewAutolayoutCenter persistConstraint:self.sheetSelectorView relationmargins:UIEdgeInsetsMake(0, 0, 0, 0) relationToItems:e].allValues];
        [self.showView addSubview:self.subView];
        self.showView.frameHeight = self.subView.frameHeight;
        [self.lcsContext addObjectsFromArray:[PYViewAutolayoutCenter persistConstraint:self.subView relationmargins:UIEdgeInsetsMake(0, 0, 0, 0) relationToItems:e].allValues];
    }else if(self.sheetOptionView){
        [self.sheetOptionView addSheetView:self.subView];
        [self.lcsContext addObjectsFromArray:[PYViewAutolayoutCenter persistConstraint:self.subView relationmargins:UIEdgeInsetsMake(0, 0, 0, 0) relationToItems:e].allValues];
        [self.showView addSubview:self.sheetOptionView];
        self.showView.frameHeight = self.sheetOptionView.frameHeight;
        [self.lcsContext addObjectsFromArray:[PYViewAutolayoutCenter persistConstraint:self.sheetOptionView relationmargins:UIEdgeInsetsMake(0, 0, 0, 0) relationToItems:e].allValues];
    }else{
        [self.showView addSubview:self.subView];
        self.showView.frameHeight = self.subView.frameHeight;
        [self.lcsContext addObjectsFromArray:[PYViewAutolayoutCenter persistConstraint:self.subView relationmargins:UIEdgeInsetsMake(0, 0, 0, 0) relationToItems:e].allValues];
    }
    
    
}
-(void) mergesafeOutBottomView{
    if(self.lcsSafe){
        self.lcsSafe = [NSMutableArray new];
    }else{
        for (NSLayoutConstraint * lc in self.lcsSafe) {
            [self.safeOutBottomView.superview removeConstraint:lc];
        }
        [self.lcsSafe removeAllObjects];
    }
    [self.safeOutBottomView removeFromSuperview];
    [self.safeOutRightView removeFromSuperview];
    [self.safeOutLeftView removeFromSuperview];
    [self.showView.superview addSubview:self.safeOutBottomView];
    [self.showView.superview addSubview:self.safeOutRightView];
    [self.showView.superview addSubview:self.safeOutLeftView];
    PYEdgeInsetsItem e = PYEdgeInsetsItemNull();
    e.top = (__bridge void * _Nullable)(self.showView);
    [self.lcsSafe addObjectsFromArray:[PYViewAutolayoutCenter persistConstraint:self.safeOutBottomView relationmargins:UIEdgeInsetsMake(0, 0, 0, 0) relationToItems:e].allValues];
    
    e = PYEdgeInsetsItemNull();
    e.right = (__bridge void * _Nullable)(self.showView);
    e.bottom  = (__bridge void * _Nullable)(self.safeOutBottomView);
    [self.lcsSafe addObjectsFromArray:[PYViewAutolayoutCenter persistConstraint:self.safeOutLeftView relationmargins:UIEdgeInsetsMake(DisableConstrainsValueMAX, 0, 0, 0) relationToItems:e].allValues];
    NSLayoutConstraint *equalsConstraint= [NSLayoutConstraint constraintWithItem:self.safeOutLeftView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.showView attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
    [self.safeOutLeftView.superview addConstraint:equalsConstraint];
    [self.lcsSafe addObject:equalsConstraint];
    
    e = PYEdgeInsetsItemNull();
    e.left = (__bridge void * _Nullable)(self.showView);
    e.bottom  = (__bridge void * _Nullable)(self.safeOutBottomView);
    [self.lcsSafe addObjectsFromArray:[PYViewAutolayoutCenter persistConstraint:self.safeOutRightView relationmargins:UIEdgeInsetsMake(DisableConstrainsValueMAX, 0, 0, 0) relationToItems:e].allValues];
    equalsConstraint= [NSLayoutConstraint constraintWithItem:self.safeOutRightView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.showView attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
    [self.safeOutRightView.superview addConstraint:equalsConstraint];
    [self.lcsSafe addObject:equalsConstraint];
}

-(void) clearTargetView{
    for (NSLayoutConstraint * lc in self.lcsContext) {
        [self.showView removeConstraint:lc];
        [self.subView removeConstraint:lc];
    }
    [self.lcsContext removeAllObjects];
    [self.subView removeFromSuperview];
    if(self.sheetSelectorView) [self.sheetSelectorView removeFromSuperview];
    if(self.sheetOptionView){
        [self.sheetOptionView removeSheetView];
        [self.sheetOptionView removeFromSuperview];
    }
}

+(nullable NSMutableAttributedString *) parseTitleName:(nullable NSString *) title{
    if(title == nil) return nil;
    NSMutableAttributedString *attTitle = [[NSMutableAttributedString alloc] initWithString:title];
    NSRange range = NSMakeRange(0, attTitle.length);
    [attTitle addAttribute:NSForegroundColorAttributeName value:STATIC_SHEET_TITLEC range:range];//颜色
    [attTitle addAttribute:NSFontAttributeName value:STATIC_SHEET_TITLEFONT range:range];
    return attTitle;
}
+(nullable NSMutableAttributedString*) parseItemName:(nullable NSString *) name{
    if(name == nil) return nil;
    NSMutableAttributedString *attTitle = [[NSMutableAttributedString alloc] initWithString:name];
    NSRange range = NSMakeRange(0, attTitle.length);
    [attTitle addAttribute:NSForegroundColorAttributeName value:STATIC_SHEET_ITEMC range:range];//颜色
    [attTitle addAttribute:NSFontAttributeName value:STATIC_SHEET_ITEMFONT range:range];
    return attTitle;
}
+(nullable NSMutableAttributedString*) parseConfirmName:(nullable NSString *) name{
    if(name == nil) return nil;
    NSMutableAttributedString *attTitle = [[NSMutableAttributedString alloc] initWithString:name];
    NSRange range = NSMakeRange(0, attTitle.length);
    [attTitle addAttribute:NSForegroundColorAttributeName value:STATIC_POPUP_BLUEC range:range];//颜色
    [attTitle addAttribute:NSFontAttributeName value:STATIC_SHEET_CONFIRMFONT range:range];
    return attTitle;
}
+(nullable NSMutableAttributedString*) parseCancelName:(nullable NSString *) name{
    if(name == nil) return nil;
    NSMutableAttributedString *attTitle = [[NSMutableAttributedString alloc] initWithString:name];
    NSRange range = NSMakeRange(0, attTitle.length);
    [attTitle addAttribute:NSForegroundColorAttributeName value:STATIC_POPUP_REDC range:range];//颜色
    [attTitle addAttribute:NSFontAttributeName value:STATIC_SHEET_CANCELFONT range:range];
    return attTitle;
}



@end


