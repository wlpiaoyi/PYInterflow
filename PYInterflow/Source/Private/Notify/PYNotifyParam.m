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
kPNSNA UIImageView * imageView;
@end

@implementation PYNotifyParam

-(nullable instancetype) initWithTargetView:(nonnull UIView *) targetView{
    if(self = [super init]){
        
        UIView * nbView = [UIView new];
        nbView.backgroundColor = [UIColor clearColor];
        [targetView addSubview:nbView];
        [nbView setAutotLayotDict:@{@"left":@(0), @"right":@(0), @"top":@(0), @"bottom":@(0)}];
        [nbView setShadowColor:[UIColor grayColor].CGColor shadowRadius:2];
        
        self.imageView = [UIImageView new];
        [nbView addSubview:self.imageView];
        [self.imageView setAutotLayotDict:@{@"left":@(0), @"right":@(0), @"top":@(0), @"bottom":@(0)}];
        
        UIView * borderView = [UIView new];
        [nbView addSubview:borderView];
        [borderView setAutotLayotDict:@{@"left":@(0), @"right":@(0), @"top":@(0), @"bottom":@(0)}];
        borderView.backgroundColor = STATIC_TOPBAR_BGC;
        
        
        UILabel * l = [UILabel new];
        l.numberOfLines = 0;
        l.textAlignment = NSTextAlignmentCenter;
        l.backgroundColor = [UIColor clearColor];
        l.textAlignment = NSTextAlignmentCenter;
        UIView * contentView = [UIView new];
        contentView.backgroundColor = [UIColor clearColor];
        [contentView addSubview:l];
        self.lableMessage = l;
        [l setShadowColor:STATIC_TOPBAR_BGC.CGColor shadowRadius:2];
        [PYViewAutolayoutCenter persistConstraint:l relationmargins:UIEdgeInsetsMake(STATIC_DIALOG_OFFSETWIDTH*2, STATIC_DIALOG_OFFSETWIDTH*3, STATIC_DIALOG_OFFSETWIDTH*2, STATIC_DIALOG_OFFSETWIDTH*3) relationToItems:PYEdgeInsetsItemNull()];
        [targetView addSubview:contentView];
        [contentView setAutotLayotDict:@{@"left":@(0), @"right":@(0), @"top":@(0), @"bottom":@(0)}];
        UISwipeGestureRecognizer * swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onclickSwipe)];
        swipe.direction = UISwipeGestureRecognizerDirectionUp;
        [targetView addGestureRecognizer:swipe];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onclickTap)];
        [targetView addGestureRecognizer:tap];
        self.baseView = targetView;
        self.contentView = contentView;
    }
    return self;
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
    s.width = boundsWidth()-STATIC_DIALOG_OFFSETWIDTH*6;
    s.height = 99999;
    s.height = [PYUtile getBoundSizeWithAttributeTxt:self.message size:s].height;
    s.height += STATIC_DIALOG_OFFSETWIDTH * 4 + 1;
    s.width = boundsWidth();
    return s;
}

+(nullable NSMutableAttributedString *) parseNotifyMessage:(nullable NSString *) message color:(nullable UIColor *) color{
    if(message == nil) return nil;
    if(!color)color = STATIC_TOPBAR_MESSAGEC;
    NSMutableAttributedString *attMsg = [[NSMutableAttributedString alloc] initWithString:message];
    NSRange range = NSMakeRange(0, attMsg.length);
    [attMsg removeAttribute:NSForegroundColorAttributeName range:range];
    [attMsg removeAttribute:NSFontAttributeName range:range];
    [attMsg addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, attMsg.length)];//颜色
    [attMsg addAttribute:NSFontAttributeName value:STATIC_TOPBAR_MESSAGEFONT range:NSMakeRange(0, attMsg.length)];
    return attMsg;
}

@end
