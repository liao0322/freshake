//
//  FSMyCouponView.m
//  BuyVegetablesTreasure
//
//  Created by 江玉元 on 2016/12/21.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSMyCouponView.h"
//#import "FSMyCouponsCell.h"
#import "CouponModel.h"
#import "FSMyCouponsViewCell.h"
#import "FSCouponsDetailViewController.h"

@implementation FSMyCouponView

static NSString * const myCouponsViewCellID = @"myCouponsViewCellID";


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self.tableView setBackgroundColor:[UIColor colorWithHexString:@"0xf2f2f2"]];
        [self.tableView registerClass:[FSMyCouponsViewCell class] forCellReuseIdentifier:myCouponsViewCellID];
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
    FSMyCouponsViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([FSMyCouponsViewCell class]) owner:nil options:nil] lastObject];
    CouponModel *coupon = self.dataSource[indexPath.section];
    [cell setBackgroundColor:[UIColor colorWithHexString:@"0xf2f2f2"]];
    cell.model = coupon;
//    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate
// Cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCREEN_WIDTH == 320 ? 98 : 115;
}

// 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isSelectCoupon) {
        FSCouponModel *model = self.dataSource[indexPath.section];
        if (![model.hasLingQu boolValue] && [model.IsExpile boolValue]) {
            for (int i = 0; i < self.dataSource.count; i++) {
                if (indexPath.section != i) {
                    FSCouponModel *couponModel = self.dataSource[i];
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
        FSCouponsDetailViewController *couponDetailVC = [[FSCouponsDetailViewController alloc] init];
        couponDetailVC.couponModel = self.dataSource[indexPath.section];
        self.goViewController(couponDetailVC);
    }
}

// 段头高度

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

// 段尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}





@end
