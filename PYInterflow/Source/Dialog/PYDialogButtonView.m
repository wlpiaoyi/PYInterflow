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
@property (nonatomic, copy, nullable) void (^blockSetButtonLayout)(UIButton * _Nonnull button);
@end

@implementation PYDialogButtonView{
@private
    NSMutableArray<NSLayoutConstraint *> * lcs;
    UIView * topLine;
}
-(nullable instancetype) initWithTarget:(nonnull id) target action:(nonnull SEL) action blockSetButtonLayout:(void (^_Nonnull)(UIButton * _Nonnull button)) blockSetButtonLayout{
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
        self.blockSetButtonLayout = blockSetButtonLayout;
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
    CGSize frameSize;
    short columns,rows;
    [PYDialogButtonView CHECKForSize:&frameSize columnsp:&columns rows:&rows width:self.targetWith attributeButtonNames:self.normalButtonNames];
    self.frameSize = frameSize;
    
    UIView * lineCenter = nil;
    if(columns == 2){
        lineCenter = [UIView new];
        lineCenter.backgroundColor = STATIC_DIALOG_BORDERCLOLOR;
        lineCenter.hidden = self.blockSetButtonLayout != nil;
        [self addSubview:lineCenter];
        [PYViewAutolayoutCenter persistConstraint:lineCenter size:CGSizeMake(STATIC_POPUP_BORDERWIDTH, DisableConstrainsValueMAX)];
        [lcs addObjectsFromArray:[PYViewAutolayoutCenter persistConstraint:lineCenter centerPointer:CGPointMake(0, DisableConstrainsValueMAX)].allValues];
        [lcs addObjectsFromArray:[PYViewAutolayoutCenter persistConstraint:lineCenter relationmargins:UIEdgeInsetsMake(0, DisableConstrainsValueMAX, 0, DisableConstrainsValueMAX) relationToItems:PYEdgeInsetsItemNull()].allValues];
        [toFontViews addObject:lineCenter];
    }
    
    UIView * line = nil;
    UIView * preBView = nil;
    CGFloat height = 0;
    for (NSAttributedString * normalButtonName in self.normalButtonNames) {
        int index = preBView ? (int)preBView.tag + 1 : 0;
        UIButton *button = [PYDialogButtonView createButtonWithNormalName:normalButtonName hightLightedName:self.hightLightedButtonNames[index]];
        button.tag = index;
        [button addTarget:self.target action:self.action forControlEvents:UIControlEventTouchUpInside];
        UIView * bView = [UIView new];
        bView.backgroundColor = [UIColor clearColor];
        bView.tag = index;
        [bView addSubview:button];
        if(self.blockSetButtonLayout){
            _blockSetButtonLayout(button);
        }else{
            [PYViewAutolayoutCenter persistConstraint:button relationmargins:UIEdgeInsetsMake(0, 0, 0, 0) relationToItems:PYEdgeInsetsItemNull()];
        }
        [self addSubview:bView];
        [PYViewAutolayoutCenter persistConstraint:bView size:CGSizeMake(DisableConstrainsValueMAX, STATIC_POPUP_BUTTON_HEIGHT)];
        if(lineCenter){
            if(line == nil){
                line = [UIView new];
                line.backgroundColor = STATIC_DIALOG_BORDERCLOLOR;
                [self addSubview:line];
                line.hidden = self.blockSetButtonLayout != nil;
                [toFontViews addObject:line];
                [PYViewAutolayoutCenter persistConstraint:line size:CGSizeMake(DisableConstrainsValueMAX, STATIC_POPUP_BORDERWIDTH)];
                PYEdgeInsetsItem e = PYEdgeInsetsItemNull();
                [lcs addObjectsFromArray:[PYViewAutolayoutCenter persistConstraint:line relationmargins:UIEdgeInsetsMake(0, 0, DisableConstrainsValueMAX, 0) relationToItems:e].allValues];
            }
        }else{
            line = [UIView new];
            line.backgroundColor = STATIC_DIALOG_BORDERCLOLOR;
            [self addSubview:line];
            line.hidden = self.blockSetButtonLayout != nil;
            [toFontViews addObject:line];
            PYEdgeInsetsItem e = PYEdgeInsetsItemNull();
            e.top = (__bridge void * _Nullable)(preBView);
            [lcs addObjectsFromArray:[PYViewAutolayoutCenter persistConstraint:line relationmargins:UIEdgeInsetsMake(0, 0, DisableConstrainsValueMAX, 0) relationToItems:e].allValues];
            [PYViewAutolayoutCenter persistConstraint:line size:CGSizeMake(DisableConstrainsValueMAX, STATIC_POPUP_BORDERWIDTH)];
        }
        if(lineCenter){
            PYEdgeInsetsItem e = PYEdgeInsetsItemNull();
            e.top = (__bridge void * _Nullable)(line);
            if(bView.tag == 0){
                e = PYEdgeInsetsItemNull();
                e.right = (__bridge void * _Nullable)(lineCenter);
            }else{
                e.left = (__bridge void * _Nullable)(lineCenter);
            }
            [PYViewAutolayoutCenter persistConstraint:bView relationmargins:UIEdgeInsetsMake(0, 0, DisableConstrainsValueMAX, 0) relationToItems:e];
            height = STATIC_POPUP_BUTTON_HEIGHT + STATIC_POPUP_BORDERWIDTH;
        }else{
            PYEdgeInsetsItem e = PYEdgeInsetsItemNull();
            e.top = (__bridge void * _Nullable)(line);
            [PYViewAutolayoutCenter persistConstraint:bView relationmargins:UIEdgeInsetsMake(0, 0, DisableConstrainsValueMAX, 0) relationToItems:e];
            height += STATIC_POPUP_BUTTON_HEIGHT  + STATIC_POPUP_BORDERWIDTH;
        }
        preBView = bView;
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
    [button setTitleColor:STATIC_DIALOG_TEXTCLOLOR forState:UIControlStateNormal];
    [button setTitleColor:STATIC_DIALOG_BACKGROUNDCLOLOR forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageWithColor:STATIC_DIALOG_BACKGROUNDCLOLOR] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:STATIC_DIALOG_BORDERCLOLOR] forState:UIControlStateHighlighted];
    button.titleLabel.font = STATIC_DIALOG_BUTTONFONT;
    
    return button;
}

+(void) CHECKForSize:(nonnull CGSize *) sizep  columnsp:(nonnull short *) columnsp rows:(nonnull short *) rows  width:(CGFloat) width attributeButtonNames:(nullable NSArray<NSAttributedString *> *) attributeButtonNames{

    if(attributeButtonNames == nil || attributeButtonNames.count == 0){
        *sizep = CGSizeMake(width, 0);
        *columnsp = 0;
        *rows = 0;
        return;
    }
    CGFloat tempw = 0;
    
    if(attributeButtonNames.count == 2){
        tempw = [PYUtile getBoundSizeWithAttributeTxt:attributeButtonNames.firstObject size:CGSizeMake(999, 10)].width;
        tempw = MAX(tempw, [PYUtile getBoundSizeWithAttributeTxt:attributeButtonNames.lastObject size:CGSizeMake(999, 10)].width);
        if(tempw < width/2){
            *sizep =  CGSizeMake(width, STATIC_POPUP_BUTTON_HEIGHT);
            *columnsp = 2;
            *rows = 1;
            return;
        }
    }
    
    for (NSAttributedString * attributeButtonName in attributeButtonNames) {
        tempw = MAX(tempw, [PYUtile getBoundSizeWithAttributeTxt:attributeButtonName size:CGSizeMake(999, 10)].width);
    }
    
    *sizep = CGSizeMake(width, STATIC_POPUP_BUTTON_HEIGHT * attributeButtonNames.count);
    *columnsp = 1;
    *rows = attributeButtonNames.count;
}

@end
