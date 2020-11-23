//
//  PYShutdownItemView.m
//  PYInterflow
//
//  Created by wlpiaoyi on 2020/11/22.
//  Copyright © 2020 wlpiaoyi. All rights reserved.
//

#import "PYShutdownItemView.h"
#import "pyutilea.h"
#import "PYInterflowParams.h"
#import "PYShutdownItemCell.h"

@interface PYShutdownItemView()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation PYShutdownItemView{
    UITableView * tableView;
}

kINITPARAMSForType(PYShutdownItemView){
    UIView * viewTag = [UIView new];
    self.itemMaxCount = 6;
    if(@available(iOS 13.0, *)){
        viewTag.backgroundColor = [UIColor systemBackgroundColor];
    }else{
        viewTag.backgroundColor = [UIColor whiteColor];
    }
    [self addSubview:viewTag];
    [viewTag py_makeConstraints:^(PYConstraintMaker * _Nonnull make) {
        make.top.left.right.py_constant(0);
        make.height.py_constant(10);
    }];
    tableView = [UITableView new];
    [tableView setCornerRadiusAndBorder:8 borderWidth:0 borderColor:nil];
    tableView.backgroundColor = viewTag.backgroundColor;
    tableView.showsVerticalScrollIndicator = tableView.showsHorizontalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:tableView];
    [tableView py_makeConstraints:^(PYConstraintMaker * _Nonnull make) {
        make.top.left.bottom.right.py_constant(0);
    }];
    [tableView registerNib:[UINib nibWithNibName:@"PYShutdownItemCell" bundle:STATIC_INTERFLOW_BUNDEL] forCellReuseIdentifier:@"PYShutdownItemCell"];
    tableView.delegate = self;
    tableView.dataSource = self;
}

-(void) setSelectedIndex:(NSInteger)selectedIndex{
    _selectedIndex = selectedIndex;
    self.items = self.items;
}

-(void) setItems:(NSArray<NSString *> *)items{
    _items = items;
    [tableView reloadData];
    self.frameHeight = MIN(self.itemMaxCount, _items.count) * [PYShutdownItemCell getHeight];
    tableView.scrollEnabled = _items.count > self.itemMaxCount ? YES : NO;
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [PYShutdownItemCell getHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PYShutdownItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PYShutdownItemCell" forIndexPath:indexPath];
    cell.item = self.items[indexPath.row];
    cell.isSelectedItem = indexPath.row == self.selectedIndex;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.selectedIndex = indexPath.row;
    if(self.blockSelectedOpt) _blockSelectedOpt(self);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
