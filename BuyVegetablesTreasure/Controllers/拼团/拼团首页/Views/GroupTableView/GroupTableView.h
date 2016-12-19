//
//  GroupTableView.h
//  BuyVegetablesTreasure
//
//  Created by sc on 16/4/5.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GropCell.h"

@interface GroupTableView : UIView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, copy) UITableView *groupTableView;
@property (nonatomic, copy) NSArray *dataArray;
@property (nonatomic, copy) void(^goDetails)(GroupModel *model);

- (void)refreshGoods;

@end
