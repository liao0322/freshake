//
//  Single.h
//  BuyVegetablesTreasure
//
//  Created by ky on 15/10/23.
//  Copyright (c) 2015年 c521xiong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Address.h"
#import "Map.h"

typedef NS_ENUM(NSInteger,PayType) {
    AmountPlay  = 2,
    AliPay      = 3,
    WeCartPay   = 4,
};

@interface Single : NSObject

/**
 *  单例模式
 */
+ (Single *)sharedInstance;

/**
 验证码
 */
@property (nonatomic, strong) NSString *coder;

@property (nonatomic, strong) NSString *paytype;

@property (nonatomic, assign) BOOL isShowSite;

@property (nonatomic, assign) BOOL isGoodsNum;

@property (nonatomic, assign) Address *address;

@property (nonatomic, assign) NSInteger level;

@property (nonatomic, assign) BOOL isRefreshTitle;

@property (nonatomic, assign) BOOL isBalance;

@property (nonatomic, assign) BOOL isDelivery;

@property (nonatomic, assign) BOOL isLoadAdvertising;

@property (nonatomic, strong) NSString *notify_url;

@property (nonatomic, assign) PayType payMent;

@property (nonatomic, assign) CGFloat totalPrice;

@property (nonatomic, strong) NSString *cityId;

@property (nonatomic, assign) BOOL isdeliverTime;

@property (nonatomic, assign) BOOL isUpdateGoods;

#pragma mark - 支付
// 配送费用
@property (nonatomic, assign) CGFloat freight;
/// 用户名
@property (nonatomic, strong) NSString *userName;
/// 联系方式
@property (nonatomic, strong) NSString *userTel;
/// 备注
@property (nonatomic, strong) NSString *remark;
// 发票抬头
@property (nonatomic, strong) NSString *invoiceTitle;
// 发票内容
@property (nonatomic, strong) NSString *invoiceContent;

- (void)setPointModel:(Map *)model;

@end
