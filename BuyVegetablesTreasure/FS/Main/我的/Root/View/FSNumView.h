//
//  FSNumView.h
//  BuyVegetablesTreasure
//
//  Created by 江玉元 on 2016/12/13.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSMeModel.h"

@interface FSNumView : UIView

@property (nonatomic, copy) void(^btnBlock)(NSInteger tag);

@property (nonatomic, copy) UILabel *pointLabel;    // 可用积分

@property (nonatomic, copy) UILabel *balanceLabel; // 余额

@property (nonatomic, copy) UILabel *couponLabel; // 优惠券

@property (nonatomic, copy) UIButton *button; 

- (void)setData:(FSMeModel *)model;

@end
