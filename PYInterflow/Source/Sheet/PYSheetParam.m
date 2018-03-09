//
//  PYSheetParam.m
//  PYInterflow
//
//  Created by wlpiaoyi on 2016/12/8.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "PYSheetParam.h"
#import "PYParams.h"
#import "PYSheetHeadView.h"
#import "pyutilea.h"
#import "UIView+Popup.h"

@interface PYSheetParam()
@property (nonatomic, strong) NSLayoutConstraint * lcHeadViewHight;
@property (nonatomic, strong, nullable) NSMutableArray<NSLayoutConstraint *> * lcsSafe;
@property (nonatomic, strong, nullable) NSMutableArray<NSLayoutConstraint *> * lcsContext;
@end

@implementation PYSheetParam
-(nullable instancetype) initWithTarget:(nullable UIView *) target action:(nullable SEL) action{
    if(self = [super init]){
        self.isHiddenOnClick = true;
        self.targetView = target;
        self.action = action;
        self.showView = [UIView new];
        self.showView.backgroundColor = [UIColor clearColor];
        [PYParams setView:self.showView shadowOffset:CGSizeMake(0, -2)];
        UILabel * l = [UILabel new];
        l.textColor = [UIColor whiteColor];
        l.textAlignment = NSTextAlignmentCenter;
        l.font = [UIFont systemFontOfSize:18];
        l.text = @"非安全区域!";
        self.safeOutBottomView = l;
        self.safeOutRightView = [UIView new];
        self.safeOutLeftView = [UIView new];
        self.safeOutBottomView.backgroundColor =
        self.safeOutRightView.backgroundColor =
        self.safeOutLeftView.backgroundColor = [UIColor colorWithRed:.8 green:.8 blue:.8 alpha:.7];
    }
    return self;
}
-(CGFloat) updateHeadView{
    
    if(self.headView == nil){
        PYSheetHeadView * headView = [[PYSheetHeadView alloc] initWithTarget:self.targetView action:self.action];;
        [self.showView addSubview:headView];
        self.lcHeadViewHight = [PYViewAutolayoutCenter persistConstraint:headView size:CGSizeMake(DisableConstrainsValueMAX, 0)].allValues.firstObject;
        [PYViewAutolayoutCenter persistConstraint:headView relationmargins:UIEdgeInsetsMake(0, 0, DisableConstrainsValueMAX, 0) relationToItems:PYEdgeInsetsItemNull()];
        self.headView = headView;
    }
    
    ((PYSheetHeadView *)self.headView).title = self.title;
    ((PYSheetHeadView *)self.headView).confirmNormal = self.confirmNormal;
    ((PYSheetHeadView *)self.headView).confirmHighlighted = self.confirmHighlighted;
    ((PYSheetHeadView *)self.headView).cancelNormal = self.cancelNormal;
    ((PYSheetHeadView *)self.headView).cancelHighlighted = self.cancelHighlighted;
    
    CGFloat height = [((PYSheetHeadView *)self.headView) reloadView];
    self.lcHeadViewHight.constant = height;
    return height;
}


-(void) mergeTargetView{
    [self clearTargetView];
    [self.showView addSubview:self.targetView];
    PYEdgeInsetsItem e = PYEdgeInsetsItemNull();
    e.top = (__bridge void * _Nullable)(self.headView);
    [self.lcsContext addObjectsFromArray:[PYViewAutolayoutCenter persistConstraint:self.targetView relationmargins:UIEdgeInsetsMake(0, 0, 0, 0) relationToItems:e].allValues];
}
-(void) mergesafeOutBottomView{
    if(self.lcsSafe){
        self.lcsSafe = [NSMutableArray new];
    }else{
        for (NSLayoutConstraint * lc in self.lcsContext) {
            [self.safeOutBottomView.superview removeConstraint:lc];
        }
        [self.lcsSafe removeAllObjects];
    }
    [self.safeOutBottomView removeFromSuperview];
    [self.safeOutRightView removeFromSuperview];
    [self.safeOutLeftView removeFromSuperview];
    [self.showView.superview addSubview:self.safeOutBottomView];
    [self.showView.superview addSubview:self.safeOutRightView];
    [self.showView.superview addSubview:self.safeOutLeftView];
    PYEdgeInsetsItem e = PYEdgeInsetsItemNull();
    e.top = (__bridge void * _Nullable)(self.showView);
    [self.lcsSafe addObjectsFromArray:[PYViewAutolayoutCenter persistConstraint:self.safeOutBottomView relationmargins:UIEdgeInsetsMake(0, 0, 0, 0) relationToItems:e].allValues];
    
    e = PYEdgeInsetsItemNull();
    e.right = (__bridge void * _Nullable)(self.showView);
    e.bottom  = (__bridge void * _Nullable)(self.safeOutBottomView);
    [self.lcsSafe addObjectsFromArray:[PYViewAutolayoutCenter persistConstraint:self.safeOutLeftView relationmargins:UIEdgeInsetsMake(DisableConstrainsValueMAX, 0, 0, 0) relationToItems:e].allValues];
    NSLayoutConstraint *equalsConstraint= [NSLayoutConstraint constraintWithItem:self.safeOutLeftView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.showView attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
    [self.safeOutLeftView.superview addConstraint:equalsConstraint];
    [self.lcsSafe addObject:equalsConstraint];
    
    e = PYEdgeInsetsItemNull();
    e.left = (__bridge void * _Nullable)(self.showView);
    e.bottom  = (__bridge void * _Nullable)(self.safeOutBottomView);
    [self.lcsSafe addObjectsFromArray:[PYViewAutolayoutCenter persistConstraint:self.safeOutRightView relationmargins:UIEdgeInsetsMake(DisableConstrainsValueMAX, 0, 0, 0) relationToItems:e].allValues];
    equalsConstraint= [NSLayoutConstraint constraintWithItem:self.safeOutRightView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.showView attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
    [self.safeOutRightView.superview addConstraint:equalsConstraint];
    [self.lcsSafe addObject:equalsConstraint];
}

-(void) clearTargetView{
    for (NSLayoutConstraint * lc in self.lcsContext) {
        [self.showView removeConstraint:lc];
    }
    [self.lcsContext removeAllObjects];
    [self.targetView removeFromSuperview];
}

+(nullable NSMutableAttributedString *) parseDialogTitle:(nullable NSString *) title{
    if(title == nil) return nil;
    NSMutableAttributedString *attTitle = [[NSMutableAttributedString alloc] initWithString:title];
    NSRange range = NSMakeRange(0, attTitle.length);
    [attTitle addAttribute:NSForegroundColorAttributeName value:STATIC_DIALOG_TEXTCLOLOR range:range];//颜色
    [attTitle addAttribute:NSFontAttributeName value:STATIC_DIALOG_TITLEFONT range:range];
    return attTitle;
}
+(nullable NSMutableAttributedString*) parseNormalButtonName:(nullable NSString *) name{
    if(name == nil) return nil;
    NSMutableAttributedString *attTitle = [[NSMutableAttributedString alloc] initWithString:name];
    NSRange range = NSMakeRange(0, attTitle.length);
    [attTitle addAttribute:NSForegroundColorAttributeName value:STATIC_DIALOG_TEXTCLOLOR range:range];//颜色
    [attTitle addAttribute:NSFontAttributeName value:STATIC_DIALOG_BUTTONFONT range:range];
    return attTitle;
}

+(nullable NSMutableAttributedString*) parseHightlightedButtonName:(nullable NSString *) name{
    if(name == nil) return nil;
    NSMutableAttributedString *attTitle = [[NSMutableAttributedString alloc] initWithString:name];
    NSRange range = NSMakeRange(0, attTitle.length);
    [attTitle addAttribute:NSForegroundColorAttributeName value:STATIC_DIALOG_TEXTCLOLOR range:range];//颜色
    [attTitle addAttribute:NSFontAttributeName value:STATIC_DIALOG_BUTTONFONT range:range];
    return attTitle;
}

@end

@interface PYSheetItemDelegate()<UITableViewDelegate, UITableViewDataSource>
kPNARA UITableView * tableView;
kPNSNN NSArray <NSAttributedString *> * itemAttributes;
kPNCNA void (^blockSelected)(NSUInteger index);
@end

@implementation PYSheetItemDelegate
-(instancetype) initWithTableView:(UITableView *) tableView itemAttributes:(NSArray<NSAttributedString *> *) itemAttributes blockSelected:(void(^_Nullable)(NSUInteger index)) blockSelected{
    self = [super init];
    _tableView = tableView;
    self.itemAttributes = itemAttributes;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.blockSelected = blockSelected;
    return self;
}

+(CGFloat) getCellHeight{
    return 38;
}

#pragma UITableViewDelegate ==>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [PYSheetItemDelegate getCellHeight];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.blockSelected){
        _blockSelected(indexPath.row);
    }
}
#pragma UITableViewDelegate <==

#pragma UITableViewDataSource ==>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemAttributes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"pysheetparam"];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pysheetparam"];
    }
    cell.textLabel.attributedText = self.itemAttributes[indexPath.row];
    return cell;
}
#pragma UITableViewDataSource <==
@end
