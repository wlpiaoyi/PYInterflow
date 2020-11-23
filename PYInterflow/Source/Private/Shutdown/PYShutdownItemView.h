//
//  PYShutdownItemView.h
//  PYInterflow
//
//  Created by wlpiaoyi on 2020/11/22.
//  Copyright © 2020 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYUtile.h"

NS_ASSUME_NONNULL_BEGIN

@interface PYShutdownItemView : UIView

kPNA NSInteger selectedIndex;
kPNA NSInteger itemMaxCount;
kPNSNA NSArray<NSString *> * items;
kPNCNA void (^blockSelectedOpt) (PYShutdownItemView * itemView);

@end

NS_ASSUME_NONNULL_END
