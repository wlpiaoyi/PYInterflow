//
//  PYPopupParam.h
//  PYInterflow
//
//  Created by wlpiaoyi on 2016/12/8.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYParams.h"
#import "PYPopupWindow.h"

@interface PYPopupParam : NSObject
//是否正在进行动画
@property (nonatomic) BOOL isAnimationing;
//是否显示了
@property (nonatomic) BOOL isShow;
//显示靠近中心的偏移量
@property (nonatomic) CGPoint centerPoint;
//显示靠近边缘的偏移量
@property (nonatomic) UIEdgeInsets borderEdgeInsets;
//显示框的大小
//@property (nonatomic) CGSize offsetSize;

//=====================显示和隐藏时候的回调=========================>
@property (nonatomic,copy, nullable) void (^popupBlockStart)(UIView * _Nullable view);
@property (nonatomic,copy, nullable) void (^blockEnd)(UIView * _Nullable view);
@property (nonatomic,copy, nullable) BlockPopupAnimation blockShowAnimation;
@property (nonatomic,copy, nullable) BlockPopupAnimation blockHiddenAnimation;
///<=====================显示和隐藏时候的回调=========================

//基础层
@property (nonatomic, strong, nonnull) UIView * baseView;
//@property (nonatomic, assign, nullable) UIWindow * preWidnow;
@property (nonatomic) CGRect frameOrg;
@property (nonatomic, strong, nullable) NSMutableDictionary<NSString *, NSLayoutConstraint *> * lc;

-(nonnull BlockPopupAnimation) creteDefaultBlcokPopupShowAnmation;
-(nonnull BlockPopupEndAnmation) creteDefaultBlcokPopupShowEndAnmation;

-(nonnull BlockPopupAnimation) creteDefaultBlcokPopupHiddenAnmation;
-(nonnull BlockPopupEndAnmation) creteDefaultBlcokPopupHiddenEndAnmation;
@end
