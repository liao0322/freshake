//
//  SureOrder.h
//  BuyVegetablesTreasure
//
//  Created by ky on 15/11/10.
//  Copyright (c) 2015年 c521xiong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SureOrder : NSObject

@property (nonatomic, copy) NSString *context;
@property (nonatomic, copy) NSString *notify_url;
@property (nonatomic, copy) NSString *order_no;
@property (nonatomic, copy) NSString *pruductName;
@property (nonatomic, copy) NSString *totalPrice;

@end
