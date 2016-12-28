//
//  FSNewCommodityViewController.h
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/28.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSBaseViewController.h"

@interface FSNewCommodityViewController : FSBaseViewController

@property (nonatomic, copy) NSString *specialOffer;    // 是否促销
@property (nonatomic, copy) NSString *latest;          // 是否新品
@property (nonatomic, assign) BOOL isNewGoods;
@end
