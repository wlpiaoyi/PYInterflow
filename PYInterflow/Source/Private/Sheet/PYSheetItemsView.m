//
//  PYSheetItemsView.m
//  PYInterflow
//
//  Created by wlpiaoyi on 2019/2/8.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import "PYSheetItemsView.h"
#import "PYInterflowParams.h"
#import "PYSheetItemCell.h"

NSString * kPYSheetItemCell = @"PYSheetItemCell";
UIColor * kPYSheetItemSelectedColor;

@implementation PYSheetItemsView{
    __weak IBOutlet UITableView * _tableView;
    __weak UIVisualEffectView * _effectView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [_tableView registerNib:[UINib nibWithNibName:kPYSheetItemCell bundle:STATIC_INTERFLOW_BUNDEL] forCellReuseIdentifier:kPYSheetItemCell];
    self.scrollEnabled = YES;
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
//    [effectView setCornerRadiusAndBorder:10 borderWidth:.5 borderColor:[UIColor clearColor]];
    [self addSubview:effectView];
    [effectView py_makeConstraints:^(PYConstraintMaker * _Nonnull make) {
        make.top.left.bottom.right.py_constant(-1);
    }];
    [effectView.superview sendSubviewToBack:effectView];
    _effectView = effectView;
}
-(void) setScrollEnabled:(BOOL)scrollEnabled{
    _scrollEnabled = scrollEnabled;
    _tableView.scrollEnabled = scrollEnabled;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.y < 0){
        [_effectView py_getAutolayoutRelationTop].constant = -scrollView.contentOffset.y;
        [_effectView py_getAutolayoutRelationBottom].constant = 0;
        return;
    }
    [_effectView py_getAutolayoutRelationTop].constant = 0;
    if(scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frameHeight){
        [_effectView py_getAutolayoutRelationBottom].constant = -scrollView.contentOffset.y + (scrollView.contentSize.height - scrollView.frameHeight);
    }else{
            [_effectView py_getAutolayoutRelationBottom].constant = 0;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [PYSheetItemCell getHeight:self.items[indexPath.row] width:tableView.frameWidth];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PYSheetItemCell *cell = [tableView dequeueReusableCellWithIdentifier:kPYSheetItemCell forIndexPath:indexPath];
    cell.item = self.items[indexPath.row];
    cell.isSelected = (self.selectes && [self.selectes containsObject:@(indexPath.row)]);
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSNumber * select = @(indexPath.row);
    BOOL isSelected = [self.selectes containsObject:select];
    if(_blockSelecting){
        if(!_blockSelecting(!isSelected, indexPath.row)){
            [tableView reloadData];
            return;
        }
    }
    if(self.multipleSelected){
        if(isSelected){
            [((NSMutableArray *)self.selectes) removeObject:select];
        }else{
            [((NSMutableArray *)self.selectes) addObject:select];
        }
    }else{
        [((NSMutableArray *)self.selectes) removeAllObjects];
        [((NSMutableArray *)self.selectes) addObject:select];
    }
    PYSheetItemCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    cell.isSelected = self.selectes && [self.selectes containsObject:@(select.intValue)];
}

-(void) setSelectes:(NSArray<NSNumber *> * _Nullable)selectes{
    _selectes = selectes;
    [_tableView reloadData];
}
+(nullable instancetype) instanceWithItems:(nonnull NSArray<NSAttributedString *> *) items
                                selectes:(nullable NSArray<NSNumber *> *) selectes
                                multipleSelected:(BOOL) multipleSelected{
//    colorWithHexNumber
    kPYSheetItemSelectedColor = [UIColor colorWithHexNumber:0x00000033];
    PYSheetItemsView * owner = [STATIC_INTERFLOW_BUNDEL loadNibNamed:NSStringFromClass(self) owner:self options:nil].lastObject;
    owner->_items = items;
    owner->_multipleSelected = multipleSelected;
    owner.selectes = [selectes mutableCopy];
    return owner;
}

+(CGFloat) getHeight:(CGFloat) width items:(nonnull NSArray<NSAttributedString *> *) items{
    CGFloat height = 0.0;
    for (NSAttributedString * item in items){
        height += [PYSheetItemCell getHeight:item width:width];
    }
    return height - xPYInterflowConfValue.popup.borderWidth;
}

-(void) dealloc{
    
}

@end
