//
//  PYInterflowWindow.m
//  PYInterflow
//
//  Created by wlpiaoyi on 2016/12/8.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "PYInterflowWindow.h"
#import "pyutilea.h"
#import "PYInterflowParams.h"
#import "PYPopupParam.h"
#import <objc/runtime.h>

//@interface PYSceneDelegate:NSObject<UISceneDelegate>
//@end
//
//@implementation PYSceneDelegate
//- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions API_AVAILABLE(ios(13.0)){
//}
//@end

@interface PYInterflowController : UIViewController
kPNAR BOOL hasEffect;
kPNA PYInterflowWindow * myWindow;
kPNRNN UIImageView * bgView;
-(instancetype) initForEffect:(BOOL) hasEffect;
@end

@implementation PYInterflowWindow{
@private
    bool isInit;
}
kINITPARAMS{
    if(isInit) return;
    isInit = true;
    [self setBackgroundColor:[UIColor clearColor]];
}
+(instancetype) instanceForFrame:(CGRect)frame hasEffect:(BOOL) hasEffect{
    PYInterflowWindow * window;
    @synchronized(self){
        PYInterflowController * vc = [[PYInterflowController alloc] initForEffect:hasEffect];
        vc.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        window = [[PYInterflowWindow alloc] initWithFrame:frame];
        window.rootViewController = vc;
        vc.myWindow = window;
    }
    if (@available(iOS 13.0, *)) {
        UIWindowScene *windowScene = (UIWindowScene *) [UIApplication sharedApplication].connectedScenes.anyObject;
        [window setWindowScene: windowScene];
    }
    return window;
}

-(void) addSubview:(UIView *)view{
    if (@available(iOS 13.0, *)) {
        if([view isKindOfClass:NSClassFromString(@"UITransitionView")]){
            [super addSubview:view];
            return;
        }
    }
    if(view == self.rootViewController.view){
        [super addSubview:view];
    }else{
//        if(![view isKindOfClass:NSClassFromString(@"PYKeyboardOptionView")]) [self removeSubviews];
        [self.rootViewController.view addSubview:view];
    }
}
-(void) removeSubviews{
    NSArray<__kindof UIView *> *subviews = self.rootViewController.view.subviews;
    for (UIView * subView in subviews) {
        if(subView == ((PYInterflowController *)self.rootViewController).bgView) continue;
        [subView removeFromSuperview];
    }
}

-(void) dealloc{
//    if(self.rootViewController && [self.rootViewController isKindOfClass:[PYInterflowController class]]){
//        self.rootViewController = nil;
//    }
}

@end
@implementation PYInterflowController{
@private
    BOOL __prefersStatusBarHidden;
    BOOL __preferredStatusBarStyle;
    BOOL __supportedInterfaceOrientations;
    BOOL __shouldAutorotate;
    BOOL __preferredInterfaceOrientationForPresentation;
}

+(void) initialize{
//    kDISPATCH_ONCE_BLOCK(^{
//        Protocol * protcol = NSProtocolFromString(@"PYKeyboardOptionTag");
//        if(!protcol) return;
//        if([[PYInterflowController class] conformsToProtocol:protcol]) return;
//        class_addProtocol([PYInterflowController class], protcol);
//    });
}

-(BOOL) canTouchHidden{
    return false;
}

-(instancetype) initForEffect:(BOOL) hasEffect{
    if(self = [super init]){
        _hasEffect = hasEffect;
        if(hasEffect){
            _bgView = [UIImageView new];
            _bgView.backgroundColor = [UIColor clearColor];
            [self.view addSubview:_bgView];
            [PYViewAutolayoutCenter persistConstraint:_bgView relationmargins:UIEdgeInsetsZero relationToItems:PYEdgeInsetsItemNull()];
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
    threadJoinGlobal(^{
        [NSThread sleepForTimeInterval:0.2];
        threadJoinMain(^{
            [self setNeedsStatusBarAppearanceUpdate];
        });
    });
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
    return NO;
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
