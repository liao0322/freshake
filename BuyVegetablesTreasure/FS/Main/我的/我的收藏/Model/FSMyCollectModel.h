//
//  FSMyCollectModel.h
//  BuyVegetablesTreasure
//
//  Created by 江玉元 on 2016/12/23.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSMyCollectModel : NSObject

@property (nonatomic, strong) NSString *StroreId;

@property (nonatomic, strong) NSString *id;         // 商品ID

@property (nonatomic, strong) NSString *Tid;        // 关联关系ID

@property (nonatomic, strong) NSString *imgUrl;     // 商品图片

@property (nonatomic, strong) NSString *mid;        // 商家ID

@property (nonatomic, strong) NSString *price;      // 价格

@property (nonatomic, strong) NSString *UserPrice;  // 会员价格

@property (nonatomic, strong) NSString *productName;// 商品名称

@property (nonatomic, strong) NSString *fendianname;// 分店名称

@property (nonatomic, strong) NSString *picktime;   // 取货时间

@property (nonatomic, strong) NSString *addr;       // 取货地址

@property (nonatomic, strong) NSString *upselling;  // 是否下架 0、仓库 1、上架


@end
