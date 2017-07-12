//
//  PYDialogMessageView.h
//  PYInterflow
//
//  Created by wlpiaoyi on 2016/12/8.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PYDialogMessageView : UIView

@property (nonatomic, strong, nullable) NSAttributedString * attributeMessage;

+(CGSize) getSize:(nullable NSAttributedString *) attributeMessage;

@end
