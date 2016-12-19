//
//  MyCouponView.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/12/6.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "CouponsDetailViewController.h"

#import "MyCouponView.h"
#import "MyCouponsCell.h"

@implementation MyCouponView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self.tableView setBackgroundColor:[UIColor colorWithHexString:@"0xd7d7d7"]];
        [self.tableView registerClass:[MyCouponsCell class] forCellReuseIdentifier:@"MyCouponsCell"];
    }
    
    return self;
}

- (void)setDataSource:(NSArray *)dataSource {
    
    _dataSource = dataSource;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyCouponsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCouponsCell"];
    [cell setBackgroundColor:[UIColor colorWithHexString:@"0xd7d7d7"]];
    [cell setModel:self.dataSource[indexPath.section]];
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    return cell;
}

#pragma mark - UITableViewDelegate
// Cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView cellHeightForIndexPath:indexPath
                                       model:self.dataSource[indexPath.section]
                                     keyPath:@"model"
                                   cellClass:[MyCouponsCell class]
                            contentViewWidth:ScreenWidth];
}

// 点击Cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isSelectCoupon) {
        
        CouponModel *model = self.dataSource[indexPath.section];
        if (![model.hasLingQu boolValue] &&
            [model.IsExpileDate boolValue])
        {
            for (int i = 0; i < self.dataSource.count; i++) {
                
                if (indexPath.section != i) {
                    CouponModel *couponModel = self.dataSource[i];
                    couponModel.isSelect = NO;
                }
            }
            
            model.isSelect = !model.isSelect;
            
            if ([model.typeId integerValue] == 1) {
                self.selectGoodsCoupon(model.Price, model.Id, model.isSelect, indexPath.section);
            }
            else if (model.isSelect) {
                self.selectCoupon(model.Price, model.Id, model.isSelect);
            }
            else {
                self.selectCoupon(@"0", @"", NO);
            }
        }
    }
    else {
        
        CouponsDetailViewController *couponsDetailVC = [[CouponsDetailViewController alloc] init];
        couponsDetailVC.couponsModel = self.dataSource[indexPath.section];
        self.goViewController(couponsDetailVC);
    }
}

// 段头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

// 段尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

@end
