//
//  GroupTableView.m
//  BuyVegetablesTreasure
//
//  Created by sc on 16/4/5.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "GroupTableView.h"

@implementation GroupTableView

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
    [_groupTableView registerClass:[GropCell class] forCellReuseIdentifier:@"GropCell"];
    [self addSubview:_groupTableView];
}

#pragma mark 事件处理
- (void)refreshGoods {
    [_groupTableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

#pragma mark 设置Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GroupModel *model = _dataArray[indexPath.section];

    GropCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GropCell"];
    cell.selectionStyle = NO;
    [cell setGroupModel:model];

    cell.goGroup = ^{
        _goDetails(model);
    };

    return cell;
}

#pragma mark - UITableViewDelegate
#pragma mark 设置Cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GroupModel *model = _dataArray[indexPath.section];
    return model.titleHight + 95 + ScreenWidth / 2;
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
    
    GroupModel *model = _dataArray[indexPath.section];
    _goDetails(model);
}

@end
