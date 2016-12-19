//
//  SiteViewController.h
//  BuyVegetablesTreasure
//
//  Created by sc on 16/3/30.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Map.h"
#import "SiteModel.h"

@interface SiteViewController : UIViewController

@property (nonatomic, copy) NSString *midStr;
// 是否收藏
@property (nonatomic, assign) BOOL isCollect;
// 是否提货点
@property (nonatomic, assign) BOOL isDelivery;
// 是否用户地址
@property (nonatomic, assign) BOOL isDistribution;

@property (nonatomic, copy) void(^midSite)(Map *mapArray);
@property (nonatomic, copy) void(^userAddress)(SiteModel *mapArray);

@end
