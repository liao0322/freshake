//
//  Pruduct.h
//  BuyVegetablesTreasure
//
//  Created by ky on 15/10/27.
//  Copyright (c) 2015年 c521xiong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParentModel.h"

@interface Pruduct : ParentModel


@property(nonatomic,copy)NSMutableArray *albums;
@property(nonatomic,copy)NSMutableArray *attr;

@property(nonatomic,copy)NSString *brandId;
@property(nonatomic,copy)NSString *brandName;
@property(nonatomic,copy)NSString *CartNum;
@property(nonatomic,copy)NSString *catalogId;
@property(nonatomic,copy)NSString *catalogName;
@property(nonatomic,copy)NSString *categoryId;
@property(nonatomic,copy)NSString *categoryName;
@property(nonatomic,copy)NSString *costPrice;
@property(nonatomic,copy)NSArray  *descriptions;
@property(nonatomic,copy)NSString *descriptionUrl;
@property(nonatomic,copy)NSString *ExpiryEndDate;
@property(nonatomic,copy)NSString *focusImgUrl;
@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *marketPrice;
@property(nonatomic,copy)NSString *messger;
@property(nonatomic,copy)NSString *productName;
@property(nonatomic,copy)NSString *salePrice;
@property(nonatomic,copy)NSString *shortDesc;
@property(nonatomic,copy)NSString *sku;
@property(nonatomic,copy)NSString *specialOffer;
@property(nonatomic,copy)NSString *thumbnailsUrll;
@property(nonatomic,copy)NSString *specialOfferContext;
@property(nonatomic,copy)NSString *unit;
@property(nonatomic,copy)NSString *storage;
@property(nonatomic,copy)NSString *vistiCounts;
@property(nonatomic,copy)NSString *weight;
@property(nonatomic,copy)NSString *IsFolder;
@property(nonatomic,copy)NSString *UserPrice;

@property (nonatomic, copy) NSString *productUrl;
@property (nonatomic, assign)BOOL     upselling;        // 下架
@property (nonatomic, copy) NSString *stock;            // 库存
@property (nonatomic, copy) NSString *PurchaseNum;      // 限购数量
@property (nonatomic, copy) NSString *PurchasedNum;     // 已购数量
@property (nonatomic, copy) NSString *PurchaseETime;    // 限购剩余时间
@property (nonatomic, copy) NSString *PurchaseSTime;    // 限购开始时间

@end
