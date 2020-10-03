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
#import "PYPopupParam.h"

@implementation PYDialogTitleView{
@private
    UILabel * labelMessage;
}

-(instancetype) init{
    if(self = [super init]){
        UIView * titleView = [UIView new];
        titleView.backgroundColor = STATIC_DIALOG_BACKGROUNDC;
        UILabel * l = [UILabel new];
        l.numberOfLines = 1;
        [titleView addSubview:l];
        l.textAlignment = NSTextAlignmentCenter;
        l.backgroundColor = [UIColor clearColor];
        labelMessage = l;
        [l py_makeConstraints:^(PYConstraintMaker * _Nonnull make) {
            make.top.left.right.py_constant(STATIC_DIALOG_OFFSETBORDER);
            make.bottom.py_constant(0);
        }];
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:titleView];
        [titleView py_makeConstraints:^(PYConstraintMaker * _Nonnull make) {
            make.top.left.bottom.right.py_constant(0);
        }];
    }
    return self;
}

-(void) setAttributeTitle:(NSAttributedString *)attributeTitle{
    _attributeTitle = attributeTitle;
    labelMessage.attributedText = attributeTitle;
}

+(CGSize) getSize:(nullable NSAttributedString *) attributeTitle{
    CGSize size;
    if(attributeTitle == nil || attributeTitle.length == 0){
        size = CGSizeMake(STATIC_DIALOG_MINWIDTH, STATIC_DIALOG_OFFSETBORDER);
    }else{
        size = CGSizeMake(999, 0);
        size = [PYUtile getBoundSizeWithAttributeTxt:attributeTitle size:size];
        size.height += STATIC_DIALOG_OFFSETBORDER;
    }
    size.width = MIN(MAX(STATIC_DIALOG_MINWIDTH, size.width), STATIC_DIALOG_MAXWIDTH);
    return size;
}


@end
