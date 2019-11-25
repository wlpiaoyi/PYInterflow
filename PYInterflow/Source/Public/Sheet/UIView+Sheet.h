//
//  UIView+Sheet.h
//  PYInterflow
//
//  Created by wlpiaoyi on 2016/12/6.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pyutilea.h"
#import "PYInterflowParams.h"

@interface UIView(Sheet)
kPNRNN UIView * sheetShowView;
kPNCNA NSArray<NSNumber *> * sheetIndexs;
kPNCNA BOOL (^sheetBlockSelecting) (NSMutableArray<NSNumber *> * _Nonnull  beforeIndexs, NSUInteger cureentIndex);
kPNA BOOL sheetIsHiddenOnClick;
-(void) sheetShow;
-(void) sheetShowWithTitle:(nullable NSString *) title
            previousName:(nullable NSString *) previousName
            nextName:(nullable NSString *) nextName
            blockOpt:(nullable PYBlockPopupV_P_V_I) blcokOpt;
-(void) sheetShowWithTitle:(nullable NSString *) title
            buttonConfirme:(nullable NSString *) confirme
            buttonCancel:(nullable NSString *) canel
            itemStrings:(nullable NSArray<NSString *> *) itemStrings
            blockOpt:(nullable PYBlockPopupV_P_V_I) blcokOpt
            blockSelected:(void (^ _Nullable)(UIView * _Nullable view,  NSUInteger index)) blcokSelected;
-(void) sheetShowWithTitle:(nullable NSString *) title
            buttonConfirme:(nullable NSString *) confirme
            buttonCancel:(nullable NSString *) canel
            itemStrings:(nullable NSArray<NSString *> *) itemStrings
            blockOpts:(nullable PYBlockPopupV_P_V_I) blcokOpts
            blockSelecteds:(nullable PYBlockPopupB_P_V) blockSelecteds;
-(void) sheetHidden;
@end
