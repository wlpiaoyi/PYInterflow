//
//  PYDialogMessageView.h
//  PYInterflow
//
//  Created by wlpiaoyi on 2016/12/8.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYUtile.h"

@interface PYDialogMessageView : UIView

kPNA NSTextAlignment textAlignment;
kPNSNA NSAttributedString * attributeMessage;

+(CGSize) getSize:(nullable NSAttributedString *) attributeMessage;

@end
