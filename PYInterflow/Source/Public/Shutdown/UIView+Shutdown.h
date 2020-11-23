//
//  UIView+Shutdown.h
//  PYInterflow
//
//  Created by wlpiaoyi on 2020/11/22.
//  Copyright © 2020 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYUtile.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Shutdown)

kPNA CGFloat shutdownHeight;
kPNA NSInteger shutdownSelectedIndex;
kPNSNA NSArray<NSString *> * shutdownItems;

kPNCNA void (^blockShutdownSelectedItem) (UIView * view);
kPNCNA void (^blockBeforeShutdownShow) (UIView * view);
kPNCNA void (^blockAfterShutdownHidden) (UIView * view);

-(void) shutdownShowWithSuperView:(nonnull UIView *) superView topConstant:(CGFloat) topConstant;
-(void) shutdownShowWithSuperView:(nonnull UIView *) superView topItem:(nullable UIView *) topItem topConstant:(CGFloat) topConstant;

-(void) shutdownHidden;

@end

NS_ASSUME_NONNULL_END
