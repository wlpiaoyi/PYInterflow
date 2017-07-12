//
//  PYSheetHeadView.m
//  PYInterflow
//
//  Created by wlpiaoyi on 2016/12/8.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "PYSheetHeadView.h"
#import "PYParams.h"
#import "pyutilea.h"

@interface PYSheetHeadView()
@property (nonatomic, strong, nullable)  UILabel * titleLable;
@property (nonatomic, strong, nullable)  UIButton * confirmButton;
@property (nonatomic, strong, nullable)  UIButton * cancelButton;
@property (nonatomic, assign, nonnull) UIView * targetView;
@property (nonatomic, assign, nonnull) UIView * line;
@property (nonatomic, nonnull) SEL action;
@property (nonatomic, strong) NSLayoutConstraint * lcButtonConfirmWidth;
@property (nonatomic, strong) NSLayoutConstraint * lcButtonCancelWidth;
@end
@implementation PYSheetHeadView
-(nullable instancetype) initWithTarget:(nullable UIView *) target action:(nullable SEL) action{
    if(self = [super init]){
        self.targetView = target;
        self.action = action;
        self.backgroundColor = STATIC_DIALOG_BACKGROUNDCLOLOR;
        UIView * line = [UIView new];
        line.backgroundColor = STATIC_DIALOG_BORDERCLOLOR;
        [self addSubview:line];
        [PYViewAutolayoutCenter persistConstraint:line size:CGSizeMake(DisableConstrainsValueMAX, .5)];
        [PYViewAutolayoutCenter persistConstraint:line relationmargins:UIEdgeInsetsMake(DisableConstrainsValueMAX, 0, 0, 0) relationToItems:PYEdgeInsetsItemNull()];
        self.line = line;
    }
    return self;
}
-(CGFloat) reloadView{
    if(self.confirmButton == nil) {
        UIButton * b = [PYSheetHeadView createButton];
        [b addTarget:self.targetView action:self.action forControlEvents:UIControlEventTouchUpInside];
        b.tag = 0;
        [self addSubview:b];
       self.lcButtonConfirmWidth = [PYViewAutolayoutCenter persistConstraint:b size:CGSizeMake(60, DisableConstrainsValueMAX)].allValues.firstObject;
        [PYViewAutolayoutCenter persistConstraint:b relationmargins:UIEdgeInsetsMake(0, DisableConstrainsValueMAX, 0, 0) relationToItems:PYEdgeInsetsItemNull()];
        self.confirmButton = b;
    }
    if(self.cancelButton == nil) {
        UIButton * b = [PYSheetHeadView createButton];
        [b addTarget:self.targetView action:self.action forControlEvents:UIControlEventTouchUpInside];
        b.tag = 1;
        [self addSubview:b];
        self.lcButtonCancelWidth = [PYViewAutolayoutCenter persistConstraint:b size:CGSizeMake(60, DisableConstrainsValueMAX)].allValues.firstObject;
        [PYViewAutolayoutCenter persistConstraint:b relationmargins:UIEdgeInsetsMake(0, 0, 0, DisableConstrainsValueMAX) relationToItems:PYEdgeInsetsItemNull()];
        self.cancelButton = b;
    }
    if(self.titleLable == nil){
        UILabel * l = [UILabel new];
        l.numberOfLines = 1;
        l.textAlignment = NSTextAlignmentCenter;
        l.backgroundColor = [UIColor clearColor];
        [self addSubview: l];
        PYEdgeInsetsItem e = PYEdgeInsetsItemNull();
        e.left = (__bridge void * _Nullable)(self.cancelButton);
        e.right = (__bridge void * _Nullable)(self.confirmButton);
        [PYViewAutolayoutCenter persistConstraint:l relationmargins:UIEdgeInsetsMake(0, 0, 0, 0) relationToItems:e];
        self.titleLable = l;
    }
    [self.line.superview bringSubviewToFront:self.line];
    CGFloat height = 0;
    self.lcButtonCancelWidth.constant = 0;
    self.lcButtonConfirmWidth.constant = 0;
    if(self.cancelHighlighted && self.cancelNormal){
        [self.cancelButton setAttributedTitle:self.cancelNormal forState:UIControlStateNormal];
        [self.cancelButton setAttributedTitle:self.cancelHighlighted forState:UIControlStateHighlighted];
        self.cancelButton.hidden = NO;
        self.lcButtonCancelWidth.constant = MAX([PYUtile getBoundSizeWithAttributeTxt:self.cancelNormal size:CGSizeMake(999, STATIC_POPUP_BUTTON_HEIGHT)].width, 60);
        height = STATIC_POPUP_BUTTON_HEIGHT;
    }
    if(self.confirmHighlighted && self.confirmNormal){
        [self.confirmButton setAttributedTitle:self.confirmNormal forState:UIControlStateNormal];
        [self.confirmButton setAttributedTitle:self.confirmHighlighted forState:UIControlStateHighlighted];
        height = STATIC_POPUP_BUTTON_HEIGHT;
        self.lcButtonConfirmWidth.constant = MAX([PYUtile getBoundSizeWithAttributeTxt:self.confirmNormal size:CGSizeMake(999, STATIC_POPUP_BUTTON_HEIGHT)].width, 60);
    }
    self.titleLable.hidden = YES;
    if(self.title){
        self.titleLable.attributedText = self.title;
        self.titleLable.hidden = NO;
        height = STATIC_POPUP_TITLE_HEIGHT;
    }
    return height;
}

+(UIButton*) createButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = STATIC_DIALOG_BUTTONFONT;
    [button setTitleColor:STATIC_DIALOG_TEXTCLOLOR forState:UIControlStateNormal];
    [button setTitleColor:STATIC_DIALOG_BACKGROUNDCLOLOR forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageWithColor:STATIC_DIALOG_BACKGROUNDCLOLOR] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:STATIC_DIALOG_BORDERCLOLOR] forState:UIControlStateHighlighted];
    return button;
}
@end
