//
//  PaymentViewController.h
//  BuyVegetablesTreasure
//
//  Created by sc on 15/10/15.
//  Copyright (c) 2015年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AffirmPayment.h"
#import "WXApi.h"

@interface PaymentViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,WXApiDelegate>

@property (nonatomic, copy) NSString *goodsName;    // 商品名称
@property (nonatomic, copy) NSString *goodsStoreID;
@property (nonatomic, copy) NSString *Gaddress;
@property (nonatomic, copy) NSString *fendianName;
@property (nonatomic, copy) NSString *midStr;
@property (nonatomic, copy) NSString *pickTime;
@property (nonatomic, copy) NSString *pickJuli;
// 购物车商品
@property (nonatomic, copy) NSArray *cartGoods;

@property (nonatomic, assign) BOOL isCollect;       // 是否是收藏的立即购买
@property (nonatomic, assign) BOOL BuySoon;         // 是否立即购买
@property (nonatomic, assign) float goodsPrice;     // 商品单价
@property (nonatomic, assign) float price;          // 商品的总价格
@property (nonatomic, assign) NSInteger goodsId;    // 商品ID
@property (nonatomic, assign) NSInteger goodsNum;   // 商品数量

@property (nonatomic, copy) AffirmPayment *affirmPayment;

@end
