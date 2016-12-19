//
//  MyCouponsViewController.h
//  BuyVegetablesTreasure
//
//  Created by XiaoBeiMAC on 15/11/5.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCouponsViewController : UIViewController

@property (nonatomic, assign) BOOL isSelectCoupon;

@property (nonatomic, copy) NSArray *couponArray;
@property (nonatomic, copy) void(^selectCoupon)(NSString *priceString, NSString *ID, BOOL isSelect);
@property (nonatomic, copy) void(^selectGoodsCoupon)(NSString *priceString, NSString *ID, BOOL isSelect, NSInteger index);


@end
