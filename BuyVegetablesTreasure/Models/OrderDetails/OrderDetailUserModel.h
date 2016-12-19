//
//  OrderDetailUserModel.h
//  BuyVegetablesTreasure
//
//  Created by XiaoBeiMAC on 15/10/29.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderDetailUserModel : NSObject

@property (nonatomic, copy) NSString *add_time;         //下单时间
@property (nonatomic, copy) NSString *address;          //地址
@property (nonatomic, copy) NSNumber *express_status;   //发货状态
@property (nonatomic, copy) NSString *fendian;          //分店(店铺)
@property (nonatomic, copy) NSString *message;          //留言
@property (nonatomic, copy) NSString *order_amount;     //合计
@property (nonatomic, copy) NSString *payable_amount;   //应付金额
@property (nonatomic, copy) NSNumber *payment_status;   //支付状态
@property (nonatomic, copy) NSNumber *express_id;      //送货上门、到店自提
@property (nonatomic, copy) NSString *express_fee;
@property (nonatomic, copy) NSString *picktime;         //提货时间
@property (nonatomic, copy) NSNumber *status;           //订单状态
@property (nonatomic, copy) NSString *tel;              //电话
@property (nonatomic, copy) NSString *telphone;         //联系方式
@property (nonatomic, copy) NSString *username;         //预约人（提货人）
@property (nonatomic, copy) NSString *order_no;         //提货码
@property (nonatomic, copy) NSString *RemainingTime;    //剩余支付时间
@property (nonatomic, copy) NSNumber *order_AwardAmount;//优惠
@property (nonatomic, copy) NSString *mid;              //商家ID
@property (nonatomic, copy) NSMutableArray *list;
@property (nonatomic, copy) NSString *InvoiceTitle;     //发票头
@property (nonatomic, copy) NSString *InvoiceContent;   //发票内容
@property (nonatomic, copy) NSString *DeliveryTime;     // 送货时间

@property (nonatomic, copy) NSNumber *payment_id;
@property (nonatomic, copy) NSString *prepayid;
@property (nonatomic, copy) NSString *nonce_str;
@property (nonatomic, copy) NSString *time_stamp;

@property (nonatomic,assign,readonly) CGFloat addressHeight;
@property (nonatomic,assign,readonly) CGFloat messageHeight;
@property (nonatomic,assign,readonly) CGFloat InvoiceTitleHeight;
@property (nonatomic,assign,readonly) CGFloat InvoiceContentHeight;

@end
