//
//  FSMyCouponView.h
//  BuyVegetablesTreasure
//
//  Created by 江玉元 on 2016/12/21.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSJTableView.h"

@interface FSMyCouponView : FSJTableView

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, assign) BOOL isSelectCoupon;

@property (nonatomic, strong) void(^selectGoodsCoupon)(NSString *priceString, NSString *ID, BOOL isSelect, NSInteger index);

@property (nonatomic, strong) void(^selectCoupon)(NSString *priceString, NSString *ID, BOOL isSelect);
@property (nonatomic, strong) void(^goViewController)(UIViewController *viewController);

@end
