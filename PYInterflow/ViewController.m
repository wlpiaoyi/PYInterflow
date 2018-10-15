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
@property (nonatomic, strong) UIView * sheetView;
@property (nonatomic, strong) UIView * alertView;
@property (nonatomic, strong) UIView * toastView;
@property (nonatomic, strong) UIView * notifyView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sheetView = [[PYView alloc] initWithFrame:CGRectMake(0, 0, DisableConstrainsValueMAX, 90)];
    self.alertView = [PYView new];
    self.toastView = [PYView new];
    self.notifyView = [PYView new];
}
- (IBAction)popup:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"标题" message:@"这个是UIAlertController的默认样式" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIView * view = self.alertView;
        [view dialogShowWithTitle:@"sdfsdf" message:@"\n资金在途，预计72小时内到账资金在途，预计72小时内到账资金在途，预计72小时内到账资金在途" block:^(UIView * _Nonnull view, NSUInteger index) {
            
            [view dialogHidden];
        } buttonNames:@[@"其他舱位其他舱位其他舱位",@"确认"]];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (IBAction)sheet:(id)sender {
    UIView * baseview = self.sheetView;
    [baseview setBackgroundColor:[UIColor redColor]];
    [baseview setSheetBlockSelecting:^BOOL(NSMutableArray<NSNumber *> * _Nonnull  beforeIndexs, NSUInteger cureentIndex) {
        if(cureentIndex == 0 && ![beforeIndexs containsObject:@(0)]){
            [beforeIndexs removeAllObjects];
            [beforeIndexs addObject:@(0)];
            return NO;
        }else if(cureentIndex != 0 && [beforeIndexs containsObject:@(0)]){
            [beforeIndexs removeObject:@(0)];
            [beforeIndexs addObject:@(cureentIndex)];
            return NO;
        }
        if(beforeIndexs.count == 1 && [beforeIndexs containsObject:@(cureentIndex)]){
            [beforeIndexs removeAllObjects];
            if(cureentIndex == 0){
                [beforeIndexs addObjectsFromArray:@[@(1),@(2),@(3),@(4)]];
            }else{
                [beforeIndexs addObject:@(0)];
            }
            return NO;
        }
        return YES;
    }];
//    [baseview sheetShowWithTitle:@"adfad" buttonConfirme:@"OK" buttonCancel:@"Cancel" itemStrings:@[@"adsfasdf",@"adsfasdf",@"adfa",@"adsfasdf",@"adsfasdf",@"adfa",@"adsfasdf",@"adsfasdf",@"adfa"] blockOpt:^(UIView * _Nullable view, NSUInteger index) {
//        NSLog(@"");
//    } blockSelected:^(UIView * _Nullable view, NSUInteger index) {
//        NSLog(@"");
//    }];
    [baseview sheetShowWithTitle:@"多选测试" buttonConfirme:@"OK" buttonCancel:@"Cancel" itemStrings:@[@"adsfasdf",@"adsfasdf",@"adfa",@"adsfasdf",@"adsfasdf",@"adfa",@"adsfasdf",@"adsfasdf",@"adfa",@"adfa",@"adsfasdf",@"adsfasdf",@"adfa",@"adfa",@"adsfasdf",@"adsfasdf",@"adfa"] blockOpts:^(UIView * _Nullable view, NSUInteger index) {
        NSArray * a = view.sheetIndexs;
        NSLog(@"%@",a);
    } blockSelecteds:^BOOL(UIView * _Nullable view) {
        NSArray * a = view.sheetIndexs;
//        if(a.count == 1){
//            view.sheetIndexs = @[@(0)];
//        }
        return NO;
    }];
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
    UIView * view = self.toastView;//[UIView new];//
    [view toastShow:3 message:@"\n请输入正确的格式例如"];
}
- (IBAction)onclickNotify:(id)sender {
    UIView * view = self.notifyView;
    [view notifyShow:3 message:@"\n请输入正确的格式例如！请输入正确的格式例如请输入正确的格式例如请输入正确的格式例如请输入正确的格式例如请输入正确的格式例如" color:nil blockTap:^(UIView * _Nonnull targetView) {
        NSLog(@"sss");
    }];
}
-(void) hidden{
//    [self.baseview popupHidden];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
