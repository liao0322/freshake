//
//  MeTableView.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/4/7.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeTableView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, copy) UITableView *meTableView;

@property (nonatomic, copy) NSArray *dataScoure;
@property (nonatomic, copy) NSString *moneyString;
@property (nonatomic, copy) NSString *pointString;

@property (nonatomic, copy) void(^goViewController)(UIViewController *viewController);

- (void)refreshTableView;

@end
