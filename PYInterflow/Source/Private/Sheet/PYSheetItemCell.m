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
    self.selectedBackgroundView.backgroundColor = STATIC_POPUP_HIGHLIGHTC;
    self.isSelected = NO;

    imageLine.image = STATIC_SHEET_IMAGE_LINE;
    imageLine.contentMode = UIViewContentModeScaleToFill;
    imageLine.backgroundColor = STATIC_SHEET_BACKGROUNDC;
    
}

-(void) setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    if(self.highlighted){
        viewbg.backgroundColor = STATIC_SHEET_BACKGROUNDH;
    }else{
        viewbg.backgroundColor = isSelected ? STATIC_SHEET_ITEMSElECTEDC : STATIC_SHEET_BACKGROUNDC;
    }
}
-(void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    self.isSelected = _isSelected;
}

-(void) setItem:(NSAttributedString *)item{
    _item = item;
    labelItems.attributedText = item;
}

+(CGFloat) getHeight:(nonnull NSAttributedString *) item width:(CGFloat) width{
    return [PYUtile getBoundSizeWithAttributeTxt:item size:CGSizeMake(width + 20, 999)].height + 20 + 10;
}

@end
