//
//  PYDialogButtonView.h
//  PYInterflow
//
//  Created by wlpiaoyi on 2016/12/8.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PYDialogButtonView : UIView
@property (nonatomic, copy, nullable) void (^blockSetButtonLayout)(UIButton * _Nonnull button, NSInteger index);
@property (nonatomic, assign) CGFloat targetWith;
@property (nonatomic, strong, nullable) NSArray<NSAttributedString *> * normalButtonNames;
@property (nonatomic, strong, nullable) NSArray<NSAttributedString *> * hightLightedButtonNames;
-(nullable instancetype) initWithTarget:(nonnull id) target action:(nonnull SEL) action;
-(CGSize) reloadButtons;

@end
