//
//  PYDialogMessageView.m
//  PYInterflow
//
//  Created by wlpiaoyi on 2016/12/8.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "PYDialogMessageView.h"
#import "PYParams.h"
#import "pyutilea.h"

@implementation PYDialogMessageView{
@private
    UILabel * labelMessage;
    UIScrollView * scrollMessage;
}

-(instancetype) init{
    if(self = [super init]){
        UILabel * l = [UILabel new];
        l.numberOfLines = 0;
        [self addSubview:l];
        l.textAlignment = NSTextAlignmentCenter;
        l.backgroundColor = [UIColor clearColor];
        labelMessage = l;
        [PYViewAutolayoutCenter persistConstraint:l relationmargins:UIEdgeInsetsMake(STATIC_POPUP_OFFSETWIDTH, STATIC_POPUP_OFFSETWIDTH, STATIC_POPUP_OFFSETWIDTH, STATIC_POPUP_OFFSETWIDTH) relationToItems:PYEdgeInsetsItemNull()];
        self.backgroundColor = STATIC_DIALOG_BACKGROUNDCLOLOR;
    }
    return self;
}
-(void) setAttributeMessage:(NSAttributedString *)attributeMessage{
    _attributeMessage = attributeMessage;
    labelMessage.attributedText = attributeMessage;
}
+(CGSize) getSize:(nullable NSAttributedString *) attributeMessage{
    if(attributeMessage == nil || attributeMessage.length == 0){
        return CGSizeMake(0, 0);
    }
    CGSize size = CGSizeMake(STATIC_POPUP_WIDTH - STATIC_POPUP_OFFSETWIDTH * 2, 9999);
    size = [PYUtile getBoundSizeWithAttributeTxt:attributeMessage size:size];
    size.width += STATIC_POPUP_OFFSETWIDTH * 2;
    size.height += STATIC_POPUP_OFFSETWIDTH * 2 + 1;
    size.width = MAX(MIN(size.width, STATIC_DIALOG_MAXWIDTH), STATIC_DIALOG_MINWIDTH);
    size.height = MIN(size.height, STATIC_DIALOG_MAXHEIGHT);
    return size;
}
@end
