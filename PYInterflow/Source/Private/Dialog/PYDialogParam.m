//
//  PYDialogParam.m
//  PYInterflow
//
//  Created by wlpiaoyi on 2016/12/7.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "PYDialogParam.h"
#import "PYInterflowParams.h"
#import "pyutilea.h"
#import "PYDialogTitleView.h"
#import "PYDialogMessageView.h"
#import "PYDialogButtonView.h"
#import "UIView+Dialog.h"

@interface PYDialogParam()
@property (nonatomic, strong, nullable) NSMutableArray<NSLayoutConstraint *> * lcsContext;
@property (nonatomic, assign, nullable) UIView * targetView;
@property (nonatomic) SEL action;
@end

@implementation PYDialogParam
-(nullable instancetype) initWithTarget:(nonnull id) target action:(nonnull SEL) action {
    if(self = [super init]){
        self.lcsContext = [NSMutableArray new];
        self.targetView = target;
        self.action = action;
        self.contextView = [UIView new];
        [self.contextView setBackgroundColor:[UIColor clearColor]];
        [self.contextView setCornerRadiusAndBorder:10 borderWidth:.5 borderColor:[UIColor clearColor]];
        self.showView = [PYMoveView new];
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        [effectView setCornerRadiusAndBorder:10 borderWidth:.5 borderColor:[UIColor clearColor]];
        [self.showView addSubview:effectView];
        [effectView py_makeConstraints:^(PYConstraintMaker * _Nonnull make) {
            make.top.left.bottom.right.py_constant(0);
        }];
        [effectView.superview sendSubviewToBack:effectView];
        self.showView.backgroundColor = [UIColor clearColor];
        [self.showView addSubview:self.contextView];
        [PYViewAutolayoutCenter persistConstraint:self.contextView relationmargins:UIEdgeInsetsMake(0, 0, 0, 0) relationToItems:PYEdgeInsetsItemNull()];
    }
    return self;
}

-(CGSize) updateTitleView{
    if(self.titleView == nil){
        self.titleView = [PYDialogTitleView new];
        [self.contextView addSubview: self.titleView];
        [PYViewAutolayoutCenter persistConstraint:self.titleView relationmargins:UIEdgeInsetsMake(0, 0, DisableConstrainsValueMAX, 0) relationToItems:PYEdgeInsetsItemNull()];
    }
    ((PYDialogTitleView *)(self.titleView)).attributeTitle = self.attributeTitle;
    CGSize size = [PYDialogTitleView getSize:self.attributeTitle];
    self.lcTitleHeight.constant = size.height;
    return  size;
}
-(CGSize) updateMessageView{
    if(self.attributeMessage == nil || self.attributeMessage.length == 0){
        return CGSizeZero;
    }
    if(self.messageView == nil){
        self.messageView = [PYDialogMessageView new];
        [self.targetView addSubview:self.messageView];
        PYEdgeInsetsItem e = PYEdgeInsetsItemNull();
        [PYViewAutolayoutCenter persistConstraint:self.messageView relationmargins:UIEdgeInsetsMake(0, 0, 0, 0) relationToItems:e];
    }
    ((PYDialogMessageView *)(self.messageView)).attributeMessage = self.attributeMessage;
    return [PYDialogMessageView getSize:self.attributeMessage];
}
-(CGSize) updateButtonView:(CGFloat) width confirm:(BOOL) confirm{
    if(self.buttonView == nil){

        self.buttonView = [[PYDialogButtonView alloc] initWithTarget:self.targetView action:self.action];
        [self.contextView addSubview:self.buttonView];
        self.lcButtonHeight = [PYViewAutolayoutCenter persistConstraint:self.buttonView size:CGSizeMake(DisableConstrainsValueMAX, 0)].allValues.firstObject;
        [PYViewAutolayoutCenter persistConstraint:self.buttonView relationmargins:UIEdgeInsetsMake(DisableConstrainsValueMAX, 0, 0, 0) relationToItems:PYEdgeInsetsItemNull()];
    }
    PYDialogButtonView * view = (PYDialogButtonView *)self.buttonView;
    view.normalButtonNames = self.normalButtonNames;
    view.hightLightedButtonNames = self.hightLightedButtonNames;
    view.targetWith = width;
    view.blockSetButtonLayout = nil;
    if(confirm){
        kAssign(self);
        if(PY_POPUP_DIALOG_BUTTON_CONFIRM) view.blockSetButtonLayout = ^(UIButton * _Nonnull button, NSInteger index) {
            kStrong(self);
            NSMutableArray * names = @[].mutableCopy;
            for (NSAttributedString * attributedString in self.normalButtonNames) {
                [names addObject:attributedString.string];
            }
            PY_POPUP_DIALOG_BUTTON_CONFIRM(button, names,  index);
        };
    }else{
        if(PY_POPUP_DIALOG_BUTTON_OPTION) view.blockSetButtonLayout = ^(UIButton * _Nonnull button, NSInteger index) {
            PY_POPUP_DIALOG_BUTTON_OPTION(button, index);
        };
    }
    CGSize size = [view reloadButtons];
    self.lcButtonHeight.constant = size.height;
    return size;
}

-(void) mergeTargetView{
    [self clearTargetView];
    [self.contextView addSubview:self.targetView];
    PYEdgeInsetsItem e = PYEdgeInsetsItemNull();
    e.top = (__bridge void * _Nullable)(self.titleView);
    e.bottom = (__bridge void * _Nullable)(self.buttonView);
    [self.lcsContext addObjectsFromArray:[PYViewAutolayoutCenter persistConstraint:self.targetView relationmargins:UIEdgeInsetsMake(0, 0, 0, 0) relationToItems:e].allValues];
}

-(void) clearTargetView{
    for (NSLayoutConstraint * lc in self.lcsContext) {
        [self.contextView removeConstraint:lc];
    }
    [self.targetView removeFromSuperview];
}

+(nullable NSMutableAttributedString *) parseDialogTitle:(nullable NSString *) title{
    if(title == nil) return nil;
    return [self parseForAttributeWithName:title font:xPYInterflowConfValue.dialog.fontTitle color:xPYInterflowConfValue.dialog.colorTitle];
}
+(nullable NSMutableAttributedString *) parseDialogMessage:(nullable NSString *)dialogMessage{
    if(dialogMessage == nil) return nil;
    NSMutableAttributedString *attMsg = [[NSMutableAttributedString alloc] initWithString:dialogMessage];
    NSRange range = NSMakeRange(0, attMsg.length);
    [attMsg removeAttribute:NSForegroundColorAttributeName range:range];
    [attMsg removeAttribute:NSFontAttributeName range:range];
    [attMsg addAttribute:NSForegroundColorAttributeName value:xPYInterflowConfValue.dialog.colorMessage range:NSMakeRange(0, attMsg.length)];//颜色
    [attMsg addAttribute:NSFontAttributeName value:xPYInterflowConfValue.dialog.fontMessage range:NSMakeRange(0, attMsg.length)];
    return attMsg;
}
+(nullable NSArray<id> *) parseConfrimName:(nullable NSString *) confirmName cancelName:(nullable NSString *)cancelName{
    NSMutableArray<NSAttributedString *> * ats = [NSMutableArray new];
    NSAttributedString *attName;
    if([NSString isEnabled:cancelName]){
        attName = [self parseForAttributeWithName:cancelName font:xPYInterflowConfValue.dialog.fontCancel color:xPYInterflowConfValue.dialog.colorCancel];
        [ats addObject:attName];
    }
    if([NSString isEnabled:confirmName]){
        attName = [self parseForAttributeWithName:confirmName font:xPYInterflowConfValue.dialog.fontConfirm color:xPYInterflowConfValue.dialog.colorConfirme];
        [ats addObject:attName];
    }
    return ats;
}
+(nullable NSArray<id> *) parseNormalButtonNames:(nullable NSArray<NSString*> *) names{
    NSMutableArray<NSAttributedString *> * ats = [NSMutableArray new];
    for (NSString * name in names) {
        NSAttributedString *attTitle = [self parseForAttributeWithName:name font:xPYInterflowConfValue.dialog.fontButton color:xPYInterflowConfValue.dialog.colorMessage];
        [ats addObject:attTitle];
    }
    return ats;
}
+(nullable NSArray<id> *) parseHihtLightedButtonName:(nullable NSArray<NSString*> *) names {
    NSMutableArray<NSAttributedString *> * ats = [NSMutableArray new];
    for (NSString * name in names) {
        NSAttributedString *attTitle = [self parseForAttributeWithName:name font:xPYInterflowConfValue.dialog.fontButton color:xPYInterflowConfValue.popup.colorHighlightTxt];
        [ats addObject:attTitle];
    }
    return ats;
}

+(nullable NSMutableAttributedString *) parseForAttributeWithName:(nullable NSString *) name font:(UIFont *) font color:(UIColor *) color{
    NSMutableAttributedString *attTitle = [[NSMutableAttributedString alloc] initWithString:name];
    NSRange range = NSMakeRange(0, name.length);
    [attTitle addAttribute:NSForegroundColorAttributeName value:color range:range];//颜色
    [attTitle addAttribute:NSFontAttributeName value:font range:range];
    return attTitle;
}


@end


