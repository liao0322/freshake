//
//  MyOrderGoodsInfoModel.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/5/11.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "ParentModel.h"

@interface MyOrderGoodsInfoModel : ParentModel

// 商品类型
@property (nonatomic, copy) NSString *CatalogName ;
// 商品ID
@property (nonatomic, copy) NSString *goods_id ;
// 商品价格
@property (nonatomic, copy) NSString *goods_price ;
// 商品名称
@property (nonatomic, copy) NSString *goods_title ;
// 商品图片
@property (nonatomic, copy) NSString *thumbnailsUrll ;
// 单位
@property (nonatomic, copy) NSString *unit ;
@property (nonatomic, copy) NSString *point ; // 12,
@property (nonatomic, copy) NSString *quantity ; // 1,
@property (nonatomic, copy) NSString *real_price ; // 0,
@property (nonatomic, copy) NSString *upselling ; // 1,
@property (nonatomic, copy) NSString *weight ; // 1
@property (nonatomic, copy) NSString *evaluation ; // false,

@end
