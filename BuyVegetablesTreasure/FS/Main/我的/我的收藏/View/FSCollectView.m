//
//  FSCollectView.m
//  BuyVegetablesTreasure
//
//  Created by 江玉元 on 2016/12/23.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSCollectView.h"
#import "FSMyCollectTableViewCell.h"



@implementation FSCollectView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initTableView];
    }
    return self;
}

- (void)initTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = NO;
    _tableView.allowsMultipleSelectionDuringEditing = YES;
    [_tableView registerClass:[FSMyCollectTableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self addSubview:_tableView];

}

#pragma mark - 事件处理
#pragma mark  刷新

- (void)refreshTableView {
    [_tableView reloadData];
}

- (void)alterView {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您收藏的商品已经下架！" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FSMyCollectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (_isGoods) {
        FSMyCollectModel *model = _dataSource[indexPath.section];
        [cell setModel:model];
    }
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, cell.frame.size.height - 1)];
    bgView.backgroundColor = [UIColor whiteColor];
    cell.selectedBackgroundView = bgView;
    
    
    return cell;
}

#pragma mark - 删除样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

#pragma mark 样式点击事件
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        FSMyCollectModel *model = _dataSource[indexPath.section];
        _deleteCollect(model.id);
    }
}

#pragma mark - UITableViewDelegate
#pragma mark 设置cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:ScreenWidth tableView:tableView];
}

#pragma mark 设置断头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark 设置断尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

#pragma 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isEdit) {
        if (_didSelectBlock) {
            _didSelectBlock();
        }
        return;
    }
    
    FSMyCollectModel *model = _dataSource[indexPath.row];
    
    if ([model.upselling integerValue] == 0) {
        return [self alterView];
    }
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isEdit) {
        
        if (_didSelectBlock) {
            _didSelectBlock();
        }
        return;
    }
}

@end
