//
//  PYDialogButtonView.h
//  PYInterflow
//
//  Created by wlpiaoyi on 2016/12/8.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PYDialogButtonView : UIView

@property (nonatomic, strong, nullable) NSArray<NSAttributedString *> * normalButtonNames;
@property (nonatomic, strong, nullable) NSArray<NSAttributedString *> * hightLightedButtonNames;
-(nullable instancetype) initWithTarget:(nonnull id) target action:(nonnull SEL) action blockSetButtonLayout:(void (^_Nonnull)(UIButton * _Nonnull button)) blockSetButtonLayout;
-(CGSize) reloadButtons;

+(CGSize) getSize:(nullable NSArray<NSAttributedString *> *) attributeButtonNames;

@end
