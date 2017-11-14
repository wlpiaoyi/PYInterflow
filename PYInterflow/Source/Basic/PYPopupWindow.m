//
//  PYPopupWindow.m
//  PYInterflow
//
//  Created by wlpiaoyi on 2016/12/8.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "PYPopupWindow.h"
#import "pyutilea.h"

@interface PYPopupController : UIViewController
@property (nonatomic, assign) PYPopupWindow * myWindow;
@property (nonatomic, assign) UIWindow * orgWindow;
@end

@implementation PYPopupWindow{
@private
    bool isInit;
}
kINITPARAMS{
    if(isInit) return;
    isInit = true;
    [self makeKeyAndVisible];
    [self setBackgroundColor:[UIColor clearColor]];
    self.windowLevel = UIWindowLevelStatusBar;
}
+(instancetype) instanceForFrame:(CGRect)frame{
    PYPopupWindow * window;
    @synchronized(self){
        PYPopupController * vc = [PYPopupController new];
        UIWindow * orgWindow = [UIApplication sharedApplication].keyWindow;
        if([orgWindow isKindOfClass:[PYPopupWindow class]]){
            orgWindow = ((PYPopupController*)((PYPopupWindow*)orgWindow).rootViewController).orgWindow;
        }
        vc.orgWindow = orgWindow;
        vc.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        window = [[PYPopupWindow alloc] initWithFrame:frame];
        window.rootViewController = vc;
        vc.myWindow = window;
    }
    return window;
}
-(void) addSubview:(UIView *)view{
    if(view == self.rootViewController.view){
        [super addSubview:view];
    }else{
        for (UIView * subView in self.rootViewController.view.subviews) {
            [subView removeFromSuperview];
        }
        [self.rootViewController.view addSubview:view];
    }
}
-(void) dealloc{
}
@end
@implementation PYPopupController{
@private
    BOOL __prefersStatusBarHidden;
    BOOL __preferredStatusBarStyle;
    BOOL __supportedInterfaceOrientations;
    BOOL __shouldAutorotate;
    BOOL __preferredInterfaceOrientationForPresentation;
}
-(instancetype) init{
    if(self = [super init]){
    }
    return self;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator{
    kAssign(self);
    kDISPATCH_GLOBAL_QUEUE_DEFAULT(^{
        [NSThread sleepForTimeInterval:0.2];
        kDISPATCH_MAIN_THREAD(^{
            kStrong(self);
            [self setNeedsStatusBarAppearanceUpdate];
        });
    });
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self setNeedsStatusBarAppearanceUpdate];
}
- (BOOL)prefersStatusBarHidden {
    UIViewController * orgVc = self.orgWindow.rootViewController;
    BOOL result;
    if(__prefersStatusBarHidden){
        result = [super preferredStatusBarStyle];
    }else{
        __prefersStatusBarHidden = true;
        result = [orgVc prefersStatusBarHidden];
        __prefersStatusBarHidden = false;
    }
    return result;
}
-(UIStatusBarStyle) preferredStatusBarStyle{
    UIViewController * orgVc = self.orgWindow.rootViewController;
    UIStatusBarStyle result;
    if(__preferredStatusBarStyle){
        result = [super preferredStatusBarStyle];
    }else{
        __preferredStatusBarStyle = true;
        result = [orgVc preferredStatusBarStyle];
        __preferredStatusBarStyle = false;;
    }
    return result;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    UIViewController * orgVc = self.orgWindow.rootViewController;
    UIInterfaceOrientationMask result;
    if(__supportedInterfaceOrientations){
        result = [super supportedInterfaceOrientations];
    }else{
        __supportedInterfaceOrientations = true;
        result = [orgVc supportedInterfaceOrientations];
        __supportedInterfaceOrientations = false;
    }
    return result;
}

- (BOOL)shouldAutorotate{
    UIViewController * orgVc = self.orgWindow.rootViewController;
    BOOL result;
    if(__shouldAutorotate){
        result = [super shouldAutorotate];
    }else{
        __shouldAutorotate = true;
        result = [orgVc shouldAutorotate];
        __shouldAutorotate = false;
    }
    return result;
}
// Returns interface orientation masks.
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    UIViewController * orgVc = self.orgWindow.rootViewController;
    UIInterfaceOrientation result;
    if(__preferredInterfaceOrientationForPresentation){
         result = [super preferredInterfaceOrientationForPresentation];
    }else{
        __preferredInterfaceOrientationForPresentation = true;
        result = [orgVc preferredInterfaceOrientationForPresentation];
        __preferredInterfaceOrientationForPresentation = false;
    }
    return result;
}

-(void) dealloc{
}
@end
