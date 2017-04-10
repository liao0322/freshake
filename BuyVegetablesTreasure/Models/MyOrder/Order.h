//
//  Order.h
//  BuyVegetablesTreasure
//
//  Created by ky on 15/10/28.
//  Copyright (c) 2015年 c521xiong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Order : NSObject

// 是否评价
@property (nonatomic, copy) NSString *evaluation;
@property(nonatomic,copy)NSString *express_status;//发货状态（0.立即支付，1.未支付2.已支付）
@property(nonatomic,copy)NSNumber *Id;  //自增ID
@property(nonatomic,copy)NSMutableArray *List;
@property(nonatomic,copy)NSString *isContext;
@property(nonatomic,copy)NSNumber *order_amount;//订单总金额
@property(nonatomic,copy)NSString *order_no;//订单号
@property(nonatomic,copy)NSString *payment_status; //支付状态（1.未支付2.已支付）
@property(nonatomic,copy)NSString *paymentName;//支付方式
@property(nonatomic,copy)NSString *status;//订单状态（1.生成订单，2.确认订单，3.完成订单）
@property(nonatomic,copy)NSNumber *payment_id;
@property(nonatomic,copy)NSNumber *payable_amount;//订单实际价格
@property(nonatomic,copy)NSNumber *sid;//订单所属商家ID
@property(nonatomic,copy)NSNumber *goods_price;

@property(nonatomic,copy)NSString *prepayid;
@property(nonatomic,copy)NSString *nonce_str;
@property(nonatomic,copy)NSString *time_stamp;
@property (copy, nonatomic) NSString *sourceCode;

@property (copy, nonatomic) NSString *express_id;

@end
