//
//  PYSheetItemCell.m
//  PYInterflow
//
//  Created by wlpiaoyi on 2019/2/8.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import "PYSheetItemCell.h"
#import "PYInterflowParams.h"

@implementation PYSheetItemCell{
    __weak IBOutlet UILabel *labelItems;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectedBackgroundView = [UIView new];
    self.selectedBackgroundView.backgroundColor = STATIC_POPUP_HIGHLIGHTC;
    self.isSelected = NO;
    
}

-(void) setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    if(self.highlighted){
        self.backgroundColor = STATIC_SHEET_BACKGROUNDH;
    }else{
        self.backgroundColor = isSelected ? STATIC_SHEET_ITEMSElECTEDC : STATIC_SHEET_BACKGROUNDC;
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
