//
//  FSMyOrderListSectionHeaderView.h
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2017/1/24.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CancelOrderBlock)();

@class Order;

@interface FSMyOrderListSectionHeaderView : UITableViewHeaderFooterView

@property (nonatomic) Order *model;

@property (nonatomic) CancelOrderBlock cancelOrderBlock;

@end
