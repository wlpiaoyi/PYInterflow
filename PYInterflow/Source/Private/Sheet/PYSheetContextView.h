//
//  PYSheetContextView.h
//  PYInterflow
//
//  Created by wlpiaoyi on 2019/2/8.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import "pyutilea.h"

NS_ASSUME_NONNULL_BEGIN

@interface PYSheetContextView : UIView

kPNSNA NSArray<NSNumber *> * selectes;
kPNAR BOOL multipleSelected;
kPNRNN NSArray<NSAttributedString *> * items;
kPNRNN NSArray<NSAttributedString *> * options;

kPNCNA BOOL (^blockSelectedItems) (PYSheetContextView * _Nonnull contextView);
kPNCNA void (^blockSelectedOptions) (PYSheetContextView * _Nonnull contextView, NSUInteger index);
kPNCNA BOOL (^blockOnSelecting)(NSMutableArray<NSNumber *> * _Nonnull  beforeIndexs, NSUInteger cureentIndex);

-(void) synFrame;

+(nullable instancetype) instanceWithTitle:(nullable NSAttributedString *) title
                                items:(nonnull NSArray<NSAttributedString *> *) items
                                selectes:(nullable NSArray<NSNumber *> *) selectes
                                options:(nullable NSArray<NSAttributedString *> *) options
                                multipleSelected:(BOOL) multipleSelected;

@end

NS_ASSUME_NONNULL_END
