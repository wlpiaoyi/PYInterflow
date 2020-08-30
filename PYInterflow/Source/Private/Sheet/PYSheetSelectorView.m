//
//  PYSheetSelectorView.m
//  PYInterflow
//
//  Created by wlpiaoyi on 2019/2/8.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import "PYSheetSelectorView.h"
#import "PYInterflowParams.h"
#import "PYSheetItemsView.h"
#import "PYSheetItemCell.h"
#import "PYPopupParam.h"
#import "UIImage+PYExpand.h"
#import "UIColor+PYExpand.h"

@interface PYSheetSelectorView()
kSOULDLAYOUTPForType(PYSheetSelectorView);
@end

@implementation PYSheetSelectorView{
    NSAttributedString * _title;
    PYSheetItemsView * itemsViewSelector;
    PYSheetItemsView * itemsViewOption;
    __unsafe_unretained IBOutlet UIView *viewTitle;
    __unsafe_unretained IBOutlet UILabel *labelTitle;
    __unsafe_unretained IBOutlet UIView *viewSelector;
    __unsafe_unretained IBOutlet UIView *viewOption;
    
    __unsafe_unretained IBOutlet NSLayoutConstraint *lcTitleH;
    __unsafe_unretained IBOutlet NSLayoutConstraint *lcOptionH;
    __unsafe_unretained IBOutlet NSLayoutConstraint *lcOptionTop;
    __weak IBOutlet NSLayoutConstraint *lcOptionBtm;
}

+(nullable instancetype) instanceWithTitle:(nullable NSAttributedString *) title
                                items:(nonnull NSArray<NSAttributedString *> *) items
                                selectes:(nullable NSArray<NSNumber *> *) selectes
                                options:(nullable NSArray<NSAttributedString *> *) options
                                multipleSelected:(BOOL) multipleSelected{
    PYSheetSelectorView * owner = [STATIC_INTERFLOW_BUNDEL loadNibNamed:NSStringFromClass(self) owner:self options:nil].lastObject;
    owner->_title = title;
    owner->_items = items;
    owner.selectes = selectes;
    owner->_options = options;
    owner->_multipleSelected = multipleSelected;
    owner->itemsViewSelector = [PYSheetItemsView instanceWithItems:owner->_items selectes:owner.selectes multipleSelected:owner->_multipleSelected];
    
    PYEdgeInsetsItem eii = PYEdgeInsetsItemNull();
    if(owner->_title && owner->_title.length){
        owner->labelTitle.attributedText = owner->_title;
        owner->viewTitle.hidden = NO;

        UIImageView * imageLine = [[UIImageView alloc] initWithImage:STATIC_SHEET_IMAGE_LINE];
        imageLine.backgroundColor = STATIC_SHEET_BACKGROUNDC;
        imageLine.contentMode = UIViewContentModeScaleToFill;
        [owner->viewSelector addSubview: imageLine];
        [imageLine py_makeConstraints:^(PYConstraintMaker * _Nonnull make) {
            make.top.py_toItem(owner->viewTitle).py_constant(0);
            make.left.right.py_constant(0);
            make.height.py_constant(1);
        }];
//        [PYViewAutolayoutCenter persistConstraint:line size:CGSizeMake(DisableConstrainsValueMAX, STATIC_POPUP_BORDERWIDTH)];
//        [PYViewAutolayoutCenter persistConstraint:line relationmargins:UIEdgeInsetsMake(0, 0, DisableConstrainsValueMAX, 0) relationToItems:PYEdgeInsetsItemMake((__bridge void * _Nullable)(owner->viewTitle), nil, nil, nil)];
        eii.top = (__bridge void * _Nullable)(imageLine);
    }else{
        owner->viewTitle.hidden = YES;
    }
    [owner->viewSelector setCornerRadiusAndBorder:5 borderWidth:0 borderColor:nil];
    if(owner->_options && owner->_options.count){
        owner->itemsViewOption = [PYSheetItemsView instanceWithItems:owner->_options selectes:@[] multipleSelected:NO];
        [owner->viewOption setCornerRadiusAndBorder:5 borderWidth:0 borderColor:nil];
        owner->itemsViewOption.scrollEnabled = NO;
    }
    [owner->viewSelector addSubview:owner->itemsViewSelector];
    [PYViewAutolayoutCenter persistConstraint:owner->itemsViewSelector relationmargins:UIEdgeInsetsZero relationToItems:eii];
    if(owner->itemsViewOption){
        [owner->viewOption addSubview:owner->itemsViewOption];
        [PYViewAutolayoutCenter persistConstraint:owner->itemsViewOption relationmargins:UIEdgeInsetsZero relationToItems:PYEdgeInsetsItemNull()];
        owner->lcOptionBtm.constant = 10;
    }else{
        owner->lcOptionBtm.constant = 0;
    }

    return owner;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    viewTitle.backgroundColor = STATIC_SHEET_BACKGROUNDC;
}

//-(void) setBlockSelectedItems:(BOOL (^)(PYSheetSelectorView * _Nonnull))blockSelectedItems{
//    _blockSelectedItems = blockSelectedItems;
//    kAssign(self);
//    itemsViewSelector.blockAfterSelectedItems = ^(PYSheetItemsView * _Nonnull contextView) {
//        kStrong(self);
//        self.selectes = contextView.selectes;
//        if(self.blockSelectedItems) self.blockSelectedItems(self);
//    };
//}
//
-(void) setBlockSelectedOptions:(void (^)(PYSheetSelectorView * _Nonnull, NSUInteger))blockSelectedOptions{
    _blockSelectedOptions = blockSelectedOptions;
    kAssign(self);
    itemsViewOption.blockSelecting = ^BOOL(BOOL isSelected, NSUInteger cureentIndex) {
        kStrong(self);
        if(!isSelected) return NO;
        if(blockSelectedOptions)blockSelectedOptions(self, cureentIndex);
        return YES;
    };
}
-(void) setBlockSelecting:(BOOL (^)(BOOL, NSUInteger))blockSelecting{
    _blockSelecting = blockSelecting;
    itemsViewSelector.blockSelecting = blockSelecting;
}

-(void) setSelectes:(NSArray<NSNumber *> *)selectes{
    itemsViewSelector.selectes = [selectes isKindOfClass:[NSMutableArray class]] ? selectes : [selectes mutableCopy];;;
}

-(NSArray<NSNumber *> *)selectes{
    return itemsViewSelector.selectes;
}
-(void) synFrame{
    CGFloat width = self.frameWidth;
    if(width <= 0) return;
    
    CGFloat height = 0;
    if(_title && _title.length){
        lcTitleH.constant = [PYUtile getBoundSizeWithAttributeTxt:_title size:CGSizeMake(width - 40, 999)].height + 21 + STATIC_POPUP_BORDERWIDTH;
    }
    lcOptionH.constant = [PYSheetItemsView getHeight:width items:_options];
    height += lcTitleH.constant;
    height += lcOptionTop.constant;
    height += lcOptionBtm.constant;
    height += lcOptionH.constant;
    CGFloat value = 0;
    if (@available(iOS 11.0, *)) {
        UIEdgeInsets safeAreaInsets = [UIApplication sharedApplication].keyWindow.safeAreaInsets;
        value = boundsHeight() - safeAreaInsets.top - safeAreaInsets.bottom;
    } else {
        value = boundsHeight();
    }
    BOOL scorllEnable = NO;
    for (NSAttributedString * item in _items) {
        CGFloat v = [PYSheetItemCell getHeight:item width:self->itemsViewSelector.frameWidth];
        height += v;
        if(height > value){
            height -= v;
            scorllEnable = YES;
            break;
        }
    }
    itemsViewSelector.scrollEnabled = scorllEnable;
    
    self.frameHeight = height - 2;
    
}

kSOULDLAYOUTMSTARTForType(PYSheetSelectorView)
kSOULDLAYOUTMEND



@end
