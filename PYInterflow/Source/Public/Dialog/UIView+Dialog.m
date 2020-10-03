//
//  UIView+Dialog.m
//  PYInterchange
//
//  Created by wlpiaoyi on 16/1/21.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "UIView+Dialog.h"
#import "UIView+Popup.h"
#import "pyutilea.h"
#import <objc/runtime.h>
#import "PYDialogMessageView.h"
#import "PYDialogParam.h"
void (^PY_POPUP_DIALOG_BUTTON_CONFIRM) (UIButton * button, BOOL isConfirm);
void (^PY_POPUP_DIALOG_BUTTON_OPTION) (UIButton * button, NSInteger index);

static const void *PYDialogPointer = &PYDialogPointer;

@implementation UIView(Dialog)
-(UIView *) dialogShowView{
    return [self paramDialog].showView;
}
-(void) setDialogUserInfo:(id)dialogUserInfo{
    [self paramDialog].userInfo = dialogUserInfo;
}
-(id) dialogUserInfo{
    return [self paramDialog].userInfo;
}
-(void) setDialogTitle:(id)dialogTitle{
    if(![NSString isEnabled:dialogTitle])
        [self paramDialog].attributeTitle = nil;
    else if([dialogTitle isKindOfClass:[NSAttributedString class]])
        [self paramDialog].attributeTitle = dialogTitle;
    else if([dialogTitle isKindOfClass:[NSString class]])
        [self paramDialog].attributeTitle =  [PYDialogParam parseDialogTitle:dialogTitle];
    else
        [self paramDialog].attributeTitle = nil;
}
-(id) dialogTitle{
    return [self paramDialog].attributeTitle;
}
-(void) setDialogMessage:(id)dialogMessage{
    if(![NSString isEnabled:dialogMessage])
        [self paramDialog].attributeMessage = nil;
    else if([dialogMessage isKindOfClass:[NSAttributedString class]])
        [self paramDialog].attributeMessage = dialogMessage;
    else if([dialogMessage isKindOfClass:[NSString class]])
        [self paramDialog].attributeMessage =  [PYDialogParam parseDialogMessage:dialogMessage];
    else
        [self paramDialog].attributeMessage = nil;
}
-(id) dialogMessage{
    return [self paramDialog].attributeMessage;
}
-(void) setDialogNormalNames:(NSArray<id> *)dialogNormalNames{
    if(!dialogNormalNames || dialogNormalNames.count == 0)
        [self paramDialog].normalButtonNames = nil;
    else if([dialogNormalNames.firstObject isKindOfClass:[NSAttributedString class]])
        [self paramDialog].normalButtonNames = dialogNormalNames;
    else if([dialogNormalNames.firstObject isKindOfClass:[NSString class]])
        [self paramDialog].normalButtonNames = [PYDialogParam parseNormalButtonNames:dialogNormalNames];
    else [self paramDialog].normalButtonNames = nil;
}
-(NSArray<id> *) dialogNormalNames{
    return [self paramDialog].normalButtonNames;
}
-(void) setDialogHighlightlNames:(NSArray<id> *)dialogHighlightlNames{
    if(!dialogHighlightlNames || dialogHighlightlNames.count == 0)
        [self paramDialog].hightLightedButtonNames = nil;
    else if([dialogHighlightlNames.firstObject isKindOfClass:[NSAttributedString class]])
        [self paramDialog].hightLightedButtonNames = dialogHighlightlNames;
    else if([dialogHighlightlNames.firstObject isKindOfClass:[NSString class]])
        [self paramDialog].hightLightedButtonNames = [PYDialogParam parseHihtLightedButtonName:dialogHighlightlNames];
    else [self paramDialog].hightLightedButtonNames = nil;
}
-(NSArray<id> *) dialogHighlightlNames{
    return [self paramDialog].hightLightedButtonNames;
}
-(void) setDialogOptBlock:(PYBlockPopupV_P_V_I)dialogOptBlock{
    [self paramDialog].blockDialogOpt = dialogOptBlock;
}
-(PYBlockPopupV_P_V_I) dialogOptBlock{
    return [self paramDialog].blockDialogOpt;
}
-(NSTextAlignment) dialogMessageTextAlignment{
    UIView * view = [self paramDialog].messageView;
    if(![view isKindOfClass:[PYDialogMessageView class]]) return NSTextAlignmentLeft;
    return ((PYDialogMessageView *) view).textAlignment;
}
-(void) setDialogMessageTextAlignment:(NSTextAlignment)textAlignment{
    UIView * view = [self paramDialog].messageView;
    if(![view isKindOfClass:[PYDialogMessageView class]]) return;
    ((PYDialogMessageView *) view).textAlignment = textAlignment;
}

-(void) __dialogShowConfirm:(BOOL) confirm{
    CGSize dialogSize = self.dialogMessage ? [[self paramDialog] updateMessageView] : CGSizeZero;
    if(CGSizeEqualToSize(dialogSize, CGSizeZero)){
        dialogSize = self.frameSize;
    }
    CGSize titleSize = self.dialogTitle ? [[self paramDialog] updateTitleView] : CGSizeZero;
    CGSize buttonSize = [[self paramDialog] updateButtonView:dialogSize.width confirm:confirm];
    
    [[self paramDialog] mergeTargetView];
    self.dialogShowView.frameSize = CGSizeMake(MAX(MAX(MAX(titleSize.width, STATIC_DIALOG_MINWIDTH), dialogSize.width), buttonSize.width) ,  titleSize.height + dialogSize.height + buttonSize.height);
    [self.superview sendSubviewToBack:self];
    kAssign(self);
    self.dialogShowView.popupBlockEnd = ^(UIView * _Nullable view) {
        kStrong(self);
        [[self paramDialog] clearTargetView];
        [self removeFromSuperview];
    };
    ((PYMoveView *)self.dialogShowView).blockTouchEnded = ^(CGPoint touhMove, UIView * _Nonnull touchView) {
        [UIView beginAnimations:nil context:nil]; // 开始动画
        [UIView setAnimationDuration:.5]; // 动画时长
        touchView.transform = CGAffineTransformIdentity;//CGAffineTransformTranslate(touchView.transform, -p.x, -p.y);
        [UIView commitAnimations];
    };
    self.dialogShowView.popupBaseView = self.popupBaseView;
    [self.dialogShowView popupShow];
}
-(void) dialogShow{
    [self __dialogShowConfirm:NO];
}

-(void) dialogShowWithTitle:(nullable NSString *) title
                        message:(nullable NSString *) message
                        block:(nonnull PYBlockPopupV_P_V_B) block
                        buttonConfirm:(nullable NSString*) buttonConfirm
                        buttonCancel:(nullable NSString*) buttonCancel{
    self.dialogTitle = title;
    self.dialogMessage = message;
    self.dialogNormalNames = [PYDialogParam parseConfrimName:buttonConfirm cancelName:buttonCancel];
    self.dialogHighlightlNames = [PYDialogParam parseConfrimName:buttonConfirm cancelName:buttonCancel];
    self.dialogOptBlock = ^(UIView * _Nonnull view, NSUInteger index) {
        if([NSString isEnabled:buttonConfirm]) block(view, index == 0);
        else block(view, NO);
    };
    [self __dialogShowConfirm:YES];
}

-(void) dialogShowWithTitle:(nullable NSString *) title message:(nullable NSString *) message block:(nullable PYBlockPopupV_P_V_I) block buttonNames:(nonnull NSArray<NSString*>*)buttonNames{
    self.dialogTitle = title;
    self.dialogMessage = message;
    self.dialogNormalNames = buttonNames;
    self.dialogHighlightlNames = buttonNames;
    self.dialogOptBlock = block;
    [self dialogShow];
}

-(void) dialogShowWithAttributeTitle:(nullable NSAttributedString *) attributeTitle attributeMessage:(nullable NSAttributedString *) attributeMessage block:(nullable PYBlockPopupV_P_V_I) block buttonNormalNames:(nonnull NSArray<NSAttributedString*>*)buttonNormalNames buttonHightLightNames:(nonnull NSArray<NSAttributedString*>*)buttonHightLightNames{
    [self paramDialog].attributeTitle = attributeTitle;
    [self paramDialog].attributeMessage = attributeMessage;
    [self paramDialog].normalButtonNames = buttonNormalNames;
    [self paramDialog].hightLightedButtonNames = buttonHightLightNames;
    self.dialogOptBlock = block;
    [self dialogShow];
}


-(void) dialogShowWithTitle:(nullable NSString *) title block:(nullable PYBlockPopupV_P_V_I) block buttonNames:(nonnull NSArray<NSString*>*)buttonNames{
    self.dialogTitle = title;
    self.dialogNormalNames = buttonNames;
    self.dialogHighlightlNames = buttonNames;
    self.dialogOptBlock = block;
    [self dialogShow];
}

-(void) dialogShowWithAttributeTitle:(nullable NSAttributedString *) attributeTitle block:(nullable PYBlockPopupV_P_V_I) block buttonNormalNames:(nonnull NSArray<NSAttributedString*>*)buttonNormalNames buttonHightLightNames:(nonnull NSArray<NSAttributedString*>*)buttonHightLightNames{
    self.dialogTitle = attributeTitle;
    self.dialogNormalNames = buttonNormalNames;
    self.dialogHighlightlNames = buttonHightLightNames;
    self.dialogOptBlock = block;
    [self dialogShow];
}

-(void) dialogHidden{
    [self.dialogShowView popupHidden];
}

-(void) diloagOnclick:(UIButton*) sender{
    PYBlockPopupV_P_V_I block = self.dialogOptBlock;
    if (block) {
        block(self,sender.tag);
    }
}
-(PYDialogParam *) paramDialog{
    PYDialogParam * param = objc_getAssociatedObject(self, PYDialogPointer);
    if(param == nil){
        param = [[PYDialogParam alloc] initWithTarget:self action:@selector(diloagOnclick:)];
        objc_setAssociatedObject(self, PYDialogPointer, param, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return param;
}
@end


