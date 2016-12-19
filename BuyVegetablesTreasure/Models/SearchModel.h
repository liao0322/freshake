//
//  SearchModel.h
//  BuyVegetablesTreasure
//
//  Created by sc on 15/11/13.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import "ParentModel.h"

@interface SearchModel : ParentModel

@property (nonatomic, copy) NSString *BuyNum; // 0,
@property (nonatomic, copy) NSString *FreeNum ; // 0,
@property (nonatomic, copy) NSString *CartNum ;
@property (nonatomic, copy) NSString *categoryId ; // 5,
@property (nonatomic, copy) NSString *id ; // 14,
@property (nonatomic, copy) NSString *imgUrl ; // http; ////192.168.1.116/images/5.jpg,
@property (nonatomic, copy) NSString *marketPrice ; // 100,
@property (nonatomic, copy) NSString *productName ; // 大大女裤,
@property (nonatomic, copy) NSString *salePrice ; // 90,
@property (nonatomic, copy) NSString *shortDesc ; // ,
@property (nonatomic, copy) NSString *sku ; // 58357224,
@property (nonatomic, copy) NSString *stock ; // 1000
@property (nonatomic, copy) NSString *PurchaseNum;
@property (nonatomic, copy) NSString *SoldStock;
@property (nonatomic, copy) NSString *UserPrice;

@end
