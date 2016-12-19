//
//  MyOrderDetailsModel.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/9/5.
//
//

#import "ParentModel.h"

@interface MyOrderDetailsModel : ParentModel

@property (nonatomic, copy) NSString *Id;
/// 下单时间
@property (nonatomic, copy) NSString *add_time;
/// 地址
@property (nonatomic, copy) NSString *addr;
/// 地址
@property (nonatomic, copy) NSString *address;
/// 发货状态
@property (nonatomic, copy) NSString *express_status;
/// 分店(店铺)
@property (nonatomic, copy) NSString *fendian;
/// 留言
@property (nonatomic, copy) NSString *message;
/// 合计
@property (nonatomic, copy) NSString *order_amount;
/// 应付金额
@property (nonatomic, copy) NSString *payable_amount;
/// 支付状态    1.未支付   2.已支付
@property (nonatomic, copy) NSString *payment_status;
/// 配送状态    (送货上门、到店自提)
@property (nonatomic, copy) NSString *express_id;
/// 配送费用
@property (nonatomic, copy) NSString *express_fee;
/// 提货时间
@property (nonatomic, copy) NSString *picktime;
/// 订单状态    1.待付款   2.待提货   3.已提货
@property (nonatomic, copy) NSString *status;
/// 电话
@property (nonatomic, copy) NSString *tel;
/// 联系方式
@property (nonatomic, copy) NSString *telphone;
/// 预约人（提货人)
@property (nonatomic, copy) NSString *username;
/// 提货码
@property (nonatomic, copy) NSString *order_no;
/// 剩余支付时间
@property (nonatomic, copy) NSString *RemainingTime;
/// 优惠
@property (nonatomic, copy) NSString *order_AwardAmount;
/// 商家ID
@property (nonatomic, copy) NSString *mid;
/// 发票抬头
@property (nonatomic, copy) NSString *InvoiceTitle;
/// 发票内容
@property (nonatomic, copy) NSString *InvoiceContent;
/// 送货时间
@property (nonatomic, copy) NSString *DeliveryTime;
/// 支付方式
@property (nonatomic, copy) NSString *payment_id;
/// 商品数组
@property (nonatomic, copy) NSArray *list;
/// 积分
@property (nonatomic, copy) NSString *point;

@end
