//
//  FSSearchAssociationViewController.h
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/15.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSBaseViewController.h"
#import "FSNavigationController.h"

@interface FSSearchAssociationViewController : FSBaseViewController

@property (copy, nonatomic) NSMutableArray *dataArray;
@property (nonatomic) UITableView *tableView;
@property (nonatomic) FSNavigationController *nav;
@end
