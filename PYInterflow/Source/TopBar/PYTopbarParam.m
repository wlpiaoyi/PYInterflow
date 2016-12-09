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
        [PYViewAutolayoutCenter persistConstraint:l relationmargins:UIEdgeInsetsMake(0, STATIC_POPUP_OFFSETWIDTH, 0, STATIC_POPUP_OFFSETWIDTH) relationToItems:PYEdgeInsetsItemNull()];
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
    s.width = boundsWidth() - STATIC_POPUP_OFFSETWIDTH * 2;
    s.height = 999;
    s = [PYUtile getBoundSizeWithAttributeTxt:self.message size:s];
    s.width += STATIC_POPUP_OFFSETWIDTH * 2;
    s.height += STATIC_POPUP_OFFSETWIDTH * 2;
    s.width = MIN(MAX(s.width, boundsWidth()/2), boundsWidth());
    s.height = MIN(100, s.height);
//    [self.lableMessage setCornerRadiusAndBorder:s.height/2 borderWidth:0 borderColor:[UIColor clearColor]];
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
