//
//  PYSheetParam.h
//  PYInterflow
//
//  Created by wlpiaoyi on 2016/12/8.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYUtile.h"
#import "PYSheetContextView.h"

@interface PYSheetParam : NSObject
kPNA BOOL isHiddenOnClick;
@property (nonatomic, strong, nullable)  NSArray<NSAttributedString *> * attributeItems;
@property (nonatomic, strong, nullable)  NSAttributedString * attributeTitle;
@property (nonatomic, strong, nullable)  NSAttributedString * attributeConfirme;
@property (nonatomic, strong, nullable)  NSAttributedString * attributeCancel;
@property (nonatomic, copy, nullable) void (^blockOpt)(UIView * _Nullable view, NSUInteger index);
@property (nonatomic, copy, nullable) BOOL (^blockSelecteds)(UIView * _Nullable view);
@property (nonatomic, copy, nullable) BOOL (^blockSelecting)(NSMutableArray<NSNumber *> * _Nonnull  beforeIndexs, NSUInteger cureentIndex);
@property (nonatomic, strong, nullable) PYSheetContextView * sheetView;
@property (nonatomic, strong, nullable) UIView * showView;
@property (nonatomic, assign, nonnull) UIView * targetView;
@property (nonatomic, strong, nonnull) UIView * safeOutBottomView;
@property (nonatomic, strong, nonnull) UIView * safeOutLeftView;
@property (nonatomic, strong, nonnull) UIView * safeOutRightView;
@property (nonatomic, nonnull) SEL action;
-(nullable instancetype) initWithTarget:(nullable UIView *) target action:(nullable SEL) action;
-(void) mergesafeOutBottomView;
-(void) mergeTargetView;
-(void) clearTargetView;

+(nullable NSMutableAttributedString*) parseTitleName:(nullable NSString *) name;
+(nullable NSMutableAttributedString*) parseItemName:(nullable NSString *) name;
+(nullable NSMutableAttributedString*) parseConfirmName:(nullable NSString *) name;
+(nullable NSMutableAttributedString*) parseCancelName:(nullable NSString *) name;

@end
