//
//  PYDialogTitleView.m
//  PYInterflow
//
//  Created by wlpiaoyi on 2016/12/8.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "PYDialogTitleView.h"
#import "PYParams.h"
#import "pyutilea.h"

@implementation PYDialogTitleView{
@private
    UILabel * labelMessage;
}

-(instancetype) init{
    if(self = [super init]){
        UILabel * l = [UILabel new];
        l.numberOfLines = 1;
        [self addSubview:l];
        l.textAlignment = NSTextAlignmentCenter;
        l.backgroundColor = [UIColor clearColor];
        labelMessage = l;
        [PYViewAutolayoutCenter persistConstraint:l relationmargins:UIEdgeInsetsMake(STATIC_POPUP_OFFSETWIDTH, STATIC_POPUP_OFFSETWIDTH, STATIC_POPUP_OFFSETWIDTH, STATIC_POPUP_OFFSETWIDTH) relationToItems:PYEdgeInsetsItemNull()];
        self.backgroundColor = STATIC_DIALOG_BACKGROUNDCLOLOR;
        UIView * line = [UIView new];
        line.backgroundColor = STATIC_DIALOG_BORDERCLOLOR;
        [self addSubview: line];
        [PYViewAutolayoutCenter persistConstraint:line size:CGSizeMake(DisableConstrainsValueMAX, .5)];
        [PYViewAutolayoutCenter persistConstraint:line relationmargins:UIEdgeInsetsMake(DisableConstrainsValueMAX, 0, 0, 0) relationToItems:PYEdgeInsetsItemNull()];
    }
    return self;
}

-(void) setAttributeTitle:(NSAttributedString *)attributeTitle{
    _attributeTitle = attributeTitle;
    labelMessage.attributedText = attributeTitle;
}

+(CGSize) getSize:(nullable NSAttributedString *) attributeTitle{
    if(attributeTitle == nil || attributeTitle.length == 0){
        return CGSizeMake(0, 0);
    }
    CGSize size = CGSizeMake(999, STATIC_POPUP_TITLE_HEIGHT);
    size = [PYUtile getBoundSizeWithAttributeTxt:attributeTitle size:size];
    size.height = STATIC_POPUP_TITLE_HEIGHT;
    size.width = MIN(size.width, STATIC_POPUP_WIDTH);
    return size;
}


@end
