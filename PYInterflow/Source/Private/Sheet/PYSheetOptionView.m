//
//  PYSheetOptionView.m
//  PYInterflow
//
//  Created by wlpiaoyi on 2019/3/26.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import "PYSheetOptionView.h"
#import "PYInterflowParams.h"
@interface PYSheetOptionView()
kPNCNA void (^blockOpt) (NSUInteger index);
kPNSNA NSAttributedString * title;
kPNSNA NSAttributedString * previousName;
kPNSNA NSAttributedString * nextName;
kPNSNA NSArray<NSLayoutConstraint *> * lcs;
@end

@implementation PYSheetOptionView{
    __weak IBOutlet UIButton *buttonPrevious;
    __weak IBOutlet UIButton *buttonNext;
    __weak IBOutlet UILabel *labelTitle;
    __weak IBOutlet UIView *viewTitle;
    __weak IBOutlet UIView *viewContext;
    __weak IBOutlet NSLayoutConstraint *lc01;
    __weak IBOutlet NSLayoutConstraint *lc02;
    __weak IBOutlet NSLayoutConstraint *lc03;
}

+(nonnull instancetype) instanceWithTitle:(nullable NSAttributedString *) title
                             previousName:(nullable NSAttributedString *) previousName
                                 nextName:(nullable NSAttributedString *) nextName
                                 blockOpt:(void (^ _Nullable)(NSUInteger index)) blcokOpt{
    
    PYSheetOptionView * owner = [STATIC_INTERFLOW_BUNDEL loadNibNamed:NSStringFromClass(self) owner:self options:nil].lastObject;
    owner.blockOpt = blcokOpt;
    owner.title = title;
    owner.previousName = previousName;
    owner.nextName = nextName;
    [owner synDisplay];
    return owner;
}

-(void) awakeFromNib{
    [super awakeFromNib];
    viewTitle.backgroundColor = xPYInterflowConfValue.sheet.colorBg;
    buttonNext.backgroundColor = buttonPrevious.backgroundColor = [UIColor clearColor];
    [buttonPrevious setBackgroundImage:[UIImage imageWithColor:xPYInterflowConfValue.sheet.colorBg] forState:UIControlStateNormal];
    [buttonNext setBackgroundImage:[UIImage imageWithColor:xPYInterflowConfValue.sheet.colorBg] forState:UIControlStateNormal];
    [buttonPrevious setBackgroundImage:[UIImage imageWithColor:xPYInterflowConfValue.popup.colorHighlightBg] forState:UIControlStateHighlighted];
    [buttonNext setBackgroundImage:[UIImage imageWithColor:xPYInterflowConfValue.popup.colorHighlightBg] forState:UIControlStateHighlighted];
    lc01.constant = lc02.constant = 0;
    lc03.constant = 1.0 / [UIScreen mainScreen].scale;
}
-(void) synDisplay{
    labelTitle.attributedText = self.title;
    [buttonPrevious setAttributedTitle:self.previousName forState:UIControlStateNormal];
    [buttonNext setAttributedTitle:self.nextName forState:UIControlStateNormal];
}
- (IBAction)onclickOpt:(id)sender {
    if(_blockOpt) _blockOpt(sender == buttonNext ? 1 : (sender == buttonPrevious ? 0 : 10));
}

-(void) removeSheetView{
    for (UIView * view in viewContext.subviews) {
        [view removeFromSuperview];
        for (NSLayoutConstraint * lc in self.lcs) {
            [view removeConstraint:lc];
            [viewContext removeConstraint:lc];
        }
    }
    self.lcs = nil;
}

-(void) addSheetView:(nonnull UIView *) view{
    [self removeSheetView];
    [viewContext addSubview:view];
    self.lcs = [PYViewAutolayoutCenter persistConstraint:view relationmargins:UIEdgeInsetsZero relationToItems:PYEdgeInsetsItemNull()].allValues;
    self.frameHeight = 44 + 1.0 / [UIScreen mainScreen].scale + view.frameHeight;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
