//
//  PYDialogButtonView.m
//  PYInterflow
//
//  Created by wlpiaoyi on 2016/12/8.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "PYDialogButtonView.h"
#import "pyutilea.h"
#import "PYParams.h"
@interface PYDialogButtonView()
@property (nonatomic, assign, nonnull) id target;
@property (nonatomic, nonnull) SEL action;
@end

@implementation PYDialogButtonView{
@private
    NSMutableArray<NSLayoutConstraint *> * lcs;
    UIView * topLine;
}

-(instancetype) initWithTarget:(id) target action:(SEL) action{
    if(self = [super init]){
        lcs = [NSMutableArray new];
        self.backgroundColor = STATIC_DIALOG_BACKGROUNDCLOLOR;
        UIView * line = [UIView new];
        line.backgroundColor = STATIC_DIALOG_BORDERCLOLOR;
        [self addSubview: line];
        [PYViewAutolayoutCenter persistConstraint:line size:CGSizeMake(DisableConstrainsValueMAX, .5)];
        [PYViewAutolayoutCenter persistConstraint:line relationmargins:UIEdgeInsetsMake(0, 0, DisableConstrainsValueMAX, 0) relationToItems:PYEdgeInsetsItemNull()];
        self.target = target;
        self.action = action;
        topLine = line;
    }
    return self;
}

-(CGSize) reloadButtons{
    if(self.normalButtonNames.count != self.hightLightedButtonNames.count){
        return CGSizeMake(0, 0);
    }
    for (UIView * subView in self.subviews) {
        [subView removeFromSuperview];
    }
    for (NSLayoutConstraint * lc in lcs) {
        [self removeConstraint:lc];
    }
    [lcs removeAllObjects];
    
    NSHashTable<UIView *> * toFontViews = [NSHashTable weakObjectsHashTable];
    [toFontViews addObject:topLine];
    
    UIView * lineCenter = nil;
    if(self.normalButtonNames.count == 2){
        lineCenter = [UIView new];
        lineCenter.backgroundColor = STATIC_DIALOG_BORDERCLOLOR;
        [self addSubview:lineCenter];
        [PYViewAutolayoutCenter persistConstraint:lineCenter size:CGSizeMake(STATIC_POPUP_BORDERWIDTH, DisableConstrainsValueMAX)];
        [lcs addObjectsFromArray:[PYViewAutolayoutCenter persistConstraint:lineCenter centerPointer:CGPointMake(0, DisableConstrainsValueMAX)].allValues];
        [lcs addObjectsFromArray:[PYViewAutolayoutCenter persistConstraint:lineCenter relationmargins:UIEdgeInsetsMake(0, DisableConstrainsValueMAX, 0, DisableConstrainsValueMAX) relationToItems:PYEdgeInsetsItemNull()].allValues];
        [toFontViews addObject:lineCenter];
    }
    
    UIView * line = nil;
    UIButton * preButton = nil;
    CGFloat height = 0;
    for (NSAttributedString * normalButtonName in self.normalButtonNames) {
        int index = preButton ? preButton.tag + 1 : 0;
        UIButton *button = [PYDialogButtonView createButtonWithNormalName:normalButtonName hightLightedName:self.hightLightedButtonNames[index]];
        button.tag = index;
        [button addTarget:self.target action:self.action forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [PYViewAutolayoutCenter persistConstraint:button size:CGSizeMake(DisableConstrainsValueMAX, STATIC_POPUP_BUTTON_HEIGHT)];
        if(lineCenter){
            if(line == nil){
                line = [UIView new];
                line.backgroundColor = STATIC_DIALOG_BORDERCLOLOR;
                [self addSubview:line];
                [toFontViews addObject:line];
                [PYViewAutolayoutCenter persistConstraint:line size:CGSizeMake(DisableConstrainsValueMAX, STATIC_POPUP_BORDERWIDTH)];
                PYEdgeInsetsItem e = PYEdgeInsetsItemNull();
                [lcs addObjectsFromArray:[PYViewAutolayoutCenter persistConstraint:line relationmargins:UIEdgeInsetsMake(0, 0, DisableConstrainsValueMAX, 0) relationToItems:e].allValues];
            }
        }else{
            line = [UIView new];
            line.backgroundColor = STATIC_DIALOG_BORDERCLOLOR;
            [self addSubview:line];
            [toFontViews addObject:line];
            PYEdgeInsetsItem e = PYEdgeInsetsItemNull();
            e.top = (__bridge void * _Nullable)(preButton);
            [lcs addObjectsFromArray:[PYViewAutolayoutCenter persistConstraint:line relationmargins:UIEdgeInsetsMake(0, 0, DisableConstrainsValueMAX, 0) relationToItems:e].allValues];
            [PYViewAutolayoutCenter persistConstraint:line size:CGSizeMake(DisableConstrainsValueMAX, STATIC_POPUP_BORDERWIDTH)];
        }
        if(lineCenter){
            PYEdgeInsetsItem e = PYEdgeInsetsItemNull();
            e.top = (__bridge void * _Nullable)(line);
            if(button.tag == 0){
                e = PYEdgeInsetsItemNull();
                e.right = (__bridge void * _Nullable)(lineCenter);
            }else{
                e.left = (__bridge void * _Nullable)(lineCenter);
            }
            [PYViewAutolayoutCenter persistConstraint:button relationmargins:UIEdgeInsetsMake(0, 0, DisableConstrainsValueMAX, 0) relationToItems:e];
            height = STATIC_POPUP_BUTTON_HEIGHT + STATIC_POPUP_BORDERWIDTH;
        }else{
            PYEdgeInsetsItem e = PYEdgeInsetsItemNull();
            e.top = (__bridge void * _Nullable)(line);
            [PYViewAutolayoutCenter persistConstraint:button relationmargins:UIEdgeInsetsMake(0, 0, DisableConstrainsValueMAX, 0) relationToItems:e];
            height += STATIC_POPUP_BUTTON_HEIGHT  + STATIC_POPUP_BORDERWIDTH;
        }
        preButton = button;
    }
    for (UIView * line in toFontViews) {
        [line bringSubviewToFront:line.superview];
    }
    return CGSizeMake(0, height);
}

+(UIButton*) createButtonWithNormalName:(id) normalName hightLightedName:(id) hightLightedName{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if([normalName isKindOfClass:[NSString class]]){
        [button setTitle:normalName forState:UIControlStateNormal];
    }else if([normalName isKindOfClass:[NSAttributedString class]]){
        [button setAttributedTitle:normalName forState:UIControlStateNormal];
    }
    if([hightLightedName isKindOfClass:[NSString class]]){
        [button setTitle:hightLightedName forState:UIControlStateHighlighted];
    }else if([hightLightedName isKindOfClass:[NSAttributedString class]]){
        [button setAttributedTitle:hightLightedName forState:UIControlStateHighlighted];
    }
    button.titleLabel.font = STATIC_DIALOG_BUTTONFONT;
    [button setTitleColor:STATIC_DIALOG_TEXTCLOLOR forState:UIControlStateNormal];
    [button setTitleColor:STATIC_DIALOG_BACKGROUNDCLOLOR forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageWithColor:STATIC_DIALOG_BACKGROUNDCLOLOR] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:STATIC_DIALOG_BORDERCLOLOR] forState:UIControlStateHighlighted];
    return button;
}

+(CGSize) getSize:(nullable NSArray<NSAttributedString *> *) attributeButtonNames{

    if(attributeButtonNames == nil || attributeButtonNames.count == 0) return CGSizeMake(0, 0);
    
    if(attributeButtonNames.count == 2){
        return CGSizeMake(0, STATIC_POPUP_BUTTON_HEIGHT);
    }else{
        return CGSizeMake(0, STATIC_POPUP_BUTTON_HEIGHT * attributeButtonNames.count);
    }
    
}

@end
