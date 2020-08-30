//
//  PYDialogButtonView.m
//  PYInterflow
//
//  Created by wlpiaoyi on 2016/12/8.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "PYDialogButtonView.h"
#import "pyutilea.h"
#import "PYInterflowParams.h"
#import "PYPopupParam.h"
@interface PYDialogButtonView()
@property (nonatomic, assign, nonnull) id target;
@property (nonatomic, nonnull) SEL action;
@property (nonatomic, copy, nullable) void (^blockSetButtonLayout)(UIButton * _Nonnull button);
@end

@implementation PYDialogButtonView{
@private
    NSMutableArray<NSLayoutConstraint *> * lcs;
//    UIView * topLine;
}
-(nullable instancetype) initWithTarget:(nonnull id) target action:(nonnull SEL) action blockSetButtonLayout:(void (^_Nonnull)(UIButton * _Nonnull button)) blockSetButtonLayout{
    if(self = [super init]){
        lcs = [NSMutableArray new];
        self.backgroundColor = [UIColor clearColor];
        self.target = target;
        self.action = action;
        self.blockSetButtonLayout = blockSetButtonLayout;
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
    
    CGSize frameSize;
    short columns,rows;
    [PYDialogButtonView CHECKForSize:&frameSize columnsp:&columns rows:&rows width:self.targetWith attributeButtonNames:self.normalButtonNames];
    self.frameSize = frameSize;
    
    NSMutableArray<UIView *> * buttons = [NSMutableArray new];
    int index = 0;
    for (NSAttributedString * normalButtonName in self.normalButtonNames) {
        UIButton *button = [PYDialogButtonView createButtonWithNormalName:normalButtonName hightLightedName:self.hightLightedButtonNames[index]];
        button.tag = index;
        [button addTarget:self.target action:self.action forControlEvents:UIControlEventTouchUpInside];
        UIView * bView = [UIView new];
        bView.backgroundColor = [UIColor clearColor];
        bView.tag = index ++;
        [bView addSubview:button];
        if(self.blockSetButtonLayout){
            _blockSetButtonLayout(button);
        }else{
            [PYViewAutolayoutCenter persistConstraint:button relationmargins:UIEdgeInsetsMake(0, 0, 0, 0) relationToItems:PYEdgeInsetsItemNull()];
        }
        [self addSubview:bView];
        [buttons addObject:bView];
    }
    
    if(columns == 2){
        UIView *  line = [[UIImageView alloc] initWithImage:[PYPopupParam IMAGE_BOTTOM_LINE]];
        line.backgroundColor = [UIColor clearColor];
        [self addSubview:line];
        [PYViewAutolayoutCenter persistConstraint:line size:CGSizeMake(DisableConstrainsValueMAX, STATIC_POPUP_BORDERWIDTH)];
        [PYViewAutolayoutCenter persistConstraint:line relationmargins:UIEdgeInsetsMake(0, 0, DisableConstrainsValueMAX, 0) relationToItems:PYEdgeInsetsItemNull()];
        UIView * lineCenter = [[UIImageView alloc] initWithImage:[PYPopupParam IMAGE_CET_LINE]];
        lineCenter.backgroundColor = [UIColor clearColor];
        lineCenter.hidden = self.blockSetButtonLayout != nil;
        [self addSubview:lineCenter];
        [lcs addObjectsFromArray:[PYViewAutolayoutCenter persistConstraint:lineCenter size:CGSizeMake(STATIC_POPUP_BORDERWIDTH, DisableConstrainsValueMAX)].allValues];
        [lcs addObjectsFromArray:[PYViewAutolayoutCenter persistConstraint:lineCenter centerPointer:CGPointMake(0, DisableConstrainsValueMAX)].allValues];
        PYEdgeInsetsItem eii =  PYEdgeInsetsItemNull();
        eii.top = (__bridge void * _Nullable)(line);
        [lcs addObjectsFromArray:[PYViewAutolayoutCenter persistConstraint:lineCenter relationmargins:UIEdgeInsetsMake(1, DisableConstrainsValueMAX, 0, DisableConstrainsValueMAX) relationToItems:eii].allValues];
        eii = PYEdgeInsetsItemNull();
        eii.top = (__bridge void * _Nullable)(line);
        eii.right = (__bridge void * _Nullable)(lineCenter);
        [PYViewAutolayoutCenter persistConstraint:buttons.firstObject relationmargins:UIEdgeInsetsZero relationToItems:eii];
        eii = PYEdgeInsetsItemNull();
        eii.top = (__bridge void * _Nullable)(line);
        eii.left = (__bridge void * _Nullable)(lineCenter);
        [PYViewAutolayoutCenter persistConstraint:buttons.lastObject relationmargins:UIEdgeInsetsZero relationToItems:eii];
    }else{
        void * preView = nil;
        for (UIView * vBtn in buttons) {
            UIView *  line = [[UIImageView alloc] initWithImage:[PYPopupParam IMAGE_BOTTOM_LINE]];
            line.backgroundColor = [UIColor clearColor];
            [self addSubview:line];
            PYEdgeInsetsItem eii = PYEdgeInsetsItemNull();
            eii.top = preView;
            preView = (__bridge void * _Nullable)(vBtn);
            [PYViewAutolayoutCenter persistConstraint:line size:CGSizeMake(DisableConstrainsValueMAX, STATIC_POPUP_BORDERWIDTH)];
            [PYViewAutolayoutCenter persistConstraint:line relationmargins:UIEdgeInsetsMake(0, 0, DisableConstrainsValueMAX, 0) relationToItems:eii];
            eii.top = (__bridge void * _Nullable)(line);
            [PYViewAutolayoutCenter persistConstraint:vBtn size:CGSizeMake(DisableConstrainsValueMAX, STATIC_DIALOG_BUTTON_HEIGHT)];
            [PYViewAutolayoutCenter persistConstraint:vBtn relationmargins:UIEdgeInsetsMake(0, 0, DisableConstrainsValueMAX, 0) relationToItems:eii];
        }
    }
    
    return self.frameSize;
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
    [button setTitleColor:STATIC_DIALOG_BACKGROUNDC forState:UIControlStateHighlighted];
    button.backgroundColor = STATIC_DIALOG_BACKGROUNDC;
//    [button setBackgroundImage:[UIImage imageWithColor:STATIC_DIALOG_BACKGROUNDC] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:STATIC_POPUP_HIGHLIGHTC] forState:UIControlStateHighlighted];
    button.titleLabel.font = STATIC_DIALOG_BUTTONFONT;
//    button.backgroundColor = [UIColor clearColor];
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
            *sizep =  CGSizeMake(width, STATIC_DIALOG_BUTTON_HEIGHT + STATIC_POPUP_BORDERWIDTH);
            *columnsp = 2;
            *rows = 1;
            return;
        }
    }
    
    for (NSAttributedString * attributeButtonName in attributeButtonNames) {
        tempw = MAX(tempw, [PYUtile getBoundSizeWithAttributeTxt:attributeButtonName size:CGSizeMake(999, 10)].width);
    }
    
    *columnsp = 1;
    *rows = attributeButtonNames.count;
    *sizep = CGSizeMake(width, STATIC_DIALOG_BUTTON_HEIGHT * attributeButtonNames.count + (*rows) * STATIC_POPUP_BORDERWIDTH);
}

@end
