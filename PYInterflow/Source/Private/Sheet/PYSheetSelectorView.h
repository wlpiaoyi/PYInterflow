//
//  PYSheetSelectorView.h
//  PYInterflow
//
//  Created by wlpiaoyi on 2019/2/8.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import "pyutilea.h"


@interface PYSheetSelectorView : UIView

kPNSNA NSArray<NSNumber *> * selectes;
kPNAR BOOL multipleSelected;
kPNRNN NSArray<NSAttributedString *> * items;
kPNRNN NSArray<NSAttributedString *> * options;

kPNCNA void (^blockSelectedOptions) (PYSheetSelectorView * _Nonnull contextView, NSUInteger index);
kPNCNA BOOL (^blockSelecting)(BOOL isSelected, NSUInteger cureentIndex);

-(void) synFrame;

+(nullable instancetype) instanceWithTitle:(nullable NSAttributedString *) title
                                items:(nonnull NSArray<NSAttributedString *> *) items
                                selectes:(nullable NSArray<NSNumber *> *) selectes
                                options:(nullable NSArray<NSAttributedString *> *) options
                                multipleSelected:(BOOL) multipleSelected;

@end

