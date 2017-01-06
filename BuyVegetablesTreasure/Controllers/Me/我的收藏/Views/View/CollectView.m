//
//  CollectView.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/5/3.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "CollectView.h"
#import "CollectTableViewCell.h"
#import "GoodsDetailViewController.h"
#import "CookingDetailsViewController.h"
#import "ShopCart.h"
#import "SubmitOrderViewController.h"

@implementation CollectView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {

        [self initTableView];
    }
    return self;
}

#pragma mark - 初始化
- (void)initTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = NO;
    _tableView.allowsMultipleSelectionDuringEditing = YES;
    [_tableView registerClass:[CollectTableViewCell class] forCellReuseIdentifier:@"Cell"];

    [self addSubview:_tableView];
}

#pragma mark - 事件处理
#pragma mark 刷新
- (void)refreshTableView {
    [_tableView reloadData];
}

#pragma mark 前往支付
- (void)goPay:(NSInteger)index {
    
    MyCollectModel *model = _dataSource[index];
    
    if ([model.upselling integerValue] == 0) {
        return [self alterView];
    }
    
    NSString *groupId = [[NSUserDefaults standardUserDefaults] objectForKey:@"group_id"];
    NSString *priceString;
    
    if ([groupId intValue] > 1) {
        priceString = model.UserPrice;
    }
    else {
        priceString = model.price;
    }
    
    ShopCart *shopCartModel = [ShopCart new];
    shopCartModel.productName = model.productName;
    shopCartModel.salePrice = priceString;
    shopCartModel.productId = model.id;
    shopCartModel.ID = model.id;
    shopCartModel.productNum = [NSNumber numberWithInt:1];
    
    SubmitOrderViewController *submitOrderVC = [SubmitOrderViewController new];
    submitOrderVC.goodsArray = @[shopCartModel];
    submitOrderVC.buySoon = YES;
    submitOrderVC.isCollect = YES;
    submitOrderVC.fendianId = model.StroreId;
    submitOrderVC.midString = model.mid;
    submitOrderVC.fendianAddress = model.addr;
    _goViewController(submitOrderVC);
}

- (void)alterView {
    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您收藏的商品已经下架!" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
    [alterView show];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

#pragma mark 设置Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CollectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    MyCollectModel *model = _dataSource[indexPath.section];
    [cell setModel:model];

    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, cell.frame.size.height - 1)];
    bgView.backgroundColor = [UIColor whiteColor];
    cell.selectedBackgroundView = bgView;
    
    WS(weakSelf);
    cell.goPayViewController = ^{
        
        [weakSelf goPay:indexPath.section];
    };
    
    return cell;
}

#pragma mark 删除样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

#pragma mark 样式点击事件
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        MyCollectModel *model = _dataSource[indexPath.section];
        _deleteCollect(model.id);

    }
}

#pragma mark - UITableViewDelegate
#pragma mark 设置Cell高度
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

#pragma 点击Cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    if (_isEdit) {
        
        if (_didselectBlock) {
            _didselectBlock();
        }
        
        return;
    }

    MyCollectModel *model = _dataSource[indexPath.section];
    
    if ([model.upselling integerValue] == 0) {
        return [self alterView];
    }
    
    GoodsDetailViewController *detailVC = [[GoodsDetailViewController alloc] init];
    detailVC.isCollect = @"1";
    detailVC.midStr = model.mid;
    detailVC.Gaddress = model.addr;
    detailVC.pickTime = model.picktime;
    detailVC.goodsStoreID = model.StroreId;
    detailVC.fendianName = model.fendianname;
    detailVC.ProductId = [model.id integerValue];
    _goViewController(detailVC);

}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isEdit) {
        
        if (_didselectBlock) {
            _didselectBlock();
        }
        
        return;
    }
}

@end
