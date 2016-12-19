//
//  CouponsDetailView.h
//  VegetablesApp
//
//  Created by M on 16/6/1.
//  Copyright © 2016年 M. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponsDetailCell.h"

@interface CouponsDetailView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *myCouponArray;

@property (nonatomic, strong) CouponModel *couponsModel;

@end
