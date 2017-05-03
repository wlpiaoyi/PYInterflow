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
    UIView * baseview = [[PYView alloc] initWithFrame:CGRectMake(0, 20, 80, 80)];
    [baseview dialogShowWithTitle:@"alkjalkjdl" message:@"adfasdfads我日你老母ads我日你老母ads我日你老母ads我日你老母ads我日你老母ads我日你老母ads我日你老母ads我日你老母ads我日你老母ads我日你老母ads我日你老母ads我日你老母ads我日你老母ads我日"block:^(UIView * _Nonnull view, NSUInteger index) {
        [view dialogHidden];
    } buttonNames:@[@"确定"]];
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
    [view topbarShow:3 message:@"adsfadsf我娱乐 我晕了dsf我娱乐 我晕了dsf我娱乐 我晕了dsf我娱乐 我晕了dsf我娱乐 我晕了dsf我娱乐 我晕了dsf我娱乐 我晕了dsf我娱乐 我晕了dsf我娱乐 我晕了dsf我娱乐 我晕了dsf我娱乐 我晕了"];
}
-(void) hidden{
    [self.baseview popupHidden];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
