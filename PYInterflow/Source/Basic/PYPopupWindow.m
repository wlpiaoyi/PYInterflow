//
//  PYPopupWindow.m
//  PYInterflow
//
//  Created by wlpiaoyi on 2016/12/8.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "PYPopupWindow.h"
#import "pyutilea.h"
#import "PYParams.h"
#import "PYPopupParam.h"

@interface PYPopupController : UIViewController
@property (nonatomic, assign) PYPopupWindow * myWindow;
-(instancetype) initForEffect:(BOOL) hasEffect;
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
+(instancetype) instanceForFrame:(CGRect)frame hasEffect:(BOOL) hasEffect{
    PYPopupWindow * window;
    @synchronized(self){
        PYPopupController * vc = [[PYPopupController alloc] initForEffect:hasEffect];
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
            if(subView.tag == 1862938) continue;
            [subView removeFromSuperview];
        }
        [self.rootViewController.view addSubview:view];
    }
}
-(void) setFrame:(CGRect)frame{
    [super setFrame:frame];
}
-(void) dealloc{
    if(self.rootViewController && [self.rootViewController isKindOfClass:[PYPopupController class]]){
        self.rootViewController = nil;
    }
}
@end
@implementation PYPopupController{
@private
    BOOL __prefersStatusBarHidden;
    BOOL __preferredStatusBarStyle;
    BOOL __supportedInterfaceOrientations;
    BOOL __shouldAutorotate;
    BOOL __preferredInterfaceOrientationForPresentation;
    UIImageView * _bgView;
    BOOL _hasEffect;
}

-(instancetype) initForEffect:(BOOL) hasEffect{
    if(self = [super init]){
        _hasEffect = hasEffect;
        if(hasEffect){
            _bgView = [UIImageView new];
            _bgView.backgroundColor = [UIColor clearColor];
            [self.view addSubview:_bgView];
            [_bgView setAutotLayotDict:@{@"top":@(0), @"left":@(0), @"right":@(0), @"bottom":@(0)}];
            _bgView.tag = 1862938;
            [_bgView.superview sendSubviewToBack:_bgView];
            kNOTIF_ADD(self, STATIC_POPUP_EFFECTE_NOTIFY, refresh:);
        }
    }
    return self;
}
-(void) refresh:(NSNotification *) notify{
    if(_bgView){
        _bgView.image = notify.object;
    }
}
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator{
    kAssign(self);
    threadJoinGlobal(^{
        [NSThread sleepForTimeInterval:0.2];
        threadJoinMain(^{
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
    UIViewController * orgVc = [PYUtile getCurrentController];
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
    UIViewController * orgVc = [PYUtile getCurrentController];
    UIStatusBarStyle result;
    if(__preferredStatusBarStyle){
        result = [super preferredStatusBarStyle];
    }else{
        __preferredStatusBarStyle = true;
        result = [orgVc preferredStatusBarStyle];
        __preferredStatusBarStyle = false;
    }
    return result;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    UIViewController * orgVc = [PYUtile getCurrentController];
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
    UIViewController * orgVc = [PYUtile getCurrentController];
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
    UIViewController * orgVc = [PYUtile getCurrentController];
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
    if(_hasEffect){
        kNOTIF_REMV(self, STATIC_POPUP_EFFECTE_NOTIFY);
    }
}
@end
