//
//  PYSheetHeadView.h
//  PYInterflow
//
//  Created by wlpiaoyi on 2016/12/8.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PYSheetHeadView : UIView
@property (nonatomic, strong, nullable)  NSAttributedString * title;
@property (nonatomic, strong, nullable)  NSAttributedString * confirmNormal;
@property (nonatomic, strong, nullable)  NSAttributedString * cancelNormal;
@property (nonatomic, strong, nullable)  NSAttributedString * confirmHighlighted;
@property (nonatomic, strong, nullable)  NSAttributedString * cancelHighlighted;
-(nullable instancetype) initWithTarget:(nullable UIView *) target action:(nullable SEL) action;
-(CGFloat) reloadView;
@end
