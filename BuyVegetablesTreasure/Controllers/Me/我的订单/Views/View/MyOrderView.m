//
//  MyOrderView.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/5/11.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "MyOrderView.h"
#import "MyOrderDetailsViewController.h"
#import "PublishOrderAndGoodsViewController.h"

@implementation MyOrderView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initOrderTableView];
    }
    return self;
}

- (void)initOrderTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithHexString:@"0xf8f8f8"];
    [self addSubview:_tableView];
    
    [_tableView registerClass:[MyOrderGoodsCell class] forCellReuseIdentifier:@"GoodsCell"];
    [_tableView registerClass:[MyOrderInfoCell class] forCellReuseIdentifier:@"OrderInfoCell"];
}

#pragma mark 刷新
- (void)refreshTableView {
    [_tableView reloadData];
}

#pragma mark 前往控制器
- (void)goViewController:(NSInteger)index model:(Order *)model {

    if (index == 12) {
        
        MyOrderDetailsViewController *orderDeailVC = [MyOrderDetailsViewController new];
        orderDeailVC.idString = [NSString stringWithFormat:@"%zd",[model.Id integerValue]];
        orderDeailVC.orderString = model.order_no;
        orderDeailVC.isGroup = NO;
        _goViewController(orderDeailVC);
    }
    else if (index == 11) {
        _goPay(model);
    }
    else {
        
        PublishOrderAndGoodsViewController *publish = [[PublishOrderAndGoodsViewController alloc] init];
        publish.orderModel = model;
        publish.indexRow = -1;
        _goViewController(publish);
    }
}

#pragma mark 关闭订单
- (void)shutOrder:(UIButton *)btn {
    
    Order *model = _dataSource[btn.tag - 30];
    _orderId = [model.Id stringValue];
    _cancelOrder();
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    Order *model = _dataSource[section];
    return 2 + model.List.count;
}

#pragma mark 设置Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Order *model = _dataSource[indexPath.section];
    
    if (indexPath.row == 0) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            
            for (int i = 0; i < 2; i++) {
                
                UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, i * (CGRectGetHeight(cell.frame) - 0.5), ScreenWidth, 0.5)];
                line.backgroundColor = [UIColor colorWithHexString:@"0xE4E4E4"];
                [cell addSubview:line];
            }
        }
        
        // 订单状态
        UIButton *orderStatus = [UIButton buttonWithType:UIButtonTypeCustom];
        orderStatus.frame = CGRectMake(0, 0, 55, CGRectGetHeight(cell.frame));
        orderStatus.tag = indexPath.section + 30;
        cell.accessoryView = orderStatus;
        
        UILabel *orderStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 55, CGRectGetHeight(cell.frame))];
        orderStatusLabel.font = [UIFont systemFontOfSize:13];
        orderStatusLabel.textColor = Color;
        orderStatusLabel.textAlignment = NSTextAlignmentRight;
        [orderStatus addSubview:orderStatusLabel];
        
        if ([model.status integerValue] == 1) {

            orderStatusLabel.text = @"取消订单";
            [orderStatus addTarget:self action:@selector(shutOrder:) forControlEvents:UIControlEventTouchUpInside];
            
//            if ([model.payment_status integerValue] == 1) {
//                
//                
//            }
//            else {
//                orderStatusLabel.text = @"已支付";
//            }
        }
        else if ([model.status integerValue] == 2) {
            orderStatusLabel.text = @"待提货";
        }
        else if ([model.status integerValue] == 3) {
            orderStatusLabel.text = @"已提货";
        }
        else {
            orderStatusLabel.text = @"已取消";
        }
        
        cell.selectionStyle = UITableViewCellStyleDefault;
        cell.imageView.image = [UIImage imageNamed:@"订单号"];
        cell.textLabel.text = [NSString stringWithFormat:@"订单号:%@",model.order_no];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"0x606060"];
        
        return cell;
    }
    else if (indexPath.row == model.List.count + 1) {
        
        MyOrderInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderInfoCell"];
        cell.selectionStyle = UITableViewCellStyleDefault;
        [cell setModel:model];
        
        cell.btnClickBlock = ^(NSInteger index) {
            [self goViewController:index model:model];
        };
        
        return cell;
    }

    MyOrderGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsCell"];
    cell.selectionStyle = UITableViewCellStyleDefault;
    [cell setModel:model.List[indexPath.row - 1]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Order *model = _dataSource[indexPath.section];
    
    if (indexPath.row == 0) {
        return 50;
    }
    else if (indexPath.row == model.List.count + 1) {
        return 90;
    }
    
    else return 100;
}

#pragma mark 返回段头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 0.01;
}

#pragma mark 返回段尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Order *model = _dataSource[indexPath.section];

    if (indexPath.row - 1 < model.List.count) {
        
        if ([model.status integerValue] == 3) {
            
            model.List = [NSMutableArray arrayWithArray:@[model.List[indexPath.row - 1]]];
            [self goViewController:10 model:model];
        }
    }
}

@end
