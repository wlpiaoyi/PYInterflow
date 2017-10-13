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
@property (nonatomic, assign, nonnull) UIView * targetView;
@property (nonatomic, strong, nonnull) UILabel * lableMessage;
@end

@implementation PYTopbarParam

-(nullable instancetype) initWithTargetView:(nonnull UIView *) targetView{
    if(self = [super init]){
        self.targetView = targetView;
        UILabel * l = [UILabel new];
        l.numberOfLines = 0;
        l.textAlignment = NSTextAlignmentCenter;
        l.backgroundColor = [UIColor clearColor];
        self.targetView.backgroundColor = STATIC_TOPBAR_BGC;
        [self.targetView addSubview:l];
        self.lableMessage = l;
        [PYViewAutolayoutCenter persistConstraint:l relationmargins:UIEdgeInsetsMake(STATIC_POPUP_OFFSETWIDTH, STATIC_POPUP_OFFSETWIDTH, STATIC_POPUP_OFFSETWIDTH, STATIC_POPUP_OFFSETWIDTH) relationToItems:PYEdgeInsetsItemNull()];
        UISwipeGestureRecognizer * sgr = [[UISwipeGestureRecognizer alloc] initWithTarget:targetView action:@selector(popupHidden)];
        sgr.direction = UISwipeGestureRecognizerDirectionUp;
        [targetView addGestureRecognizer:sgr];
    }
    return self;
}

-(CGSize) updateMessageView{
    self.lableMessage.hidden = YES;
    if(!self.message) return CGSizeMake(0, 0);
    self.lableMessage.hidden = NO;
    self.lableMessage.attributedText = self.message;
    CGSize s = self.targetView.frameSize;
    s.width = boundsWidth();
    s.height = 999;
    s.height = [PYUtile getBoundSizeWithAttributeTxt:self.message size:s].height;
    s.height += 1;
    s.height = MAX(20, MIN(100, s.height));
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
