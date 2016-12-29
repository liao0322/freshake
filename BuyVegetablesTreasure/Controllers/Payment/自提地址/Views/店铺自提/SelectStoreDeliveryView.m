//
//  SelectStoreDeliveryView.m
//  BuyVegetablesTreasure
//
//  Created by sc on 16/3/30.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "SelectStoreDeliveryView.h"
#import "PointDeliveryCell.h"

@interface SelectStoreDeliveryView ()

@property (nonatomic, copy) UITableView *storeDeliveryTableView;

@end

@implementation SelectStoreDeliveryView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initStoreDeliveryTableView];
    }
    return self;
}

#pragma mark - 初始化
#pragma mark 显示商家提货点
- (void)initStoreDeliveryTableView {
    
    _storeDeliveryTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
//    _storeDeliveryTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    _storeDeliveryTableView.delegate = self;
    _storeDeliveryTableView.dataSource = self;
    _storeDeliveryTableView.separatorStyle = NO;
    [self.storeDeliveryTableView registerClass:[PointDeliveryCell class] forCellReuseIdentifier:@"PointDeliveryCell"];
    [self addSubview:_storeDeliveryTableView];
}

#pragma mark 事件处理
- (void)refreshSite {
    [_storeDeliveryTableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _siteArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

#pragma mark 设置单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PointDeliveryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PointDeliveryCell"];
    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
        
    Map *address = _siteArray[indexPath.section];
    [cell setModel:address];
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    
    return cell;
}

#pragma mark 点击Cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_siteArray.count > 0) {
        
        [Single sharedInstance].isDelivery = NO;
        Map *address = _siteArray[indexPath.section];
        _midSite(address);
    }
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id model = _siteArray[indexPath.section];
    return [self.storeDeliveryTableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[PointDeliveryCell class] contentViewWidth:ScreenWidth];
}

@end
