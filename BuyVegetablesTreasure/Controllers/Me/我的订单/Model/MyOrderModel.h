//
//  MyOrderModel.h
//  BuyVegetablesTreasure
//
//  Created by sc on 16/3/15.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyOrderModel : NSObject

@property (nonatomic, copy) NSNumber *OrderCount;       // 订单总数
@property (nonatomic, copy) NSNumber *NoPaymentCount;   // 待付款
@property (nonatomic, copy) NSNumber *NoPickupCount;    // 待提货
@property (nonatomic, copy) NSNumber *CompleteCount;    // 已提货
@property (nonatomic, copy) NSNumber *EvaluateCount;    // 待评价

- (void)setDic:(NSDictionary *)dic;

@end
