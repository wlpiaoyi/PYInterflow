//
//  PYSheetParam.h
//  PYInterflow
//
//  Created by wlpiaoyi on 2016/12/8.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PYSheetItemDelegate:NSObject
-(nonnull instancetype) initWithTableView:(nonnull UITableView *) tableView itemAttributes:(nonnull NSArray<NSAttributedString *> *) itemAttributes blockSelected:(void(^_Nullable)(NSUInteger index)) blockSelected;
+(CGFloat) getCellHeight;
@end
@interface PYSheetParam : NSObject

@property (nonatomic, strong, nullable)  NSAttributedString * title;
@property (nonatomic, strong, nullable)  NSAttributedString * confirmNormal;
@property (nonatomic, strong, nullable)  NSAttributedString * cancelNormal;
@property (nonatomic, strong, nullable)  NSAttributedString * confirmHighlighted;
@property (nonatomic, strong, nullable)  NSAttributedString * cancelHighlighted;
@property (nonatomic, copy, nullable) void (^blockOpt)(UIView * _Nullable view, NSUInteger index);
@property (nonatomic, copy, nullable) void (^blockSelected)(UIView * _Nullable view, NSUInteger index);
@property (nonatomic, strong, nullable) UIView * headView;
@property (nonatomic, strong, nullable) UIView * showView;
@property (nonatomic, strong, nullable) PYSheetItemDelegate * itemDelegate;
@property (nonatomic, assign, nonnull) UIView * targetView;
@property (nonatomic, nonnull) SEL action;
-(nullable instancetype) initWithTarget:(nullable UIView *) target action:(nullable SEL) action;
-(CGFloat) updateHeadView;

-(void) mergeTargetView;
-(void) clearTargetView;

+(nullable NSMutableAttributedString *) parseDialogTitle:(nullable NSString *) title;
+(nullable NSMutableAttributedString*) parseNormalButtonName:(nullable NSString *) name;
+(nullable NSMutableAttributedString*) parseHightlightedButtonName:(nullable NSString *) name;
@end
