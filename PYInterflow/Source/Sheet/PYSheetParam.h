//
//  PYSheetParam.h
//  PYInterflow
//
//  Created by wlpiaoyi on 2016/12/8.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYUtile.h"

@interface PYSheetItemDelegate:NSObject
kPNCNA NSArray<NSNumber *>* selectedIndexs;
kPNRNN UITableView * tableView;
-(instancetype) initWithAllowsMultipleSelection:(BOOL) allowsMultipleSelection
                                itemAttributes:(NSArray<NSAttributedString *> *) itemAttributes
                                blockSelected:(void(^_Nullable)(NSArray<NSNumber *>* indexs)) blockSelected
                                blockSelecting:(BOOL (^_Nullable)(NSMutableArray<NSNumber *> * _Nonnull  beforeIndexs, NSUInteger cureentIndex)) blockSelecting;
+(CGFloat) getCellHeight;
@end
@interface PYSheetParam : NSObject
kPNA BOOL isHiddenOnClick;
kPNCNA NSArray<NSNumber *>* sheetIndexs;
@property (nonatomic, strong, nullable)  NSAttributedString * title;
@property (nonatomic, strong, nullable)  NSAttributedString * confirmNormal;
@property (nonatomic, strong, nullable)  NSAttributedString * cancelNormal;
@property (nonatomic, strong, nullable)  NSAttributedString * confirmHighlighted;
@property (nonatomic, strong, nullable)  NSAttributedString * cancelHighlighted;
@property (nonatomic, copy, nullable) void (^blockOpt)(UIView * _Nullable view, NSUInteger index);
@property (nonatomic, copy, nullable) BOOL (^blockSelecteds)(UIView * _Nullable view);
@property (nonatomic, copy, nullable) BOOL (^blockSelecting)(NSMutableArray<NSNumber *> * _Nonnull  beforeIndexs, NSUInteger cureentIndex);
@property (nonatomic, strong, nullable) UIView * headView;
@property (nonatomic, strong, nullable) UIView * showView;
@property (nonatomic, strong, nullable) PYSheetItemDelegate * itemDelegate;
@property (nonatomic, assign, nonnull) UIView * targetView;
@property (nonatomic, strong, nonnull) UIView * safeOutBottomView;
@property (nonatomic, strong, nonnull) UIView * safeOutLeftView;
@property (nonatomic, strong, nonnull) UIView * safeOutRightView;
@property (nonatomic, nonnull) SEL action;
-(nullable instancetype) initWithTarget:(nullable UIView *) target action:(nullable SEL) action;
-(CGFloat) updateHeadView;
-(void) mergesafeOutBottomView;
-(void) mergeTargetView;
-(void) clearTargetView;

+(nullable NSMutableAttributedString *) parseDialogTitle:(nullable NSString *) title;
+(nullable NSMutableAttributedString*) parseNormalButtonName:(nullable NSString *) name;
+(nullable NSMutableAttributedString*) parseHightlightedButtonName:(nullable NSString *) name;
@end
