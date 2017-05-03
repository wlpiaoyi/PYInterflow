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
@property (nonatomic, strong) UIWindow * preWindow;
@property (nonatomic, assign) PYPopupWindow * myWindow;
@end

@implementation PYPopupWindow{
@private bool isInit;
}
-(instancetype) init{
    if(self = [super init]){
        [self initParams];
    }
    return self;
}
-(instancetype) initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self initParams];
    }
    return self;
}
-(instancetype) initWithFrame:(CGRect)frame windowLevel:(UIWindowLevel) windowLevel{
    if(self = [super initWithFrame:frame]){
        [self initParams];
        self.windowLevel =windowLevel;
    }
    return self;
}
-(void) initParams{
    if(isInit) return;
    isInit = true;
    PYPopupController * vc = [PYPopupController new];
    vc.myWindow = self;
    UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
    if([keyWindow isKindOfClass:[PYPopupWindow class]]){
        vc.preWindow =  ((PYPopupController *)keyWindow.rootViewController).preWindow;
    }else{
        vc.preWindow = keyWindow;
    }
    vc.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    self.rootViewController = vc;
    [self makeKeyAndVisible];
    [self setBackgroundColor:[UIColor clearColor]];
    self.windowLevel = UIWindowLevelAlert;
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
}
-(instancetype) init{
    if(self = [super init]){
    }
    return self;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    if(!CGSizeEqualToSize([UIScreen mainScreen].bounds.size, self.myWindow.bounds.size)){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PYTopbarNotify" object:nil];
    }
}
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator{
    if(!CGSizeEqualToSize([UIScreen mainScreen].bounds.size, self.myWindow.bounds.size)){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PYTopbarNotify" object:nil];
    }
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    if(!CGSizeEqualToSize([UIScreen mainScreen].bounds.size, self.myWindow.bounds.size)){
        [self setNeedsStatusBarAppearanceUpdate];
    }
}
- (BOOL)prefersStatusBarHidden {
    if(!CGSizeEqualToSize([UIScreen mainScreen].bounds.size, self.myWindow.bounds.size)){
        return [self.preWindow.rootViewController prefersStatusBarHidden];
    }else{
        return [super prefersStatusBarHidden];
    }
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return [self.preWindow.rootViewController supportedInterfaceOrientations];
}
// Returns interface orientation masks.
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return [self.preWindow.rootViewController preferredInterfaceOrientationForPresentation];
}
@end
