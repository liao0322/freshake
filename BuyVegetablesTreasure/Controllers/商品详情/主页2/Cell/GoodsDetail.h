//
//  GoodsDetail.h
//  BuyVegetablesTreasure
//
//  Created by sc on 16/1/21.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pruduct.h"

@interface GoodsDetail : UITableViewCell

@property (nonatomic, copy) UIView *goodsTypesView;         // 商品类型
@property (nonatomic, copy) UIView *goodsPriceView;         // 商品价格
@property (nonatomic, copy) UIView *promotionView;          // 促销
@property (nonatomic, copy) UIView *otherTypesView;         // 其他类型

@property (nonatomic ,copy) SDCycleScrollView *goodsImageScrollView; // 商品图片

- (void)setModel:(Pruduct *)model;

@end
