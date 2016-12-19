//
//  HomePageView.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/12/8.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "KTableView.h"

@interface HomePageView : KTableView

/// 商品数组
@property (nonatomic, strong) NSArray *goodsArray;
/// 横批数组
@property (nonatomic, strong) NSArray *bannerArray;
/// 广告数组
@property (nonatomic, strong) NSArray *advertisingArray;
/// 商品广告数组
@property (nonatomic, strong) NSArray *goodsAdvertisingArray;
/// Top广告
@property (nonatomic, strong) NSArray *topArray;
/// 查看所有商品
@property (nonatomic, strong) void(^lookAllGoods)();
/// 前往控制器
@property (nonatomic, strong) void(^goViewController)(UIViewController *viewController);

@end
