//
//  PYPopupWindow.m
//  PYInterflow
//
//  Created by wlpiaoyi on 2016/12/8.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "PYPopupWindow.h"

@implementation PYPopupWindow{
}
-(instancetype) initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self makeKeyAndVisible];
        [self setBackgroundColor:[UIColor clearColor]];
        UIViewController * vc = [UIViewController new];
        vc.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        self.windowLevel = UIWindowLevelAlert;
        self.rootViewController = vc;
    }
    return self;
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
