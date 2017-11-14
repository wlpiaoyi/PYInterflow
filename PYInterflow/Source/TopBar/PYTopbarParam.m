//
//  PYTopbarParam.m
//  PYInterflow
//
//  Created by wlpiaoyi on 2016/12/9.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "PYTopbarParam.h"
#import "PYParams.h"
#import "pyutilea.h"
#import "UIView+Popup.h"

@interface PYTopbarParam()
@property (nonatomic, assign, nonnull) UIView * contentView;
@property (nonatomic, assign, nonnull) UIView * baseView;
@property (nonatomic, strong, nonnull) UILabel * lableMessage;
@end

@implementation PYTopbarParam

-(nullable instancetype) initWithTargetView:(nonnull UIView *) targetView{
    if(self = [super init]){
        UILabel * l = [UILabel new];
        l.numberOfLines = 0;
        l.textAlignment = NSTextAlignmentCenter;
        l.backgroundColor = [UIColor clearColor];
        l.textAlignment = NSTextAlignmentCenter;
        UIView * contentView = [UIView new];
        contentView.backgroundColor = STATIC_TOPBAR_BGC;
        [contentView addSubview:l];
        self.lableMessage = l;
        [contentView setCornerRadiusAndBorder:5 borderWidth:2 borderColor:[UIColor whiteColor]];
        self.contentView = contentView;
        [PYViewAutolayoutCenter persistConstraint:l relationmargins:UIEdgeInsetsMake(STATIC_POPUP_OFFSETWIDTH*2, STATIC_POPUP_OFFSETWIDTH*3, STATIC_POPUP_OFFSETWIDTH*2, STATIC_POPUP_OFFSETWIDTH*3) relationToItems:PYEdgeInsetsItemNull()];
        self.baseView = targetView;
        [targetView setShadowColor:[UIColor grayColor].CGColor shadowRadius:2];
        [self.baseView addSubview:self.contentView];
        [PYViewAutolayoutCenter persistConstraint:self.contentView relationmargins:UIEdgeInsetsMake(0, 0, 0, 0) relationToItems:PYEdgeInsetsItemNull()];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self.baseView action:@selector(popupHidden)];
        [self.baseView addGestureRecognizer:tap];
//        UISwipeGestureRecognizer * sgr = [[UISwipeGestureRecognizer alloc] initWithTarget:self.baseView action:@selector(popupHidden)];
//        sgr.direction = UISwipeGestureRecognizerDirectionUp;
//        [self.baseView addGestureRecognizer:sgr];
    }
    return self;
}

-(CGSize) updateMessageView{
    self.lableMessage.hidden = YES;
    if(!self.message) return CGSizeMake(0, 0);
    self.lableMessage.hidden = NO;
    self.lableMessage.attributedText = self.message;
    CGSize s = CGSizeMake(9999, 20);
    s.width = MIN(boundsWidth()-40, [PYUtile getBoundSizeWithAttributeTxt:self.message size:s].width + STATIC_POPUP_OFFSETWIDTH * 6 + 1);
    s.height = 999;
    s.height = [PYUtile getBoundSizeWithAttributeTxt:self.message size:s].height;
    s.height += STATIC_POPUP_OFFSETWIDTH * 4 + 1;
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
