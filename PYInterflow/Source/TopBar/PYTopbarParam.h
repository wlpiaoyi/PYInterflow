//
//  PYTopbarParam.h
//  PYInterflow
//
//  Created by wlpiaoyi on 2016/12/9.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PYTopbarParam : NSObject
@property (nonatomic, strong, nullable) NSAttributedString * message;
@property (nonatomic, strong, nullable) UIView * messageView;
-(nullable instancetype) initWithTargetView:(nonnull UIView *) targetView;
-(CGSize) updateMessageView;
+(nullable NSMutableAttributedString *) parseTopbarMessage:(nullable NSString *) message;
@end
