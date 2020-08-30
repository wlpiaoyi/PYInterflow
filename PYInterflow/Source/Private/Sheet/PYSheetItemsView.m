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
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [_tableView registerNib:[UINib nibWithNibName:kPYSheetItemCell bundle:STATIC_INTERFLOW_BUNDEL] forCellReuseIdentifier:kPYSheetItemCell];
    self.scrollEnabled = YES;
}
-(void) setScrollEnabled:(BOOL)scrollEnabled{
    _scrollEnabled = scrollEnabled;
    _tableView.scrollEnabled = scrollEnabled;
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
    NSInteger row = [tableView indexPathForCell:tableView.visibleCells.firstObject].row;
    for (PYSheetItemCell * cell in tableView.visibleCells) {
        cell.isSelected = (self.selectes && [self.selectes containsObject:@(row++)]);
    }
    [tableView deselectRowAtIndexPath:indexPath animated:self.selectes == nil];
//    if(self.blockAfterSelectedItems) _blockAfterSelectedItems(self);
}

-(void) setSelectes:(NSArray<NSNumber *> * _Nullable)selectes{
    _selectes = selectes;
    [_tableView reloadData];
}
+(nullable instancetype) instanceWithItems:(nonnull NSArray<NSAttributedString *> *) items
                                selectes:(nullable NSArray<NSNumber *> *) selectes
                                multipleSelected:(BOOL) multipleSelected{
    kPYSheetItemSelectedColor = [UIColor colorWithRGBHex:0x00000033];
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
    return height - STATIC_POPUP_BORDERWIDTH;
}

-(void) dealloc{
    
}

@end
