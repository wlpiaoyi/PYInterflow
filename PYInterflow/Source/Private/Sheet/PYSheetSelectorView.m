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
    __weak IBOutlet NSLayoutConstraint *lcLineH;
}

+(nullable instancetype) instanceWithTitle:(nullable NSAttributedString *) title
                                items:(nonnull NSArray<NSAttributedString *> *) items
                                selectes:(nullable NSArray<NSNumber *> *) selectes
                                options:(nullable NSArray<NSAttributedString *> *) options
                                multipleSelected:(BOOL) multipleSelected{
    PYSheetSelectorView * owner = [STATIC_INTERFLOW_BUNDEL loadNibNamed:NSStringFromClass(self) owner:self options:nil].lastObject;
    owner->_title = title;
    owner->_items = items;
    owner->_selectes = selectes;
    owner->_options = options;
    owner->_multipleSelected = multipleSelected;
    owner->itemsViewSelector = [PYSheetItemsView instanceWithItems:owner->_items selectes:owner->_selectes multipleSelected:owner->_multipleSelected];
    
    PYEdgeInsetsItem eii = PYEdgeInsetsItemNull();
    if(owner->_title && owner->_title.length){
        owner->labelTitle.attributedText = owner->_title;
        owner->viewTitle.hidden = NO;
        UIView * line =  [[UIImageView alloc] initWithImage:[PYPopupParam IMAGE_BOTTOM_LINE]];
        line.backgroundColor = [UIColor clearColor];
        [owner->viewSelector addSubview: line];
        [PYViewAutolayoutCenter persistConstraint:line size:CGSizeMake(DisableConstrainsValueMAX, STATIC_POPUP_BORDERWIDTH)];
        [PYViewAutolayoutCenter persistConstraint:line relationmargins:UIEdgeInsetsMake(0, 0, DisableConstrainsValueMAX, 0) relationToItems:PYEdgeInsetsItemMake((__bridge void * _Nullable)(owner->viewTitle), nil, nil, nil)];
        eii.top = (__bridge void * _Nullable)(line);
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
        owner->lcOptionTop.constant = 10;
        owner->lcOptionBtm.constant = 10;
    }else{
        owner-> lcOptionTop.constant = 0;
        owner->lcOptionBtm.constant = 0;
    }

    return owner;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    lcLineH.constant = STATIC_POPUP_BORDERWIDTH;
    viewTitle.backgroundColor = STATIC_SHEET_BACKGROUNDC;
}

-(void) setBlockSelectedItems:(BOOL (^)(PYSheetSelectorView * _Nonnull))blockSelectedItems{
    _blockSelectedItems = blockSelectedItems;
    kAssign(self);
    itemsViewSelector.blockAfterSelectedItems = ^(PYSheetItemsView * _Nonnull contextView) {
        kStrong(self);
        self.selectes = contextView.selectes;
        if(self.blockSelectedItems) self.blockSelectedItems(self);
    };
}

-(void) setBlockSelectedOptions:(void (^)(PYSheetSelectorView * _Nonnull, NSUInteger))blockSelectedOptions{
    _blockSelectedOptions = blockSelectedOptions;
    kAssign(self);
    itemsViewOption.blockAfterSelectedItems = ^(PYSheetItemsView * _Nonnull contextView) {
        kStrong(self);
        self.selectes = self->itemsViewSelector.selectes;
        if(self.blockSelectedOptions) self.blockSelectedOptions(self, contextView.selectes.firstObject.integerValue);
    };
}
-(void) setBlockOnSelecting:(BOOL (^)(NSMutableArray<NSNumber *> * _Nonnull, NSUInteger))blockOnSelecting{
    _blockOnSelecting = blockOnSelecting;
    itemsViewSelector.blockOnSelecting = blockOnSelecting;
}

-(void) setSelectes:(NSArray<NSNumber *> *)selectes{
    _selectes = selectes;
    itemsViewSelector.selectes = _selectes;
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
        UIEdgeInsets safeAreaInsets = [UIApplication sharedApplication].delegate.window.safeAreaInsets;
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
