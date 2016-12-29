//
//  MyOrderView.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/5/11.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOrderGoodsCell.h"
#import "MyOrderInfoCell.h"



@interface MyOrderView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSString *orderId;

@property (nonatomic, copy) NSString *stateUrl;


@property (nonatomic, copy) void(^requestOrder)(NSString *urlString);

@property (nonatomic, copy) void(^goViewController)(UIViewController *viewController);
@property (nonatomic, copy) void(^goPay)(Order *model);
@property (nonatomic, copy) void(^cancelOrder)();
@property (nonatomic, copy) NSString *indexStr;

- (void)refreshTableView;

@end
