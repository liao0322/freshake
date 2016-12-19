//
//  MyCouponView.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/12/6.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "KTableView.h"

@interface MyCouponView : KTableView

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, assign) BOOL isSelectCoupon;

@property (nonatomic, strong) void(^selectGoodsCoupon)(NSString *priceString, NSString *ID, BOOL isSelect, NSInteger index);
@property (nonatomic, strong) void(^selectCoupon)(NSString *priceString, NSString *ID, BOOL isSelect);
@property (nonatomic, strong) void(^goViewController)(UIViewController *viewController);

@end
