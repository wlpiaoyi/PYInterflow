//
//  PYShutdownPopupView.m
//  PYInterflow
//
//  Created by wlpiaoyi on 2020/8/18.
//  Copyright © 2020 wlpiaoyi. All rights reserved.
//

#import "PYShutdownPopupView.h"
#import "PYInterflowParams.h"

@implementation PYShutdownPopupView{
    __weak IBOutlet UIView *viewPopup;
    __weak IBOutlet UIView *viewFlow;
    __weak IBOutlet NSLayoutConstraint *lcPopupH;
    __weak IBOutlet NSLayoutConstraint *lcPopuptop;
}

+(instancetype) instance{
    return[STATIC_INTERFLOW_BUNDEL loadNibNamed:NSStringFromClass(self) owner:self options:nil].lastObject;
}

-(void) addForPopup:(nonnull UIView *) view{
    
    NSArray<UIView *> * subviews = viewPopup.subviews;
    for (UIView * subview in subviews) {
        [subview py_removeAllLayoutContarint];
        [subview removeFromSuperview];
    }
    [view py_removeAllLayoutContarint];
    [view removeFromSuperview];
    lcPopupH.constant = view.frameHeight;
    lcPopuptop.constant = lcPopupH.constant * -1.;
    [viewPopup addSubview:view];
    [view py_makeConstraints:^(PYConstraintMaker * _Nonnull make) {
        make.top.bottom.left.right.py_constant(0);
    }];
    
}

-(void) showWithSubView:(nonnull UIView *) subView superView:(nonnull UIView *) superView topItem:(nullable UIView *) topItem topConstant:(CGFloat) topConstant{
    [self addForPopup:subView];
    [self py_removeAllLayoutContarint];
    [self removeFromSuperview];
    [superView addSubview:self];
    if(topItem){
        [self py_makeConstraints:^(PYConstraintMaker * _Nonnull make) {
            make.top.py_inArea(YES).py_toItem(topItem).py_constant(topConstant);
        }];
    }else{
        [self py_makeConstraints:^(PYConstraintMaker * _Nonnull make) {
            make.top.py_inArea(YES).py_constant(topConstant);
        }];
    }
    [self py_makeConstraints:^(PYConstraintMaker * _Nonnull make) {
        make.bottom.left.right.py_inArea(YES).py_constant(0);
    }];
    [self layoutIfNeeded];
    [UIView animateWithDuration:.25f animations:^{
        self->lcPopuptop.constant = 0;
        [self layoutIfNeeded];
    }];
}

-(void) showWithSubView:(nonnull UIView *) subView superView:(nonnull UIView *) superView topConstant:(CGFloat) topConstant{
    [self showWithSubView:subView superView:superView topItem:nil topConstant:topConstant];
}
- (IBAction)onclickHidden:(id)sender {
    [self hidden];
}

-(void) hidden{
    [UIView animateWithDuration:.25f animations:^{
        self->lcPopuptop.constant = self->lcPopupH.constant * -1.;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self py_removeAllLayoutContarint];
        [self removeFromSuperview];
    }];
}


@end
