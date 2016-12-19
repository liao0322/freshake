//
//  GroupDetailModel.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/4/11.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "ParentModel.h"

@interface GroupDetailModel : ParentModel

@property (nonatomic, copy) NSString *ActivityEtime ;   // 活动结束时间
@property (nonatomic, copy) NSString *ActivityId ;      // 7,
@property (nonatomic, copy) NSString *ActivityName ;    // ,
@property (nonatomic, copy) NSString *ActivityPrice ;   // 团购价格,
@property (nonatomic, copy) NSString *ActivityStime ;   // 活动开始时间
@property (nonatomic, copy) NSString *ActivityUserNum ; // 团购人数
@property (nonatomic, copy) NSString *AddDate ;         // 创建有效期(分钟)
@property (nonatomic, copy) NSString *IsPay ;           // 是否支付
@property (nonatomic, copy) NSString *Order_No ;        // 订单号
@property (nonatomic, copy) NSString *PayDdate ;        // 支付有效期（分钟）
@property (nonatomic, copy) NSString *STime ;           // 0,
@property (nonatomic, copy) NSString *Sid ;             // 商家ID
@property (nonatomic, copy) NSString *Specifications ;  // 20,
@property (nonatomic, copy) NSString *UserId ;          // 用户ID
@property (nonatomic, copy) NSString *id ;              // 44,
@property (nonatomic, copy) NSString *productId ;       // 商品Id
@property (nonatomic, copy) NSString *productName ;     // 商品名
@property (nonatomic, copy) NSString *salePrice ;       // 商品原价
@property (nonatomic, copy) NSString *shortDesc ;       // 商品说明
@property (nonatomic, copy) NSString *status ;          // 状态 1,新团 2.组团中 3,成功 4，失败
@property (nonatomic, copy) NSString *thumbnailsUrll ;  // 商品图片
@property (nonatomic, copy) NSMutableArray *listArray;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *PayTime;
@property (nonatomic, copy) NSString *UStatus;
@property (nonatomic, copy) NSString *express_id;

@end

