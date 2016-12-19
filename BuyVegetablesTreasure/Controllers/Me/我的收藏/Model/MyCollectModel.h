//
//  MyCollectModel.h
//  BuyVegetablesTreasure
//
//  Created by XiaoBeiMAC on 15/12/10.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCollectModel : NSObject

@property (nonatomic, strong) NSString *StroreId;
// 商品ID
@property (nonatomic, strong) NSString *id;
// 关联关系ID
@property (nonatomic, strong) NSString *Tid;
// 商品图片
@property (nonatomic, strong) NSString *imgUrl;
// 商家ID
@property (nonatomic, strong) NSString *mid;
// 价格
@property (nonatomic, strong) NSString *price;
// 会员价格
@property (nonatomic, strong) NSString *UserPrice;
// 商品名称
@property (nonatomic, strong) NSString *productName;
// 分店名称
@property (nonatomic, strong) NSString *fendianname;
// 取货时间
@property (nonatomic, strong) NSString *picktime;
// 取货地址
@property (nonatomic, strong) NSString *addr;
// 是否下架 0、仓库 1、上架
@property (nonatomic, strong) NSString *upselling;

@end
