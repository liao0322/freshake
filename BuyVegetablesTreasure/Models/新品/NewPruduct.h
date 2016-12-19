//
//  NewPruduct.h
//  BuyVegetablesTreasure
//
//  Created by Song on 16/1/13.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewPruduct : NSObject

@property (nonatomic, copy) NSMutableArray *attr; // 0,
@property (nonatomic, copy) NSNumber *BuyNum; // 0,
@property (nonatomic, copy) NSString *CartNum ;
@property (nonatomic, copy) NSNumber *categoryId ; // 5,
@property (nonatomic, copy) NSString *categoryName ;
@property (nonatomic, copy) NSNumber *FreeNum ;
@property (nonatomic, copy) NSNumber *Id ; // 14,
@property (nonatomic, copy) NSString *imgUrl ; // http; ////192.168.1.116/images/5.jpg,
@property (nonatomic, copy) NSNumber *IsSpecialOffer; // 0,
@property (nonatomic, copy) NSNumber *marketPrice ; // 100,
@property (nonatomic, copy) NSString *productName ; // 大大女裤,
@property (nonatomic, copy) NSNumber *salePrice ; // 90,
@property (nonatomic, copy) NSString *shortDesc ; // ,
@property (nonatomic, copy) NSString *sku ; // 58357224,
@property (nonatomic, copy) NSString *specialOfferContext;
@property (nonatomic, copy) NSString *Specifications;
@property (nonatomic, copy) NSNumber *stock ; // 1000


@end
