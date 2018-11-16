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
@property (nonatomic, strong, nonnull) UILabel * lableMessage;
kPNSNA UIImageView * imageView;
@end

@implementation PYToastParam

-(nullable instancetype) initWithTargetView:(nonnull UIView *) targetView{
    if(self = [super init]){
        
        self.baseView = targetView;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self.baseView action:@selector(popupHidden)];
        [self.baseView addGestureRecognizer:tap];
        
        UIView * contentView = [UIView new];
        contentView.backgroundColor = [UIColor clearColor];
        [contentView setShadowColor:STATIC_TOPBAR_MESSAGEC.CGColor shadowRadius:5];
        [self.baseView addSubview:contentView];
        [PYViewAutolayoutCenter persistConstraint:contentView relationmargins:UIEdgeInsetsMake(0, 0, 0, 0) relationToItems:PYEdgeInsetsItemNull()];
        self.contentView = contentView;
        
        contentView = [UIView new];
        contentView.backgroundColor = STATIC_TOPBAR_BGC;
        [contentView setCornerRadiusAndBorder:5 borderWidth:0 borderColor:nil];
        [self.contentView addSubview:contentView];
        [PYViewAutolayoutCenter persistConstraint:contentView relationmargins:UIEdgeInsetsMake(0, 0, 0, 0) relationToItems:PYEdgeInsetsItemNull()];
        
        UILabel * labelMessage = [UILabel new];
        labelMessage.numberOfLines = 0;
        labelMessage.textAlignment = NSTextAlignmentCenter;
        labelMessage.backgroundColor = [UIColor clearColor];
        labelMessage.textAlignment = NSTextAlignmentCenter;
        [contentView addSubview:labelMessage];
        [PYViewAutolayoutCenter persistConstraint:labelMessage relationmargins:UIEdgeInsetsMake(STATIC_DIALOG_OFFSETWIDTH*2, STATIC_DIALOG_OFFSETWIDTH*3, STATIC_DIALOG_OFFSETWIDTH*2, STATIC_DIALOG_OFFSETWIDTH*3) relationToItems:PYEdgeInsetsItemNull()];
        self.lableMessage = labelMessage;
        
    }
    return self;
}

-(CGSize) updateMessageView{
    self.lableMessage.hidden = YES;
    if(!self.message) return CGSizeMake(0, 0);
    self.lableMessage.hidden = NO;
    self.lableMessage.attributedText = self.message;
    CGSize s = CGSizeMake(99999, 9999);
    s.width = MIN(boundsWidth()-40, [PYUtile getBoundSizeWithAttributeTxt:self.message size:s].width + STATIC_DIALOG_OFFSETWIDTH * 6 + 1);
    s.height = 99999;
    s.height = [PYUtile getBoundSizeWithAttributeTxt:self.message size:s].height;
    s.height += STATIC_DIALOG_OFFSETWIDTH * 4 + 1;
    return s;
}

+(nullable NSMutableAttributedString *) parseTopbarMessage:(nullable NSString *) message{
    if(message == nil) return nil;
    NSMutableAttributedString *attMsg = [[NSMutableAttributedString alloc] initWithString:message];
    NSRange range = NSMakeRange(0, attMsg.length);
    [attMsg removeAttribute:NSForegroundColorAttributeName range:range];
    [attMsg removeAttribute:NSFontAttributeName range:range];
    [attMsg addAttribute:NSForegroundColorAttributeName value:STATIC_TOPBAR_MESSAGEC range:NSMakeRange(0, attMsg.length)];//颜色
    [attMsg addAttribute:NSFontAttributeName value:STATIC_TOPBAR_MESSAGEFONT range:NSMakeRange(0, attMsg.length)];
    return attMsg;
}

@end
