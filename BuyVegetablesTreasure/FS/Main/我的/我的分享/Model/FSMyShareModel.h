//
//  FSMyShareModel.h
//  BuyVegetablesTreasure
//
//  Created by 江玉元 on 2017/4/13.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import "FSBaseModel.h"

@interface FSMyShareModel : FSBaseModel

/// 添加时间
@property (copy, nonatomic) NSString *addtime;

/// id
@property (copy, nonatomic) NSString *id;

/// 商品图片链接
@property (copy, nonatomic) NSString *productImg_url;

/// 商品id
@property (copy, nonatomic) NSString *product_id;

/// 商品名称
@property (copy, nonatomic) NSString *product_name;

@end
