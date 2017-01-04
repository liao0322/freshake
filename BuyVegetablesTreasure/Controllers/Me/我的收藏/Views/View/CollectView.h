//
//  CollectView.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/5/3.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, copy) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataSource;

@property (nonatomic, copy) void(^deleteCollect)(NSString *idString);
@property (nonatomic, copy) void(^goViewController)(UIViewController *viewController);
@property (nonatomic, copy) void(^didselectBlock)();

//@property (nonatomic, assign) BOOL isGoods;
@property (nonatomic, assign) BOOL isEdit;

- (void)refreshTableView;

@end
