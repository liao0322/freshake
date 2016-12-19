//
//  GoodsModel.h
//  VegetablesApp
//
//  Created by M on 16/5/27.
//  Copyright © 2016年 M. All rights reserved.
//

#import "ParentModel.h"

@interface GoodsModel : ParentModel

/// 购物车数量
@property (nonatomic, copy) NSString *CartNum;
/// 类型Id
@property (nonatomic, copy) NSString *categoryId;
/// 主键Id
@property (nonatomic, copy) NSString *id;
/// 图片路径
@property (nonatomic, copy) NSString *imgUrl;
/// 原价
@property (nonatomic, copy) NSString *marketPrice;
/// 商品ID
@property (nonatomic, copy) NSString *productId;
/// 商品名称
@property (nonatomic, copy) NSString *productName;
/// 商品数量
@property (nonatomic, copy) NSString *productNum;
/// 价格
@property (nonatomic, copy) NSString *salePrice;
/// 商品描述
@property (nonatomic, copy) NSString *shortDesc;
/// 库存
@property (nonatomic, copy) NSString *stock;
/// 已售
@property (nonatomic, copy) NSString *SoldStock;
/// 会员价格
@property (nonatomic, copy) NSString *UserPrice;
/// 是否热卖
@property (nonatomic, copy) NSString *hotsale;
/// 图片
@property (nonatomic, copy) NSString *thumbnailsUrll;
/// 类型名
@property (nonatomic, copy) NSString *categoryName;
/// 商品介绍
@property (nonatomic, copy) NSString *specialOfferContext;
/// 是否选中
@property (nonatomic, assign) BOOL isSelect;
/// 图片
@property (nonatomic, strong) UIImage *img;
/// 默认图片
@property (nonatomic, strong) UIImage *defaultImg;

@end
