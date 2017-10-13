//
//  ViewController.m
//  PYInterflow
//
//  Created by wlpiaoyi on 2016/11/30.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//


#import "ViewController.h"
#import  "PYHook.h"
#import "pyutilea.h"
#import "UIView+Remove.h"
#import "UIView+Dialog.h"
#import "UIView+Popup.h"
#import "UIView+sheet.h"
#import "UIView+Topbar.h"
#import "pyutilea.h"
@interface PYView:UIView
@end
@implementation PYView
-(void) dealloc{
}
@end
@interface ViewController ()
@property (nonatomic, strong) UIView * baseview;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseview = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 80, 80)];
    [self.baseview setBackgroundColor:[UIColor redColor]];
    NSLog(@"%@", (NSString*)bundleDir);
//    UIScrollView * sc = [UIScrollView new];
//    sc.contentSize = CGSizeMake(600, 1000);
//    [self.view addSubview:sc];
//    [PYViewAutolayoutCenter persistConstraint:sc relationmargins:UIEdgeInsetsMake(0, 0, 0, 0) relationToItems:PYEdgeInsetsItemNull()];
//    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 80, 80)];
//    view.moveable = true;
//    view.backgroundColor = [ UIColor grayColor];
//    [view setCornerRadiusAndBorder:2 borderWidth:2 borderColor:[UIColor redColor]];
//    [sc addSubview:view];
}
- (IBAction)popup:(id)sender {
    UIView * view = [UIView new];
    [view dialogShowWithTitle:nil message:@"应用有JS更新，需要重新加载吗?" block:^(UIView * _Nonnull view, NSUInteger index) {
        [view dialogHidden];
    } buttonNames:@[@"下次",@"立即"]];
//    UIView * view = [UIView new];
//    BlockDialogButtonStyle  = ^(UIButton * _Nonnull button){
//        [PYViewAutolayoutCenter persistConstraint:button relationmargins:UIEdgeInsetsMake(5, 5, 5, 5) relationToItems:PYEdgeInsetsItemNull()];
//        [button setCornerRadiusAndBorder:4 borderWidth:0 borderColor:[UIColor grayColor]];
//        UIColor * ColorTHBase = [UIColor colorWithRed:0.937 green:0.357 blue:0.369 alpha:1.00];
//        UIColor * ColorTHBaseLight = [UIColor colorWithRed:0.937 green:0.357 blue:0.369 alpha:0.1];
//        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [button setTitleColor:ColorTHBase forState:UIControlStateHighlighted];
//        [button setBackgroundImage:[UIImage imageWithColor:ColorTHBase] forState:UIControlStateNormal];
//        [button setBackgroundImage:[UIImage imageWithColor:ColorTHBaseLight] forState:UIControlStateHighlighted];
//    };
//    [view dialogShowWithTitle:@"adsfads" message:@"dd" block:^(UIView * _Nonnull view, NSUInteger index) {
//        [view dialogHidden];
//    } buttonNames:@[@"预定最低价",@"继续预定"]];
}
- (IBAction)sheet:(id)sender {
    UIView * baseview = [[PYView alloc] initWithFrame:CGRectMake(0, 0, DisableConstrainsValueMAX, 90)];
    [baseview setBackgroundColor:[UIColor redColor]];
    [baseview sheetShowWithTitle:@"adfad" buttonConfirme:@"OK" buttonCancel:@"Cancel" block:^(UIView * _Nullable view, int index) {
        NSLog(@"");
    }];
}
- (IBAction)onclickTopbar:(id)sender {
    UIView * view = [PYView new];
    [view topbarShow:3 message:@"请输入正确的格式例如:88.88, 88"];
}
-(void) hidden{
    [self.baseview popupHidden];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
