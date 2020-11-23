//
//  PYShutdownItemCell.m
//  PYInterflow
//
//  Created by wlpiaoyi on 2020/11/22.
//  Copyright © 2020 wlpiaoyi. All rights reserved.
//

#import "PYShutdownItemCell.h"

@implementation PYShutdownItemCell{
    __weak IBOutlet UILabel *labelItem;
    __weak IBOutlet UIImageView *imageTag;
    UIColor * colorNormal;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    colorNormal = labelItem.textColor;
}

-(void) setItem:(NSString *)item{
    _item = item;
    labelItem.text = item;
}
-(void) setIsSelectedItem:(BOOL)isSelectedItem{
    _isSelectedItem = isSelectedItem;
    imageTag.hidden = !_isSelectedItem;
    labelItem.textColor = _isSelectedItem ? colorNormal : [UIColor darkGrayColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+(CGFloat) getHeight{
    return 50.;
}

@end
