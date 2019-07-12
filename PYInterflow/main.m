//
//  main.m
//  PYInterflow
//
//  Created by wlpiaoyi on 2016/11/30.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <dlfcn.h>
#import <sys/types.h>
#import "py_reverse_debugger.h"
#import "py_check_debugger.h"
#import "pyutilea.h"
#import "pyinterflowa.h"

#import <dlfcn.h>
#import <sys/types.h>
#import "fishhook.h"

//int ( * orig_ptrace) (int _request,pid_t pid,caddr_t _addr,int _data);
//int py_ptrace (int _request,pid_t pid,caddr_t _addr,int _data){
//    if(_request == 31){
//        return 0;
//    }
//    return orig_ptrace(_request, pid, _addr, _data);
//}

int main(int argc, char * argv[]) {
    @autoreleasepool {
        py_sysctl_reverse_debugger();
        if(py_sysctl_check_debugger()){
            threadJoinGlobal(^{
                sleep(3);
                threadJoinMain(^{
                    UIView * alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
                    [alertView dialogShowWithTitle:@"标题" message:@"资金在途，预计72小时内到账资金在途，预计72小时内到账资金在途，预计72小时内到账资金在途" block:^(UIView * _Nonnull view, BOOL isConfirm) {
                        [view dialogHidden];
                        py_stop_debugger();
                    } buttonConfirme:@"确定" buttonCancel:@"取消"];
                });
            });
        }
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
