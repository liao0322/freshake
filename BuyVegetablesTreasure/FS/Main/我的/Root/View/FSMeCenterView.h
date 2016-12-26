//
//  FSMeCenterView.h
//  BuyVegetablesTreasure
//
//  Created by 江玉元 on 2016/12/13.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FSMeCenterView;

@protocol FSMeCenterViewDelegate <NSObject>

- (void)fsCenterView:(FSMeCenterView *)fsCenterView allOrderButtonClick:(UIButton *)sender;

@end

@interface FSMeCenterView : UIView

@property (nonatomic, weak) id<FSMeCenterViewDelegate> delegate;

@end
