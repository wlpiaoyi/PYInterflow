//
//  PYSheetItemsView.h
//  PYInterflow
//
//  Created by wlpiaoyi on 2019/2/8.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import "pyutilea.h"

NS_ASSUME_NONNULL_BEGIN

@interface PYSheetItemsView : UIView

kPNAR BOOL multipleSelected;
kPNRNN NSArray<NSAttributedString *> * items;
kPNSNA NSArray<NSNumber *> * selectes;
kPNA BOOL scrollEnabled;

kPNCNA BOOL (^blockBeforeSelectedItems) (PYSheetItemsView * _Nonnull contextView);
kPNCNA void (^blockAfterSelectedItems) (PYSheetItemsView * _Nonnull contextView);
kPNCNA BOOL (^blockOnSelecting)(NSMutableArray<NSNumber *> * _Nonnull  beforeIndexs, NSUInteger cureentIndex);

+(nullable instancetype) instanceWithItems:(nonnull NSArray<NSAttributedString *> *) items
                                selectes:(nullable NSArray<NSNumber *> *) selectes
                                multipleSelected:(BOOL) multipleSelected;

+(CGFloat) getHeight:(CGFloat) width items:(nonnull NSArray<NSAttributedString *> *) items;

@end

NS_ASSUME_NONNULL_END
