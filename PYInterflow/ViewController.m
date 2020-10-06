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
#import "PYShutdownPopupView.h"

#import "PYSheetSelectorView.h"
#import "UIView+LeftSlide.h"

@interface PYTView : UIView

@end

@implementation PYTView

-(void) dealloc{
    
}

@end
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
    UIView * vvv = [UIView new];
    vvv.frame = CGRectMake(0, 0, 200, 200);
    vvv.backgroundColor = [UIColor redColor];
    [self.view addSubview:vvv];
    threadJoinGlobal(^{
        threadJoinMain(^{
            UIView * view = [UIView new];
            [view setCornerRadiusAndBorder:5 borderWidth:5 borderColor:[UIColor redColor]];
            view.frameWidth = 200;
            [view leftSlideShow];
        });
        sleep(1);
        while (true) {
            
            threadJoinMain(^{
                [UIView animateWithDuration:2.5f animations:^{
                    vvv.frame = CGRectMake(0, 300, 200, 200);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:2.5f animations:^{
                        vvv.frame = CGRectMake(0, 0, 200, 200);
                    } completion:^(BOOL finished) {
                        
                    }];
                }];
            });
            [NSThread sleepForTimeInterval:6];
        }
        
//        PYShutdownPopupView * popupView  = [PYShutdownPopupView loadXib];
//        threadJoinMain(^{
//            UIView * view  = [UIView new];
//            [view setCornerRadiusAndBorder:2 borderWidth:2 borderColor:[UIColor redColor]];
//            view.frameHeight = 200;
//            [popupView showWithSubView:view superView:self.view topItem:nil topConstant:0];
//        });
//        sleep(1);
//        threadJoinMain(^{
////            [popupView hidden];
//        });
    });
    self.sheetView = [[PYView alloc] initWithFrame:CGRectMake(0, 0, DisableConstrainsValueMAX, 90)];
//    PYSheetSelectorView * cView = [PYSheetSelectorView instanceWithTitle:[[NSAttributedString alloc] initWithString:@"title"] items:@[
//                                [[NSAttributedString alloc] initWithString:@"adfadfads1"],
//                                [[NSAttributedString alloc] initWithString:@"adfadfads2"],
//                                [[NSAttributedString alloc] initWithString:@"adfadfads3"]
//                        ] selectes:@[
//                                @(1)
//                        ] options:@[
//                                [[NSAttributedString alloc] initWithString:@"adfadfads"]
//                        ] multipleSelected:YES];
//    cView.frameWidth = boundsWidth();
//    [cView synFrame];
//    self.sheetView = cView;
    self.alertView = [PYView new];
    self.toastView = [PYView new];
    self.notifyView = [PYView new];
}
- (IBAction)popup:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"标题" message:@"这个是UIAlertController的默认样式" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIView * alertView = self.alertView;
//        UIView * alertView = [[PYView alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
//        [alertView dialogShowWithTitle:@"xxx" block:^(UIView * _Nonnull view, NSUInteger index) {
//
//        } buttonNames:@[@"sfadf"]];
        PY_POPUP_DIALOG_BUTTON_CONFIRM = ^(UIButton * button, NSInteger count, BOOL isConfirm){
            CGFloat offw = count == 1 ? 10 : 0;
            if(isConfirm){
                [button py_makeConstraints:^(PYConstraintMaker * _Nonnull make) {
                    make.left.py_constant(20);
                    make.right.py_constant(10 + offw);
                    make.top.py_constant(0);
                    make.height.py_constant(26);
                }];
            }else{
                [button py_makeConstraints:^(PYConstraintMaker * _Nonnull make) {
                    make.left.py_constant(10 + offw);
                    make.right.py_constant(20);
                    make.top.py_constant(0);
                    make.height.py_constant(26);
                }];
            }
            [button setCornerRadiusAndBorder:13 borderWidth:1 borderColor:[UIColor darkGrayColor]];
        };
        [alertView dialogShowWithTitle:@"提示" message:@"资金在途，预计72小时内到账资金在途，预计72小时内到账资金在途，预计72小时内到账资金在途" block:^(UIView * _Nonnull view, BOOL isConfirm) {
            [view dialogHidden];
        } buttonConfirm:@"" buttonCancel:@"取消"];
//        [alertView dialogShowWithTitle:@"我的" message:@"资金在途，预计72小时内到账资金在途，预计72小时内到账资金在途，预计72小时内到账资金在途" block:^(UIView * _Nonnull view, NSUInteger index) {
//
//            [view dialogHidden];
//        } buttonNames:@[@"确认",@"取消",@"取消"]];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (IBAction)sheet:(id)sender {
    UIView * baseview = [PYView new];//self.sheetView;
    baseview.sheetTitle = @"多选测试";
    baseview.sheetConfirme = @"确定";
    baseview.sheetCancel = @"取消";
    kAssign(baseview)
    baseview.sheetBlockSelecting = ^BOOL(BOOL isSelected, NSUInteger cureentIndex) {
        kStrong(baseview);
//        NSArray * a = baseview.sheetSelectedIndexs;
//        if(!isSelected && baseview.sheetSelectedIndexs.count == 1){
//            baseview.sheetSelectedIndexs = @[@(0)];
//            return NO;
//        }
        return YES;
    };
    baseview.sheetBlcokOpt = ^(UIView * _Nonnull view, BOOL isConfirm) {
        NSArray * a = view.sheetSelectedIndexs;
        NSLog(@"");
    };
    [baseview sheetShowWithItemstrings:@[@"adsfasdf",@"adsfasdf",@"adfa",@"adsfasdf",@"adsfasdf",@"adfa",@"adsfasdf",@"adsfasdf",@"adfa"]];
    baseview.sheetSelectedIndexs = @[@(0),@(6)];
    
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [NSThread sleepForTimeInterval:2];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            baseview.sheetShowView.frameSize = CGSizeMake(DisableConstrainsValueMAX, 200);
//            [baseview.sheetShowView resetAutoLayout];
//        });
//    });
}
- (IBAction)onclickTopbar:(id)sender {
    UIView * view = [PYTView new];//
//    view.toastHasContent = YES;
//    view.toastTintColor = [UIColor systemBackgroundColor];
    [view toastShow:3 message:@"请输入正确的格式例如输入正确的格式例如输入正确的格式例如\n请输入正确的格式例如输入正确的格式例如输入正确的格式例如\n请输入正确的格式例如输入正确的格式例如输入正确的格式例如\n请输入正确的格式例如输入正确的格式例如输入正确的格式例如\n请输入正确的格式例如输入正确的格式例如输入正确的格式例如\n请输入正确的格式例如输入正确的格式例如输入正确的格式例如\n请输入正确的格式例如输入正确的格式例如输入正确的格式例如\n请输入正确的格式例如输入正确的格式例如输入正确的格式例如\n请输入正确的格式例如输入正确的格式例如输入正确的格式例如\n请输入正确的格式例如输入正确的格式例如输入正确的格式例如\n请输入正确的格式例如输入正确的格式例如输入正确的格式例如\n请输入正确的格式例如输入正确的格式例如输入正确的格式例如\n请输入正确的格式例如输入正确的格式例如输入正确的格式例如\n请输入正确的格式例如输入正确的格式例如输入正确的格式例如\n请输入正确的格式例如输入正确的格式例如输入正确的格式例如\n请输入正确的格式例如输入正确的格式例如输入正确的格式例如\n请输入正确的格式例如输入正确的格式例如输入正确的格式例如" image:[UIImage imageNamed:@"icon.png"]];
}
- (IBAction)onclickNotify:(id)sender {
    UIView * view = [UIView new]; //self.notifyView;
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
