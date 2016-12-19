//
//  NumView.h
//  BuyVegetablesTreasure
//
//  Created by Song on 16/4/20.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeModel.h"

@interface NumView : UIView



@property(nonatomic,copy)void(^btnBlock)(NSInteger tag);
/**
 可用积分
 */
@property (nonatomic, copy) UILabel *pointLabel;
/**
 余额
 */
@property (nonatomic, copy) UILabel *balanceLabel;
/**
 优惠券
 */
@property (nonatomic, copy) UILabel *couponLabel;


@property(nonatomic,copy)UIButton *button;


-(void)setData:(MeModel *)model;

@end
