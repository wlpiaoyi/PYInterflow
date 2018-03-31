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
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"标题" message:@"这个是UIAlertController的默认样式" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIView * view = [PYView new];
        [view dialogShowWithTitle:@"sdfsdf" message:@"资金在途，预计72小时内到账资金在途，预计72小时内到账资金在途，预计72小时内到账资金在途，预计72小时内到账资金在途，预计72小时内到账资金在途，预计72小时内到账资金在途，预计72小时内到账资金在途，预计72小时内到账资金在途，预计72小时内到账资金在途，预计72小时内到账资金在途，预计72小时内到账资金在途，预计72小时内到账资金在途，预计72小时内到账资金在途，预计72小时内到账资金在途，预计72小时内到账资金在途，预计72小时内到账资金在途，预计72小时内到账资金在途，预计72小时内到账资金在途，预计72小时内到账资金在途，预计72小时内到账资金在途，预计72小时内到账资金在途，预计72小时内到账资金在途，预计72小时内到账资金在途，预计72小时内到账资金在途，预计72小时内到账资金在途，预计72小时内到账资金在途，预计72小时内到账资金在途，预计72小时内到账资金在途，预计72小时内到账资金在途，预计72小时内到账资金在途，预计72小时内到账资金在途，预计72小时内到账资金在途，预计72小时内到账资金在途，预计72小时内到账资金在途，预计72小时内到账资金在途，预计72小时内到账资金在途，预计72小时内到账资金在途，预计72小时内到账" block:^(UIView * _Nonnull view, NSUInteger index) {
            [view dialogHidden];
        } buttonNames:@[@"其他舱位",@"确认",@"取消"]];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (IBAction)sheet:(id)sender {
    UIView * baseview = [[PYView alloc] initWithFrame:CGRectMake(0, 0, DisableConstrainsValueMAX, 90)];
    [baseview setCornerRadiusAndBorder:2 borderWidth:2 borderColor:[UIColor greenColor]];
    [baseview setBackgroundColor:[UIColor redColor]];
//    [baseview sheetShow];
//    [baseview sheetShowWithTitle:@"日期选择"  buttonConfirme:@"确认" buttonCancel:@"取消" blockOpt:^(UIView * _Nullable view, NSUInteger index) {
//
//    }];
    [baseview sheetShowWithTitle:@"adfad" buttonConfirme:@"OK" buttonCancel:@"Cancel" itemStrings:@[@"adsfasdf",@"adsfasdf",@"adfa",@"adsfasdf",@"adsfasdf",@"adfa",@"adsfasdf",@"adsfasdf",@"adfa"] blockOpt:nil blockSelected:^(UIView * _Nullable view, NSUInteger index) {
        NSLog(@"");
    }];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [NSThread sleepForTimeInterval:2];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            baseview.sheetShowView.frameSize = CGSizeMake(DisableConstrainsValueMAX, 200);
//            [baseview.sheetShowView resetAutoLayout];
//        });
//    });
}
- (IBAction)onclickTopbar:(id)sender {
    UIView * view = [PYView new];
    [view topbarShow:3 message:@"请输入正确的格式例如！"];
}
-(void) hidden{
    [self.baseview popupHidden];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
