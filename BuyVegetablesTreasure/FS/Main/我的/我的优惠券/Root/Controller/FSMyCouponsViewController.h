//
//  FSMyCouponsViewController.h
//  BuyVegetablesTreasure
//
//  Created by 江玉元 on 2016/12/21.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSMyCouponsViewController : UIViewController
@property (nonatomic, assign) BOOL isSelectCoupon;

@property (nonatomic, copy) NSArray *couponArray;
@property (nonatomic, copy) void(^selectCoupon)(NSString *priceString, NSString *ID, BOOL isSelect);
@property (nonatomic, copy) void(^selectGoodsCoupon)(NSString *priceString, NSString *ID, BOOL isSelect, NSInteger index);


@end
