//
//  PYDialogTitleView.h
//  PYInterflow
//
//  Created by wlpiaoyi on 2016/12/8.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PYDialogTitleView : UIView
@property (nonatomic, strong, nullable) NSAttributedString * attributeTitle;
+(CGSize) getSize:(nullable NSAttributedString *) attributeTitle;
@end
