//
//  MyOrderModel.m
//  BuyVegetablesTreasure
//
//  Created by sc on 16/3/15.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "MyOrderModel.h"

@implementation MyOrderModel

- (void)setDic:(NSDictionary *)dic {
    
    _CompleteCount = dic[@"CompleteCount"];
    _EvaluateCount = dic[@"EvaluateCount"];
    _NoPaymentCount = dic[@"NoPaymentCount"];
    _NoPickupCount = dic[@"NoPickupCount"];
    _OrderCount = dic[@"OrderCount"];
}

@end
