//
//  PYNotifyParam.m
//  PYInterflow
//
//  Created by wlpiaoyi on 2016/12/9.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "PYNotifyParam.h"
#import "PYInterflowParams.h"
#import "pyutilea.h"
#import "UIView+Popup.h"
#import "PYPopupParam.h"

@interface PYNotifyParam()
@property (nonatomic, assign, nonnull) UIView * contentView;
@property (nonatomic, assign, nonnull) UIView * baseView;
@property (nonatomic, strong, nonnull) UILabel * lableMessage;
//kPNSNA UIImageView * imageView;
@end

@implementation PYNotifyParam

-(nullable instancetype) initWithBaseView:(nonnull UIView *) baseView{
    if(self = [super init]){
        self.baseView = baseView;
    }
    return self;
}

-(void) loadNotifyView{
    if(self.contentView) [self.contentView removeFromSuperview];
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    [effectView setCornerRadiusAndBorder:10 borderWidth:0 borderColor:nil];
    [_baseView addSubview:effectView];
    [effectView py_makeConstraints:^(PYConstraintMaker * _Nonnull make) {
        make.top.left.bottom.right.py_constant(5);
    }];
    [effectView.superview sendSubviewToBack:effectView];
    
    UIView * borderView = [UIView new];
    [borderView setCornerRadiusAndBorder:10 borderWidth:0 borderColor:nil];
    [_baseView addSubview:borderView];
    [borderView py_makeConstraints:^(PYConstraintMaker * _Nonnull make) {
        make.top.left.bottom.right.py_constant(5);
    }];
    borderView.backgroundColor = xPYInterflowConfValue.dialog.colorBg;
    
    
    UILabel * l = [UILabel new];
    l.numberOfLines = 0;
    l.textAlignment = NSTextAlignmentCenter;
    l.backgroundColor = [UIColor clearColor];
    l.textAlignment = NSTextAlignmentCenter;
    UIView * contentView = [UIView new];
    contentView.backgroundColor = [UIColor clearColor];
    [contentView addSubview:l];
    self.lableMessage = l;
    [PYViewAutolayoutCenter persistConstraint:l relationmargins:UIEdgeInsetsMake(xPYInterflowConfValue.dialog.offsetWith*2, xPYInterflowConfValue.dialog.offsetWith*3, xPYInterflowConfValue.dialog.offsetWith*2, xPYInterflowConfValue.dialog.offsetWith*3) relationToItems:PYEdgeInsetsItemNull()];
    [_baseView addSubview:contentView];
    [contentView py_makeConstraints:^(PYConstraintMaker * _Nonnull make) {
        make.top.left.bottom.right.py_constant(5);
    }];
    UISwipeGestureRecognizer * swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onclickSwipe)];
    swipe.direction = UISwipeGestureRecognizerDirectionUp;
    [_baseView addGestureRecognizer:swipe];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onclickTap)];
    [_baseView addGestureRecognizer:tap];
    self.contentView = contentView;
}


-(void) onclickTap{
    if(self.blockTap){
        _blockTap(self.baseView);
    }
    [self onclickSwipe];
}
-(void) onclickSwipe{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PYNotifyHidden" object:nil];
}

-(CGSize) updateMessageView{
    self.lableMessage.hidden = YES;
    if(!self.message) return CGSizeMake(0, 0);
    self.lableMessage.hidden = NO;
    self.lableMessage.attributedText = self.message;
    CGSize s = CGSizeMake(99999, 9999);
    s.width = boundsWidth() - xPYInterflowConfValue.dialog.offsetWith * 6 - 10;
    s.height = 99999;
    s.height = [PYUtile getBoundSizeWithAttributeTxt:self.message size:s].height;
    s.height += xPYInterflowConfValue.dialog.offsetWith * 4 + 1 + 10;
    s.width = boundsWidth();
    return s;
}

+(nullable NSMutableAttributedString *) parseNotifyMessage:(nullable NSString *) message color:(nullable UIColor *) color{
    if(message == nil) return nil;
    if(!color)color = xPYInterflowConfValue.dialog.colorTxt;
    NSMutableAttributedString *attMsg = [[NSMutableAttributedString alloc] initWithString:message];
    NSRange range = NSMakeRange(0, attMsg.length);
    [attMsg removeAttribute:NSForegroundColorAttributeName range:range];
    [attMsg removeAttribute:NSFontAttributeName range:range];
    [attMsg addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, attMsg.length)];//颜色
    [attMsg addAttribute:NSFontAttributeName value:xPYInterflowConfValue.toast.fontMsg range:NSMakeRange(0, attMsg.length)];
    return attMsg;
}

@end
