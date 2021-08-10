//
//  PYDialogMessageView.m
//  PYInterflow
//
//  Created by wlpiaoyi on 2016/12/8.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "PYDialogMessageView.h"
#import "PYInterflowParams.h"
#import "pyutilea.h"
NSInteger PYDMV_offsetValueNum;

@implementation PYDialogMessageView{
@private
    UILabel * messageLabel;
    UIView * contentView;
    UIScrollView * scrollView;
    NSLayoutConstraint * lcContentViewW;
}

-(instancetype) init{
    PYDMV_offsetValueNum = 6;
    if(self = [super init]){
        scrollView = [UIScrollView new];
        scrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:scrollView];
        [PYViewAutolayoutCenter persistConstraint:scrollView relationmargins:UIEdgeInsetsMake(0, 0, 0, 0) relationToItems:PYEdgeInsetsItemNull()];
        contentView = [UIView new];
        contentView.backgroundColor = [UIColor clearColor];
        [scrollView addSubview:contentView];
        [PYViewAutolayoutCenter persistConstraint:contentView relationmargins:UIEdgeInsetsMake(0, DisableConstrainsValueMAX, 0, DisableConstrainsValueMAX) relationToItems:PYEdgeInsetsItemNull()];
        [PYViewAutolayoutCenter persistConstraint:contentView centerPointer:CGPointMake(0, DisableConstrainsValueMAX)];
        lcContentViewW = [PYViewAutolayoutCenter persistConstraint:contentView size:CGSizeMake(0, DisableConstrainsValueMAX)].allValues.firstObject;
        UILabel * l = [UILabel new];
        l.numberOfLines = 0;
        [contentView addSubview:l];
        l.textAlignment = NSTextAlignmentLeft;
        l.backgroundColor = [UIColor clearColor];
        messageLabel = l;
        CGFloat value = xPYInterflowConfValue.dialog.offsetBorder;
        [PYViewAutolayoutCenter persistConstraint:messageLabel relationmargins:UIEdgeInsetsMake(xPYInterflowConfValue.dialog.offsetLine , value, value, value) relationToItems:PYEdgeInsetsItemNull()];
        self.backgroundColor = xPYInterflowConfValue.dialog.colorBg;
    }
    return self;
}
-(void) setDialogMessageTextAlignment:(NSTextAlignment)textAlignment{
    messageLabel.textAlignment = textAlignment;
}
-(void) setAttributeMessage:(NSAttributedString *)attributeMessage{
    _attributeMessage = attributeMessage;
    messageLabel.attributedText = attributeMessage;
    CGSize contentSize = [PYDialogMessageView getContentSize:attributeMessage];
    lcContentViewW.constant = contentSize.width;
    contentSize.width = 0;
    contentSize.height -= xPYInterflowConfValue.dialog.offsetLine + 1;
    scrollView.contentSize = contentSize;
}
+(CGSize) getContentSize:(nullable NSAttributedString *) attributeMessage{
    if(attributeMessage == nil || attributeMessage.length == 0){
        return CGSizeMake(0, 0);
    }
    CGFloat value = xPYInterflowConfValue.dialog.offsetBorder * 2;
    CGSize size = CGSizeMake(xPYInterflowConfValue.dialog.width - value, 9999);
    size = [PYUtile getBoundSizeWithAttributeTxt:attributeMessage size:size];
    size.width +=  1 + value;
    size.height +=  1 + xPYInterflowConfValue.dialog.offsetBorder  + xPYInterflowConfValue.dialog.offsetLine;
    return size;
}

+(CGSize) getSize:(nullable NSAttributedString *) attributeMessage{
    if(attributeMessage == nil || attributeMessage.length == 0){
        return CGSizeMake(0, xPYInterflowConfValue.dialog.minHeight);
    }
    CGSize size = [self getContentSize:attributeMessage];
    size.height = MAX(xPYInterflowConfValue.dialog.minHeight, MIN(size.height, xPYInterflowConfValue.dialog.maxHeight));
    return size;
}
@end
