//
//  PYSheetItemCell.h
//  PYInterflow
//
//  Created by wlpiaoyi on 2019/2/8.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//


#import "pyutilea.h"


@interface PYSheetItemCell : UITableViewCell
kPNA BOOL isSelected;
kPNSNN NSAttributedString * item;
+(CGFloat) getHeight:(nonnull NSAttributedString *) item width:(CGFloat) width;
@end
