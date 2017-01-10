//
//  ShopCart.h
//  BuyVegetablesTreasure
//
//  Created by ky on 15/12/16.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParentModel.h"

@interface ShopCart : ParentModel

@property (nonatomic, copy) NSString *Specifications ; // ,
@property (nonatomic, copy) NSString *address ; // ,
@property (nonatomic, copy) NSString *ID ;
@property (nonatomic, copy) NSString *mid ;// 405,
@property (nonatomic, copy) NSString *openid; // null,
@property (nonatomic, copy) NSString *productId ; // 32,
@property (nonatomic, copy) NSString *productName ; // 红心,
@property (nonatomic, copy) NSNumber *productNum ; // 7,
@property (nonatomic, copy) NSString *salePrice ; // 100,
@property (nonatomic, copy) NSString *telphone ; // 13682516912,
@property (nonatomic, copy) NSString *totPrice ; // 700,
@property (nonatomic, copy) NSString *wid ; // 28
@property (nonatomic, copy) NSString *stock;
@property (nonatomic, copy) NSString *categoryId;
@property (nonatomic, copy) NSString *thumbnailsUrll;
@property (nonatomic, copy) NSString *point;
@property (nonatomic, copy) NSString *TickCount;
@property (nonatomic, copy) NSString *UserPrice;
@property (nonatomic, copy) NSString *StoreId;
@property (nonatomic, copy) NSString *upselling;

@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, assign, getter=isInvalid) BOOL invalid;

@end
