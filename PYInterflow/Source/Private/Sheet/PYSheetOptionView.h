//
//  PYSheetOptionView.h
//  PYInterflow
//
//  Created by wlpiaoyi on 2019/3/26.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PYSheetOptionView : UIView
+(nonnull instancetype) instanceWithTitle:(nullable NSAttributedString *) title
                            previousName:(nullable NSAttributedString *) previousName
                            nextName:(nullable NSAttributedString *) nextName
                            blockOpt:(void (^ _Nullable)(NSUInteger index)) blcokOpt;
-(void) addSheetView:(nonnull UIView *) view;
-(void) removeSheetView;
@end

