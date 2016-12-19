//
//  HomePageViewController.h
//  BuyVegetablesTreasure
//
//  Created by sc on 16/3/16.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopularityView.h"
#import "adx_HeadView.h"
#import "adTop_HeadView.h"
#import "PopularityView.h"
#import "PopularityFooterView.h"

@interface HomePageViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>

@property (nonatomic, copy) NSMutableArray *adxListArray;   // 宣传广告
@property (nonatomic, copy) NSMutableArray *adRlistArray;   // 热门广告
@property (nonatomic, copy) NSMutableArray *adSListArray;   // 商品广告
@property (nonatomic, copy) NSMutableArray *adSTListArray;  // 商品Top广告
@property (nonatomic, copy) NSMutableArray *goodsArray;     // 商品
@property (nonatomic, copy) NSMutableArray *imageArray;     // 宣传图片

@property (nonatomic, copy) PopularityView *popularityView;
@property (nonatomic, copy) adx_HeadView *adx_HeadView;         // 宣传广告表头
@property (nonatomic, copy) adTop_HeadView *adTop_HeadView;     // 商品Top表头
@property (nonatomic, copy) PopularityFooterView *footerView;   // 表尾

@end
