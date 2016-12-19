//
//  FSCommodityModel.h
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/16.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSBaseModel.h"

@interface FSCommodityModel : FSBaseModel

@property (nonatomic, copy) NSString *BuyNum;// 0,
@property (nonatomic, copy) NSString *FreeNum;// 0,
@property (nonatomic, copy) NSString *CartNum;
@property (nonatomic, copy) NSString *categoryId ;// 20,
@property (nonatomic, copy) NSString *id ;// 33,
@property (nonatomic, copy) NSString *imgUrl ;// ,
@property (nonatomic, copy) NSString *marketPrice ;// 1,
@property (nonatomic, copy) NSString *productName ;// fasdf,
@property (nonatomic, copy) NSString *salePrice ;// 1,
@property (nonatomic, copy) NSString *shortDesc ;// ,
@property (nonatomic, copy) NSString *sku ;// asdf,
@property (nonatomic, copy) NSString *stock ;// 1
@property (nonatomic, copy) NSString *SoldStock;
// 会员价格
@property (nonatomic, copy) NSString *UserPrice;
// 是否特价
@property (nonatomic, copy) NSString *IsSpecialOffer;
// 特价内容
@property (nonatomic, copy) NSString *specialOfferContext;

@property (nonatomic, copy) NSString *PurchaseNum;      // 限购数量
@property (nonatomic, copy) NSString *PurchasedNum;     // 已购数量
@property (nonatomic, copy) NSString *PurchaseETime;    // 限购剩余时间
@property (nonatomic, copy) NSString *PurchaseSTime;    // 限购开始时间

@end
