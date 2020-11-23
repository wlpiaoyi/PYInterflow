//
//  PYShutdownItemCell.h
//  PYInterflow
//
//  Created by wlpiaoyi on 2020/11/22.
//  Copyright © 2020 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYUtile.h"
NS_ASSUME_NONNULL_BEGIN

@interface PYShutdownItemCell : UITableViewCell

kPNSNA NSString * item;
kPNA BOOL isSelectedItem;

+(CGFloat) getHeight;

@end

NS_ASSUME_NONNULL_END
