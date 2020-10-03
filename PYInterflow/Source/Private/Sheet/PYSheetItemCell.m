//
//  PYSheetItemCell.m
//  PYInterflow
//
//  Created by wlpiaoyi on 2019/2/8.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import "PYSheetItemCell.h"
#import "PYInterflowParams.h"
#import "UIColor+PYExpand.h"

@implementation PYSheetItemCell{
    __weak IBOutlet UIImageView *imageLine;
    __weak IBOutlet UIView *viewbg;
    __weak IBOutlet UILabel *labelItems;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectedBackgroundView = [UIView new];
    self.selectedBackgroundView.backgroundColor = xPYInterflowConfValue.popup.colorHighlightBg;
    self.isSelected = NO;

    imageLine.image = STATIC_SHEET_IMAGE_LINE;
    imageLine.contentMode = UIViewContentModeScaleToFill;
    imageLine.backgroundColor = [UIColor clearColor];
    
}

-(void) setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    viewbg.backgroundColor = isSelected ? STATIC_SHEET_ITEMSElECTEDC : STATIC_SHEET_BACKGROUNDC;
    self.contentView.backgroundColor = self.backgroundColor = viewbg.backgroundColor;
}

-(void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if(highlighted){
        NSMutableAttributedString * attributedText = labelItems.attributedText.mutableCopy;
               [attributedText setAttributes:@{NSForegroundColorAttributeName:xPYInterflowConfValue.popup.colorHighlightTxt} range:NSMakeRange(0, attributedText.length)];
        labelItems.attributedText = attributedText;
        viewbg.backgroundColor =   xPYInterflowConfValue.popup.colorHighlightBg;
        self.contentView.backgroundColor = self.backgroundColor = viewbg.backgroundColor;
    }else{
        labelItems.attributedText = _item;
        self.isSelected = self.isSelected;
    }
//    if(highlighted){
       
//    }else{
//
//    }
    
}

-(void) setItem:(NSAttributedString *)item{
    _item = item;
    labelItems.attributedText = item;
}

+(CGFloat) getHeight:(nonnull NSAttributedString *) item width:(CGFloat) width{
    return [PYUtile getBoundSizeWithAttributeTxt:item size:CGSizeMake(width + 20, 999)].height + 20 + 10;
}

@end
