//
//  PYSheetContextView.m
//  PYInterflow
//
//  Created by wlpiaoyi on 2019/2/8.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import "PYSheetContextView.h"
#import "PYInterflowParams.h"
#import "PYSheetItemsView.h"

@interface PYSheetContextView()
kSOULDLAYOUTPForType(PYSheetContextView);
@end

@implementation PYSheetContextView{
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
    PYSheetContextView * owner = [STATIC_INTERFLOW_BUNDEL loadNibNamed:NSStringFromClass(self) owner:self options:nil].lastObject;
    owner->_title = title;
    owner->_items = items;
    owner->_selectes = selectes;
    owner->_options = options;
    owner->_multipleSelected = multipleSelected;
    owner->itemsViewSelector = [PYSheetItemsView instanceWithItems:owner->_items selectes:owner->_selectes multipleSelected:owner->_multipleSelected];
    [owner->viewSelector setCornerRadiusAndBorder:5 borderWidth:0 borderColor:nil];
    if(owner->_options && owner->_options.count){
        owner->itemsViewOption = [PYSheetItemsView instanceWithItems:owner->_options selectes:nil multipleSelected:NO];
        [owner->viewOption setCornerRadiusAndBorder:5 borderWidth:0 borderColor:nil];
        owner->itemsViewOption.scrollEnabled = NO;
    }
    PYEdgeInsetsItem eii = PYEdgeInsetsItemNull();
    if(owner->_title && owner->_title.length){
        eii.top = (__bridge void * _Nullable)(owner->viewTitle);
        owner->labelTitle.attributedText = owner->_title;
        owner->viewTitle.hidden = NO;
    }else{
        owner->viewTitle.hidden = YES;
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
}

-(void) setBlockSelectedItems:(BOOL (^)(PYSheetContextView * _Nonnull))blockSelectedItems{
    _blockSelectedItems = blockSelectedItems;
    kAssign(self);
    itemsViewSelector.blockAfterSelectedItems = ^(PYSheetItemsView * _Nonnull contextView) {
        kStrong(self);
        self.selectes = contextView.selectes;
        if(self.blockSelectedItems) self.blockSelectedItems(self);
    };
}

-(void) setBlockSelectedOptions:(void (^)(PYSheetContextView * _Nonnull))blockSelectedOptions{
    _blockSelectedOptions = blockSelectedOptions;
    kAssign(self);
    itemsViewOption.blockAfterSelectedItems = ^(PYSheetItemsView * _Nonnull contextView) {
        kStrong(self);
        self.selectes = self->itemsViewSelector.selectes;
        if(self.blockSelectedOptions) self.blockSelectedOptions(self);
    };
}

-(void) setSelectes:(NSArray<NSNumber *> *)selectes{
    _selectes = selectes;
    itemsViewSelector.selectes = selectes;
}

-(void) synFrame{
    CGFloat width = self.frameWidth;
    if(width <= 0) return;
    
    CGFloat height = 0;
    if(_title && _title.length){
        lcTitleH.constant = [PYUtile getBoundSizeWithAttributeTxt:_title size:CGSizeMake(width - 40, 999)].height + 21;
    }
    height += [PYSheetItemsView getHeight:width items:_items];
    lcOptionH.constant = [PYSheetItemsView getHeight:width items:_options];
    height += lcTitleH.constant;
    height += lcOptionTop.constant;
    height += lcOptionBtm.constant;
    height += lcOptionH.constant;
    self.frameHeight = height;
}

kSOULDLAYOUTMSTARTForType(PYSheetContextView)
kSOULDLAYOUTMEND



@end
