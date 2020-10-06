//
//  PYToastParam.h
//  PYInterflow
//
//  Created by wlpiaoyi on 2016/12/9.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PYToastParam : NSObject
@property (nonatomic, strong, nullable) NSTimer * timer;
@property (nonatomic, strong, nullable) UIColor * tintColor;
@property (nonatomic, strong, nullable) UIImage * image;
@property (nonatomic, strong, nullable) NSAttributedString * message;
-(nullable instancetype) initWithTargetView:(nonnull UIView *) targetView;
-(CGSize) updateMessageView;
+(nullable NSMutableAttributedString *) parseTopbarMessage:(nullable NSString *) message;
@end
