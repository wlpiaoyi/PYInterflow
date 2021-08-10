//
//  PYToastParam.m
//  PYInterflow
//
//  Created by wlpiaoyi on 2016/12/9.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "PYToastParam.h"
#import "PYInterflowParams.h"
#import "pyutilea.h"
#import "UIView+Popup.h"

@interface PYToastParam()

@property (nonatomic, assign, nonnull) UIView * contentView;
@property (nonatomic, assign, nonnull) UIView * baseView;

@property (nonatomic, strong, nonnull) UIImageView * imageMessage;
@property (nonatomic, strong, nonnull) UILabel * lableMessage;

@end

@implementation PYToastParam

-(nullable instancetype) initWithTargetView:(nonnull UIView *) targetView{
    if(self = [super init]){
        self.baseView = targetView;
    }
    return self;
}

-(UIView *) contentView{
    if(_contentView) return _contentView;
    UIView * contentView = [UIView new];
    contentView.backgroundColor = [UIColor clearColor];
//    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
//    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
//    [effectView setCornerRadiusAndBorder:10 borderWidth:0 borderColor:nil];
//    [contentView addSubview:effectView];
//    [effectView py_makeConstraints:^(PYConstraintMaker * _Nonnull make) {
//        make.top.left.bottom.right.py_constant(0);
//    }];
//    [effectView.superview sendSubviewToBack:effectView];
    [self.baseView addSubview:contentView];
    [contentView py_makeConstraints:^(PYConstraintMaker * _Nonnull make) {
        make.top.left.bottom.right.py_constant(0);
    }];
    _contentView = contentView;
    contentView = [UIView new];
    contentView.backgroundColor = xPYInterflowConfValue.toast.colorBg;
    [contentView setCornerRadiusAndBorder:10 borderWidth:0 borderColor:nil];
    [self.contentView addSubview:contentView];
    [contentView py_makeConstraints:^(PYConstraintMaker * _Nonnull make) {
        make.top.left.bottom.right.py_constant(0);
    }];
    _contentView = contentView;
    return _contentView;
}

-(void) setImage:(UIImage *)image{
    _image = image;
    if(!_image){
        self.imageMessage.hidden = YES;
        return;
    }
    self.imageMessage.hidden = NO;
    if(image && self.imageMessage == nil){
        UIImageView * imageMessage = [UIImageView new];
        imageMessage.contentMode = UIViewContentModeScaleAspectFit;
        imageMessage.backgroundColor = [UIColor clearColor];
        self.imageMessage = imageMessage;
        [self.contentView addSubview:imageMessage];
    }
    [self.imageMessage py_makeConstraints:^(PYConstraintMaker * _Nonnull make) {
        make.top.py_constant(xPYInterflowConfValue.toast.offsetWith);
        make.centerX.py_constant(0);
        make.width.py_constant(MIN(boundsWidth() / 2, image.size.width));
        make.height.py_constant(MIN(boundsWidth() / 2, image.size.height));
    }];
    if(self.tintColor){
        self.tintColor = self.tintColor;
    }else{
        self.imageMessage.tintColor = nil;
        self.imageMessage.image = image;
    }
    self.message = self.message;
}

-(void) setTintColor:(UIColor *)tintColor{
    _tintColor = tintColor;
    if(self.image && tintColor){
        self.imageMessage.tintColor = tintColor;
        self.imageMessage.image = [self.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }else if(self.imageMessage){
        self.imageMessage.tintColor = nil;
    }
}

-(void) setMessage:(NSAttributedString *)message{
    _message = message;
    if(_message == nil || _message.length == 0){
        self.lableMessage.hidden = NO;
        return;
    }
    self.lableMessage.hidden = YES;
    if(self.lableMessage == nil){
        UILabel * labelMessage = [UILabel new];
        labelMessage.numberOfLines = 0;
        labelMessage.textAlignment = NSTextAlignmentCenter;
        labelMessage.backgroundColor = [UIColor clearColor];
        labelMessage.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:labelMessage];
        self.lableMessage = labelMessage;
    }
    UIView * topTarget;
    if(self.image){
        self.imageMessage.hidden = NO;
        topTarget = self.imageMessage;
    }else{
        self.imageMessage.hidden = YES;
    }
    [self.lableMessage py_removeAllLayoutContarint];
    [self.lableMessage py_makeConstraints:^(PYConstraintMaker * _Nonnull make) {
        if (topTarget) {
            make.top.py_toItem(topTarget).py_constant(xPYInterflowConfValue.toast.offsetWith);
        }else{
            make.top.py_constant(xPYInterflowConfValue.toast.offsetWith);
        }
        make.bottom.py_constant(xPYInterflowConfValue.toast.offsetWith);
        make.left.right.py_constant(xPYInterflowConfValue.toast.offsetWith);
    }];
    self.lableMessage.attributedText = message;
}

-(CGSize) updateMessageView{
    self.lableMessage.hidden = YES;
    if(!self.message || self.message.length == 0) return CGSizeMake(0, 0);
    self.lableMessage.hidden = NO;
    CGSize s = CGSizeMake(99999, 9999);
    s.width = MIN(boundsWidth() * .618, [PYUtile getBoundSizeWithAttributeTxt:self.message size:s].width + xPYInterflowConfValue.toast.offsetWith * 2 + 1);
    CGFloat imageH = 0;
    if(self.image){
        s.width = MAX(s.width, MIN(boundsWidth() / 2, self.image.size.width)) + xPYInterflowConfValue.toast.offsetWith * 2;
        imageH = MIN(boundsWidth() / 2, self.image.size.height) + xPYInterflowConfValue.toast.offsetWith;
    }
    s.height = 99999;
    s.height = [PYUtile getBoundSizeWithAttributeTxt:self.message size:s].height + xPYInterflowConfValue.toast.offsetWith * 2 + 1 + imageH;
    s.height = MIN(boundsHeight() * .618, s.height);
    return s;
}

+(nullable NSMutableAttributedString *) parseTopbarMessage:(nullable NSString *) message{
    if(message == nil) return nil;
    NSMutableAttributedString *attMsg = [[NSMutableAttributedString alloc] initWithString:message];
    NSRange range = NSMakeRange(0, attMsg.length);
    [attMsg removeAttribute:NSForegroundColorAttributeName range:range];
    [attMsg removeAttribute:NSFontAttributeName range:range];
    [attMsg addAttribute:NSForegroundColorAttributeName value:xPYInterflowConfValue.toast.colorMsg range:NSMakeRange(0, attMsg.length)];//颜色
    [attMsg addAttribute:NSFontAttributeName value:xPYInterflowConfValue.toast.fontMsg range:NSMakeRange(0, attMsg.length)];
    return attMsg;
}

-(void) dealloc{
    
}

@end
