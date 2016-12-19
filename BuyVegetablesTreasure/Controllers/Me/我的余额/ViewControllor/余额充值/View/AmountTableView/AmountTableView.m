//
//  AmountTableView.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/11/28.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "AmountTableView.h"
#import "AmountCell.h"

@implementation AmountTableView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self initTableHeadView];
        self.tableView.backgroundColor = [UIColor colorWithHexString:@"0xf8f8f8"];
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        [self.tableView registerClass:[AmountCell class] forCellReuseIdentifier:@"AmountCell"];
        [self.tableView reloadData];
    }
    
    return self;
}

- (void)initTableHeadView {
    
    UIView *headBgView = [UIView new];
    headBgView.frame = CGRectMake(0, 0, ScreenWidth, 50);
    headBgView.backgroundColor = [UIColor colorWithHexString:@"0xf8f8f8"];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.frame = CGRectMake(10, 0, ScreenWidth, 50);
    titleLabel.text = @"充值活动";
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
    [headBgView addSubview:titleLabel];
    
    self.tableView.tableHeaderView = headBgView;
}

- (void)setDataSource:(NSArray *)dataSource {
    
    _dataSource = dataSource;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AmountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AmountCell"];
    cell.backgroundColor = [UIColor colorWithHexString:@"0xf8f8f8"];
    [cell setModel:self.dataSource[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate
// Cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return (ScreenWidth - 20) / 2 + 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AmountModel *model = self.dataSource[indexPath.row];
    self.amountBlock(model.total_fee, model.id);
}

@end
