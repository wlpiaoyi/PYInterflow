//
//  PYNotifyParam.h
//  PYInterflow
//
//  Created by wlpiaoyi on 2016/12/9.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PYNotifyParam : NSObject

@property (nonatomic, assign) NSUInteger timeRemainning;
@property (nonatomic, strong, nullable) NSAttributedString * message;
@property (nonatomic, strong, nullable) UIView * messageView;
@property (nonatomic, copy, nullable) void (^blockTap)(UIView * _Nonnull targetView);

-(nullable instancetype) initWithBaseView:(nonnull UIView *) baseView;
-(void) loadNotifyView;
-(CGSize) updateMessageView;
+(nullable NSMutableAttributedString *) parseNotifyMessage:(nullable NSString *) message color:(nullable UIColor *) color;

@end
