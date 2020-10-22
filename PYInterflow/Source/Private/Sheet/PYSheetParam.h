//
//  PYSheetParam.h
//  PYInterflow
//
//  Created by wlpiaoyi on 2016/12/8.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYUtile.h"
#import "PYSheetSelectorView.h"
#import "PYSheetOptionView.h"

@interface PYSheetParam : NSObject
kPNA BOOL isHiddenOnClick;
@property (nonatomic, strong, nullable)  NSArray<NSAttributedString *> * attributeItems;
@property (nonatomic, strong, nullable)  NSAttributedString * attributeTitle;
@property (nonatomic, strong, nullable)  NSAttributedString * attributeConfirme;
@property (nonatomic, strong, nullable)  NSAttributedString * attributeCancel;
@property (nonatomic, copy, nullable) void (^blockOpt)(UIView * _Nullable view, BOOL isConfirm);
@property (nonatomic, copy, nullable) BOOL (^blockSingleSelecting)(NSUInteger cureentIndex);
@property (nonatomic, copy, nullable) BOOL (^blockMutabelSelecting)(UIView * _Nonnull view,BOOL isSelected, NSUInteger cureentIndex);
@property (nonatomic, strong, nullable) PYSheetSelectorView * sheetSelectorView;
@property (nonatomic, strong, nullable) PYSheetOptionView * sheetOptionView;
@property (nonatomic, strong, nullable) UIView * subView;
@property (nonatomic, strong, nonnull, readonly) UIView * showView;
@property (nonatomic, strong, nonnull, readonly) UIView * safeOutBottomView;
@property (nonatomic, strong, nonnull, readonly) UIView * safeOutLeftView;
@property (nonatomic, strong, nonnull, readonly) UIView * safeOutRightView;
-(nullable instancetype) init;
-(void) mergesafeOutBottomView;
-(void) mergeTargetView;
-(void) clearTargetView;

+(nullable NSMutableAttributedString*) parseTitleName:(nullable NSString *) name;
+(nullable NSMutableAttributedString*) parseItemName:(nullable NSString *) name;
+(nullable NSMutableAttributedString*) parseConfirmName:(nullable NSString *) name;
+(nullable NSMutableAttributedString*) parseCancelName:(nullable NSString *) name;

@end
