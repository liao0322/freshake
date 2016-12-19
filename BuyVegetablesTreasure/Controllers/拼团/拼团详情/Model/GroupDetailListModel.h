//
//  GroupDetailListModel.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/4/11.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "ParentModel.h"

@interface GroupDetailListModel : ParentModel

@property (nonatomic, copy) NSString *AddTime ;     // 加入时间
@property (nonatomic, copy) NSString *avatar ;      //
@property (nonatomic, copy) NSString *CName ;       // ,
@property (nonatomic, copy) NSString *fendianId ;   // 提货点ID
@property (nonatomic, copy) NSString *id ;          //
@property (nonatomic, copy) NSString *IsAdd ;       // 是否开团
@property (nonatomic, copy) NSString *IsPay ;       // 是否支付
@property (nonatomic, copy) NSString *Order_No ;    // 订单号
@property (nonatomic, copy) NSString *PaymentPrice ;// 支付价格
@property (nonatomic, copy) NSString *PickAddress ; // 地址
@property (nonatomic, copy) NSString *PickMobile ;  // 手机
@property (nonatomic, copy) NSString *PickUserName ;// 用户名
@property (nonatomic, copy) NSString *Sid ;         // 商家ID
@property (nonatomic, copy) NSString *status ;      // 状态
@property (nonatomic, copy) NSString *userName ;    // 用户昵称
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *STime;
@property (nonatomic, copy) NSString *PayTime;
@property (nonatomic, copy) NSString *mobile;

@end
