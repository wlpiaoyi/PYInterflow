//
//  PYShutdownPopupView.h
//  PYInterflow
//
//  Created by wlpiaoyi on 2020/8/18.
//  Copyright © 2020 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pyutilea.h"

NS_ASSUME_NONNULL_BEGIN

@interface PYShutdownPopupView : UIView

-(void) showWithSubView:(nonnull UIView *) subView superView:(nonnull UIView *) superView topItem:(nullable UIView *) topItem topConstant:(CGFloat) topConstant;

-(void) showWithSubView:(nonnull UIView *) subView superView:(nonnull UIView *) superView topConstant:(CGFloat) topConstant;

-(void) hidden;


@end

NS_ASSUME_NONNULL_END
