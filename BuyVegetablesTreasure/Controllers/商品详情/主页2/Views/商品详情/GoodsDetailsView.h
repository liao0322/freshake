//
//  GoodsDetailsView.h
//  VegetablesApp
//
//  Created by M on 16/5/31.
//  Copyright © 2016年 M. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsDetailCell.h"

@interface GoodsDetailsView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) Pruduct *detailsModel;

@property (nonatomic, copy) void(^lookBlock)();

@end
