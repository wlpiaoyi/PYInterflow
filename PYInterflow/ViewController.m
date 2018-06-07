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
#import "UIView+Toast.h"
#import "UIView+Notify.h"
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
        [view dialogShowWithTitle:@"sdfsdf" message:@"\n资金在途，预计72小时内到账资金在途，预计72小时内到账资金在途，预计72小时内到账资金在途" block:^(UIView * _Nonnull view, NSUInteger index) {
            
            [view dialogHidden];
        } buttonNames:@[@"其他舱位其他舱位其他舱位",@"确认"]];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (IBAction)sheet:(id)sender {
    UIView * baseview = [[PYView alloc] initWithFrame:CGRectMake(0, 0, DisableConstrainsValueMAX, 90)];
//    [baseview setCornerRadiusAndBorder:2 borderWidth:2 borderColor:[UIColor greenColor]];
    [baseview setBackgroundColor:[UIColor redColor]];
//    [baseview sheetShow];
    
//    [baseview sheetShowWithTitle:@"日期选择"  buttonConfirme:@"确认" buttonCancel:@"取消" blockOpt:^(UIView * _Nullable view, NSUInteger index) {
//
//    }];
    
    [baseview sheetShowWithTitle:@"adfad" buttonConfirme:@"OK" buttonCancel:@"Cancel" itemStrings:@[@"adsfasdf",@"adsfasdf",@"adfa",@"adsfasdf",@"adsfasdf",@"adfa",@"adsfasdf",@"adsfasdf",@"adfa"] blockOpt:^(UIView * _Nullable view, NSUInteger index) {
        NSLog(@"");
    } blockSelected:^(UIView * _Nullable view, NSUInteger index) {
        NSLog(@"");
    }];
//    [baseview sheetShowWithTitle:@"多选测试" buttonConfirme:@"OK" buttonCancel:@"Cancel" itemStrings:@[@"adsfasdf",@"adsfasdf",@"adfa",@"adsfasdf",@"adsfasdf",@"adfa",@"adsfasdf",@"adsfasdf",@"adfa",@"adfa",@"adsfasdf",@"adsfasdf",@"adfa",@"adfa",@"adsfasdf",@"adsfasdf",@"adfa"] blockOpts:^(UIView * _Nullable view, NSUInteger index) {
//        NSArray * a = view.sheetIndexs;
//        NSLog(@"%@",a);
//    } blockSelecteds:^BOOL(UIView * _Nullable view) {
//        NSArray * a = view.sheetIndexs;
//        if(a.count == 1){
//            view.sheetIndexs = @[@(0)];
//        }
//        return NO;
//    }];
    baseview.sheetIndexs = @[@(0),@(6)];
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
    [view toastShow:3 message:@"\n请输入正确的格式例如"];
}
- (IBAction)onclickNotify:(id)sender {
    UIView * view = [PYView new];
    [view notifyShow:50 message:@"\n请输入正确的格式例如！请输入正确的格式例如请输入正确的格式例如请输入正确的格式例如请输入正确的格式例如请输入正确的格式例如" color:nil blockTap:^(UIView * _Nonnull targetView) {
        NSLog(@"sss");
    }];
}
-(void) hidden{
    [self.baseview popupHidden];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
