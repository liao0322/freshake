//
//  MyGroupTableView.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/4/7.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupGoodsCell.h"

@interface MyGroupTableView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, copy) UITableView *groupTableView;
@property (nonatomic, copy) NSArray *dataArray;
@property (nonatomic, copy) void(^goViewController)(UIViewController *viewController);

- (void)refreshGoods;

@end
