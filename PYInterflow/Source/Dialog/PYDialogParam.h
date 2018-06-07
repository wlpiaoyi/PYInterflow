//
//  PYDialogParam.h
//  PYInterflow
//
//  Created by wlpiaoyi on 2016/12/7.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYParams.h"
#import "PYMoveView.h"

@interface PYDialogParam : NSObject
@property (nonatomic, retain, nullable) id userInfo;

@property (nonatomic, strong, nullable) NSAttributedString * attributeTitle;
@property (nonatomic, strong, nullable) NSAttributedString * attributeMessage;
@property (nonatomic, strong, nullable) NSArray<NSAttributedString *> * normalButtonNames;
@property (nonatomic, strong, nullable) NSArray<NSAttributedString *> * hightLightedButtonNames;

@property (nonatomic, strong, nullable) UIView * titleView;
@property (nonatomic, strong, nullable) UIView * messageView;
@property (nonatomic, strong, nullable) UIView * buttonView;
@property (nonatomic, strong, nullable) UIView * contextView;
@property (nonatomic, strong, nullable) PYMoveView * showView;

@property (nonatomic, strong, nullable) NSLayoutConstraint * lcTitleHeight;
@property (nonatomic, strong, nullable) NSLayoutConstraint * lcButtonHeight;

@property (nonatomic, copy, nullable) BlockDialogOpt blockDialogOpt;

-(nullable instancetype) initWithTarget:(nonnull id) target action:(nonnull SEL) action;

-(CGSize) updateTitleView;
-(CGSize) updateMessageView;
-(CGSize) updateButtonView:(CGFloat) width;

-(void) mergeTargetView;
-(void) clearTargetView;

+(nullable NSMutableAttributedString *) parseDialogTitle:(nullable NSString *) title;
+(nullable NSMutableAttributedString *) parseDialogMessage:(nullable NSString *)dialogMessage;
+(nullable NSArray<id> *) parseNormalButtonNames:(nullable NSArray<NSString*> *) names  hasStyle:(BOOL) hasStyle;
+(nullable NSArray<id> *) parseHihtLightedButtonName:(nullable NSArray<NSString*> *) names  hasStyle:(BOOL) hasStyle;


@end
