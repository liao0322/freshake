//
//  MyGroupModel.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/4/11.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "ParentModel.h"

@interface MyGroupModel : ParentModel

@property (nonatomic, copy) NSString *ActivityId ;      // 参团商品ID
@property (nonatomic, copy) NSString *ActivityName ;    // 参团商品
@property (nonatomic, copy) NSString *ActivityPrice ;   // 参团价格
@property (nonatomic, copy) NSString *ActivityUserNum ; // 参团人数
@property (nonatomic, copy) NSString *AddTime ;         // /Date(1460096067000+0800)/,
@property (nonatomic, copy) NSString *AddUserId ;       // 参团ID
@property (nonatomic, copy) NSString *AddUserName ;     // Kai,
@property (nonatomic, copy) NSString *Id ;              // 活动订单Id
@property (nonatomic, copy) NSString *IsAdd ;           // 是否创建者
@property (nonatomic, copy) NSString *IsPay ;           // 是否支付
@property (nonatomic, copy) NSString *Order_No ;        // 订单号
@property (nonatomic, copy) NSString *PaymentExpenses ; // 0,
@property (nonatomic, copy) NSString *PaymentId ;       // 4,
@property (nonatomic, copy) NSString *PaymentPrice ;    // 支付金额
@property (nonatomic, copy) NSString *PickAddress ;     // 地址 - 配送
@property (nonatomic, copy) NSString *PickMobile ;      // 手机号 - 配送
@property (nonatomic, copy) NSString *PickUserName ;    // 用户名 - 配送
@property (nonatomic, copy) NSString *ProductId ;       // 用户名ID - 配送
@property (nonatomic, copy) NSString *Remark ;          // 备注
@property (nonatomic, copy) NSString *Sid ;             // 商家ID
@property (nonatomic, copy) NSString *Specifications ;  // 44,
@property (nonatomic, copy) NSString *Trade_no ;        // ,
@property (nonatomic, copy) NSString *UserId ;          // 开团用户ID
@property (nonatomic, copy) NSString *UserName ;        // 开团用户名
@property (nonatomic, copy) NSString *express_fee ;     // 配送价格
@property (nonatomic, copy) NSString *express_id ;      // 配送方式
@property (nonatomic, copy) NSString *fendianId ;       // 自提点Id
@property (nonatomic, copy) NSString *productName ;     // 商品名称
@property (nonatomic, copy) NSString *shortDesc ;       // ,
@property (nonatomic, copy) NSString *status ;          // 状态 1,新团 2.组团中 3,成功 4，失败
@property (nonatomic, copy) NSString *thumbnailsUrll ;  // 商品图片

@end
