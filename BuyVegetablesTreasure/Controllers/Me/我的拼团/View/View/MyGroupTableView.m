//
//  MyGroupTableView.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/4/7.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "MyGroupTableView.h"
#import "GroupPeopleViewController.h"
#import "MyOrderViewController.h"
#import "MyOrderDetailsViewController.h"

@implementation MyGroupTableView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initGroupTableView];
    }
    return self;
}

#pragma mark - 初始化
- (void)initGroupTableView {
    
    _groupTableView = [[UITableView alloc] initWithFrame:self.frame style:UITableViewStyleGrouped];
    _groupTableView.delegate = self;
    _groupTableView.dataSource = self;
    _groupTableView.separatorStyle = NO;
    [_groupTableView registerClass:[GroupGoodsCell class] forCellReuseIdentifier:@"GroupGoodsCell"];
    [self addSubview:_groupTableView];
}

#pragma mark - 事件处理
#pragma mark 刷新
- (void)refreshGoods {
    [_groupTableView reloadData];
}

#pragma mark 前往详情
- (void)goDetails:(UIButton *)btg {

    if (btg.tag % 2 == 1) {
        
        MyGroupModel *model = _dataArray[btg.tag / 10 - 1];
        
        MyOrderDetailsViewController *payOrderVC = [[MyOrderDetailsViewController alloc] init];
        payOrderVC.idString = model.AddUserId;
        payOrderVC.orderString = model.Order_No;
        payOrderVC.midString = model.Sid;
        payOrderVC.isGroup = YES;
        _goViewController(payOrderVC);
    }
    else {
        
        GroupPeopleViewController *groupPeopleVC = [[GroupPeopleViewController alloc] init];
        groupPeopleVC.model = _dataArray[btg.tag / 10 - 1];
        _goViewController(groupPeopleVC);
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

#pragma mark 设置Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyGroupModel *model = _dataArray[indexPath.section];
    
    if (indexPath.row == 0) {
        
        GroupGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupGoodsCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setGroupModel:model];
        return cell;
    }
    else {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont systemFontOfSize:14.0];
//            cell.textLabel.textColor = [UIColor colorWithHexString:@"0xff6600"];
            cell.textLabel.textColor = [UIColor colorDomina];
        
            if ([model.status integerValue]) {
                
                if ([model.status integerValue] == 1 || [model.status integerValue] == 2) {
                    cell.textLabel.text = @"拼团进行中";
                }
                else if ([model.status integerValue] == 3) {
                    cell.textLabel.text = @"拼团成功";
                }
                else cell.textLabel.text = @"拼团失败";
            }
            
        
        if ([model.IsPay boolValue] && [model.status integerValue] == 3) {
            
            for (int i = 0; i < 2; i++) {
                
                [(UIButton *)[self viewWithTag:(indexPath.section + 1) * 10 + i] removeFromSuperview];
                
                // 团详情
                UIButton *detailsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                detailsBtn.tag = (indexPath.section + 1) * 10 + i;
                detailsBtn.frame = CGRectMake(ScreenWidth - 210 + 100 * i, 10, i == 0 ? 90 : 100, 30);
                detailsBtn.titleLabel.font = [UIFont systemFontOfSize:13];
                detailsBtn.layer.cornerRadius = 5;
                detailsBtn.layer.borderWidth = 1;
                detailsBtn.layer.borderColor = [UIColor colorDomina].CGColor;
                [detailsBtn setTitle:i == 0 ? @"查看团详情" : @"查看订单详情" forState:UIControlStateNormal];
                [detailsBtn setTitleColor:[UIColor colorDomina] forState:UIControlStateNormal];
                [detailsBtn addTarget:self action:@selector(goDetails:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:detailsBtn];
            }
        }
        else {
            
            [(UIButton *)[self viewWithTag:(indexPath.section + 1) * 10] removeFromSuperview];
            
            UIButton *detailsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            detailsBtn.tag = (indexPath.section + 1) * 10;
            detailsBtn.frame = CGRectMake(ScreenWidth - 100, 10, 90, 30);
            detailsBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            detailsBtn.layer.cornerRadius = 5;
            detailsBtn.layer.borderWidth = 1;
            detailsBtn.layer.borderColor = [UIColor colorDomina].CGColor;
            [detailsBtn setTitle:@"查看团详情" forState:UIControlStateNormal];
            [detailsBtn setTitleColor:[UIColor colorDomina] forState:UIControlStateNormal];
            [detailsBtn addTarget:self action:@selector(goDetails:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:detailsBtn];
        }
        
        [(UILabel *)[self viewWithTag:indexPath.section + 100000] removeFromSuperview];
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 49, ScreenWidth, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"0xE2E2E2"];
        line.tag = indexPath.section + 100000;
        [cell addSubview:line];
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate
#pragma mark 返回Cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return 100;
    }
    else return 50;
}

#pragma mark 设置断头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 0.1;
    }
    return 10;
}

#pragma mark 设置断尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

#pragma 点击Cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

@end
