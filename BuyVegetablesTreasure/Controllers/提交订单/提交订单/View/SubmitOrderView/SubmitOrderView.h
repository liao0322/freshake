//
//  SubmitOrderView.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/10/19.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubmitOrderView : UIView

// 模型
@property (nonatomic, strong) id model;
/// 自提状态
@property (nonatomic, assign) BOOL deliveryStatus;
/// 配送状态
@property (nonatomic, assign) BOOL distributionStatus;
/// 优惠券数量
@property (nonatomic, assign) NSInteger numberOfCoupons;
/// 商品
@property (nonatomic, strong) NSArray *goodsArray;
/// 商品优惠券
@property (nonatomic, strong) NSArray *couponArray;
/// 商品总价
@property (nonatomic, assign) CGFloat totalPrice;
/// 可用积分
@property (nonatomic, assign) NSInteger integral;
/// 是否立即购买
@property (nonatomic, assign) BOOL buySoon;
/// 付款信息
@property (nonatomic, strong) void(^payInfo)(NSDictionary *payInfoDic);

#pragma mark - 收藏
/// 是否收藏
@property (nonatomic, assign) BOOL isCollect;
/// 分店ID
@property (nonatomic, strong) NSString *fendianId;
/// 商家ID
@property (nonatomic, strong) NSString *midString;
/// 分店地址
@property (nonatomic, strong) NSString *fendianAddress;

@property (nonatomic, strong) void(^goViewController)(UIViewController *viewController);

@end
