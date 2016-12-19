//
//  GoodsDetailsModel.h
//  VegetablesApp
//
//  Created by M on 16/5/31.
//  Copyright © 2016年 M. All rights reserved.
//

#import "ParentModel.h"

@interface GoodsDetailsModel : ParentModel

/// 图片数组
@property (nonatomic, copy) NSArray *albums;
@property (nonatomic, copy) NSArray *attr;
/// 重量
@property (nonatomic, copy) NSString *weight;
/// 商品ID
@property (nonatomic, copy) NSString *id;
/// 价格
@property (nonatomic, copy) NSString *salePrice;
/// 说明
@property (nonatomic, copy) NSString *shortDesc;
/// 商品名称
@property (nonatomic, copy) NSString *productName;
/// 类型
@property (nonatomic, copy) NSString *storage;
/// 库存
@property (nonatomic, copy) NSString *stock;
/// 规格
@property (nonatomic, copy) NSString *unit;
/// 是否收藏
@property (nonatomic, copy) NSString *IsFolder;
/// 图文详情Url
@property (nonatomic, copy) NSString *descriptionUrl;
/// 购物车数量
@property (nonatomic, copy) NSString *CartNum;
/// 类型ID
@property (nonatomic, copy) NSString *categoryId;
/// 分享链接
@property (nonatomic, copy) NSString *productUrl;
/// 会员价
@property (nonatomic, copy) NSString *UserPrice;
/// 特价信息
@property (nonatomic, copy) NSString *specialOfferContext;

@end
