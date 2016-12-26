//
//  FSCollectView.h
//  BuyVegetablesTreasure
//
//  Created by 江玉元 on 2016/12/23.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSCollectView : UIView<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataSource;

@property (nonatomic, copy) void(^deleteCollect)(NSString *idString);
@property (nonatomic, copy) void(^didSelectBlock)();

@property (nonatomic, assign) BOOL isGoods;
@property (nonatomic, assign) BOOL isEdit;

- (void)refreshTableView;


@end
