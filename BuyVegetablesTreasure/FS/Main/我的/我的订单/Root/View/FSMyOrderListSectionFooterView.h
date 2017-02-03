//
//  FSMyOrderListSectionFooterView.h
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2017/1/24.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Order;

typedef void(^CancelOrderBlock)();

@interface FSMyOrderListSectionFooterView : UITableViewHeaderFooterView

@property (nonatomic) Order *model;

/// 查看订单详情
@property (nonatomic) void(^viewOrderDetailsBlock)();

@property (nonatomic) void(^toPayBlock)();
@property (nonatomic) void(^viewExpressBlock)();
@property (nonatomic) void(^buyAgainBlock)();
@property (nonatomic) void(^toCommentBlock)();

@end
