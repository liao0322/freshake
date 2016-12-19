//
//  ShoppingCartModel.h
//  BuyVegetablesTreasure
//
//  Created by sc on 15/11/4.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import "ParentModel.h"

@interface ShoppingCartModel : ParentModel

@property (nonatomic, copy) NSString *Specifications ; // ,
@property (nonatomic, copy) NSString *address ; // ,
@property (nonatomic, copy) NSString *id ;
@property (nonatomic, copy) NSString *mid ;// 405,
@property (nonatomic, copy) NSString *openid; // null,
@property (nonatomic, copy) NSString *productId ; // 32,
@property (nonatomic, copy) NSString *productName ; // 红心,
@property (nonatomic, copy) NSString *productNum ; // 7,
@property (nonatomic, copy) NSString *salePrice ; // 100,
@property (nonatomic, copy) NSString *telphone ; // 13682516912,
@property (nonatomic, copy) NSString *totPrice ; // 700,
@property (nonatomic, copy) NSString *wid ; // 28
@property (nonatomic, copy) NSString *stock;

@end
