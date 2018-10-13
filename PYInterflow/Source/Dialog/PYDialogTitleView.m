//
//  PYDialogTitleView.m
//  PYInterflow
//
//  Created by wlpiaoyi on 2016/12/8.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "PYDialogTitleView.h"
#import "PYInterflowParams.h"
#import "pyutilea.h"

@implementation PYDialogTitleView{
@private
    UILabel * labelMessage;
    NSLayoutConstraint * lcLineH;
    NSArray<NSLayoutConstraint *> * lcsOffV;
}

-(instancetype) init{
    if(self = [super init]){
        UILabel * l = [UILabel new];
        l.numberOfLines = 1;
        [self addSubview:l];
        l.textAlignment = NSTextAlignmentCenter;
        l.backgroundColor = [UIColor clearColor];
        labelMessage = l;
        NSDictionary * dict = [PYViewAutolayoutCenter persistConstraint:l relationmargins:UIEdgeInsetsMake(STATIC_POPUP_OFFSETWIDTH, STATIC_POPUP_OFFSETWIDTH, STATIC_POPUP_OFFSETWIDTH, STATIC_POPUP_OFFSETWIDTH) relationToItems:PYEdgeInsetsItemNull()];
        lcsOffV = dict.allValues;
        self.backgroundColor = STATIC_DIALOG_BACKGROUNDCLOLOR;
        UIView * line = [UIView new];
        line.backgroundColor = STATIC_DIALOG_BORDERCLOLOR;
        [self addSubview: line];
        lcLineH = [PYViewAutolayoutCenter persistConstraint:line size:CGSizeMake(DisableConstrainsValueMAX, .5)].allValues.firstObject;
        [PYViewAutolayoutCenter persistConstraint:line relationmargins:UIEdgeInsetsMake(DisableConstrainsValueMAX, 0, 0, 0) relationToItems:PYEdgeInsetsItemNull()];
    }
    return self;
}

-(void) setAttributeTitle:(NSAttributedString *)attributeTitle{
    _attributeTitle = attributeTitle;
    labelMessage.attributedText = attributeTitle;
    CGFloat offv;
    CGFloat lineH;
    if([PYDialogTitleView getSize:attributeTitle].height == 0){
        offv = 0;
        lineH = 0;
    }else{
        offv = STATIC_POPUP_OFFSETWIDTH;
        lineH = .5;
    }
    lcsOffV[0].constant = lcsOffV[3].constant = -offv;
    lcsOffV[1].constant = lcsOffV[2].constant = offv;
    lcLineH.constant = lineH;
}

+(CGSize) getSize:(nullable NSAttributedString *) attributeTitle{
    CGSize size;
    if(attributeTitle == nil || attributeTitle.length == 0){
        size = CGSizeMake(STATIC_DIALOG_MINWIDTH, 0);
    }else{
        size = CGSizeMake(999, STATIC_POPUP_TITLE_HEIGHT);
        size = [PYUtile getBoundSizeWithAttributeTxt:attributeTitle size:size];
        size.height = STATIC_POPUP_TITLE_HEIGHT;
    }
    size.width = MIN(MAX(STATIC_DIALOG_MINWIDTH, size.width), STATIC_DIALOG_MAXWIDTH);
    return size;
}


@end
