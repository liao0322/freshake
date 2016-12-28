//
//  FSShoppingCartViewController.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/16.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSShoppingCartViewController.h"
#import "ShopCart.h"
#import "FSShoppingCartTVCell.h"
#import "FSShoppingCartBottomView.h"
#import "FSShoppingCartTVFooterView.h"
#import "FSEmptyView.h"
#import "SubmitOrderViewController.h"

@interface FSShoppingCartViewController ()
<
    UITableViewDelegate,
    UITableViewDataSource,
    FSShoppingCartTVCellDelegate
>

@property (copy, nonatomic) NSMutableArray *commodityArray;

@property (nonatomic) UITableView *tableView;

@property (nonatomic) UIRefreshControl *refreshControl;

@property (nonatomic) FSShoppingCartBottomView *bottomView;

@property (nonatomic) FSShoppingCartTVFooterView *footerView;

@property (nonatomic) FSEmptyView *emptyView;

@property (assign, nonatomic) CGFloat totalPrice;

@property (copy, nonatomic) NSString *point;
@property (copy, nonatomic) NSString *tick;

@end

@implementation FSShoppingCartViewController

static NSString * const shoppingCartTVCellID = @"shoppingCartTVCellID";

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getCommodityData];
    [self getShoppingCartNum];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.refreshControl endRefreshing];
}

#pragma mark - Override

- (void)getDataFromRemote {
    [super getDataFromRemote];
    // 获取购物车商品数据
    //[self getCommodityData];
    [self requestPoint];
    
}

- (void)initialization {
    [super initialization];
    
    self.title = @"购物车";
    self.totalPrice = 0.0f;
}

- (void)addSubviews {
    [super addSubviews];
    
    [self.view addSubview:self.tableView];

    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.emptyView];

    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
    
    self.emptyView.frame = self.view.bounds;
    
    self.bottomView.width = self.view.width;
    self.bottomView.height = 49;
    self.bottomView.x = 0;
    if (!self.tabBarController) {
        NSLog(@"");
        self.bottomView.bottom = self.view.height;
    } else {
        if ([self.tabBarController.tabBar isHidden]) {
            self.bottomView.bottom = self.view.height;
        } else {
            self.bottomView.bottom = self.view.height - 49;
        }
    }
}

- (void)registerCells {
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FSShoppingCartTVCell class]) bundle:nil] forCellReuseIdentifier:shoppingCartTVCellID];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    if (self.commodityArray.count) {
        rows = self.commodityArray.count;
    }
    //self.emptyView.hidden = rows;
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FSShoppingCartTVCell *cell = [tableView dequeueReusableCellWithIdentifier:shoppingCartTVCellID forIndexPath:indexPath];
    cell.delegate = self;
    cell.model = self.commodityArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == (self.commodityArray.count - 1)) {
        self.tableView.tableFooterView = self.footerView;
        self.tableView.tableFooterView.height = 120;
    }
    
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    
    UITableViewRowAction *removeAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"警告" message:@"确定要删除吗" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            ShopCart *model = self.commodityArray[row];
            
            NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"UID"];
            NSString *mid = [[NSUserDefaults standardUserDefaults] objectForKey:@"MID"] ? [[NSUserDefaults standardUserDefaults] objectForKey:@"MID"] : @"2";
            
            NSString *urlString = [NSString stringWithFormat:DelCartUrl,UUID,mid,model.productId,uid];
            
            [SVProgressHUD show];
            [XFNetworking GET:urlString parameters:nil success:^(id responseObject, NSInteger statusCode) {
                [SVProgressHUD dismiss];
                
                NSInteger cartNum = [model.productNum integerValue];

                // 改变总价
                if (model.isSelect) {
                    CGFloat price = cartNum * [model.salePrice floatValue];
                    
                    self.totalPrice -= price;
                    [self.bottomView.totalPriceLabel setText:[NSString stringWithFormat:@"￥%.2f", self.totalPrice]];
                    [self.bottomView.totalPriceLabel sizeToFit];
                }
                
                // 设置 tabbar badge
                NSInteger badgeValue = [[[[[[self tabBarController] tabBar] items] objectAtIndex:2] badgeValue] integerValue];
                badgeValue -= cartNum;
                
                if (badgeValue == 0) {
                    [[[[[self tabBarController] tabBar] items] objectAtIndex:2] setBadgeValue:nil];
                } else {
                    [[[[[self tabBarController] tabBar] items] objectAtIndex:2] setBadgeValue:[NSString stringWithFormat:@"%ld", badgeValue]];
                }

                // 执行删除操作
                [self.commodityArray removeObjectAtIndex:row];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
                
                if (self.commodityArray.count == 0) { // 没数据了
                    self.emptyView.hidden = NO;
                    self.footerView.hidden = YES;
                    self.bottomView.hidden = YES;
                    [self.tableView reloadData];

                }
                
            } failure:^(NSError *error, NSInteger statusCode) {
                [self showInfoWidthError:error];
            }];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [tableView setEditing:NO animated:YES];
        }];
        
        [alertController addAction:confirmAction];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }];
    
    return @[removeAction];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCREEN_WIDTH / (375 / 130.0f);
}

#pragma mark - FSShoppingCartTVCellDelegate

// 添加操作
- (void)shoppingCartTVCell:(FSShoppingCartTVCell *)cell plusButtonTouchUpInside:(UIButton *)sender {
    NSLog(@"加");
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ShopCart *model = self.commodityArray[indexPath.row];
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"UID"];
    NSString *mid = [[NSUserDefaults standardUserDefaults] objectForKey:@"MID"] ? [[NSUserDefaults standardUserDefaults] objectForKey:@"MID"] : @"2";
    
    __block NSInteger cartNum = [model.productNum integerValue];
    
    NSString *totPriceString = @"0";
    NSString *urlString = @"";
    
    if (cartNum == 0) { // 第一次添加到购物车
        
        urlString = [NSString stringWithFormat:ADDCARTURL, model.productId, UUID, uid, totPriceString, @"1", mid, @"11"];
        
    } else { // 更新购物车数量
        urlString = [NSString stringWithFormat:UpCart, UUID, mid, model.productId,uid,[NSString stringWithFormat:@"%ld", cartNum + 1], @"0"];
    }
    [SVProgressHUD show];
    // 发送请求
    [XFNetworking GET:urlString parameters:nil success:^(id responseObject, NSInteger statusCode) {
        [SVProgressHUD dismiss];
        NSDictionary *dataDict = [self dictWithData:responseObject];
        
        if ([dataDict[@"issuccess"] boolValue]) { // 成功
            
            cartNum++;
            model.productNum = @(cartNum);

            // 更新 UI
            [cell.countLabel setText:[model.productNum stringValue]];
            
            // 设置 tabbar badge
            NSInteger badgeValue = [[[[[[self tabBarController] tabBar] items] objectAtIndex:2] badgeValue] integerValue];
            badgeValue++;
            [[[[[self tabBarController] tabBar] items] objectAtIndex:2] setBadgeValue:[NSString stringWithFormat:@"%ld", badgeValue]];
            
            if (model.isSelect) {
                CGFloat discount = [model.salePrice floatValue];
                self.totalPrice += discount;
                
                [self.bottomView.totalPriceLabel setText:[NSString stringWithFormat:@"￥%.2f", self.totalPrice]];
                [self.bottomView.totalPriceLabel sizeToFit];
            }
        }
        
    } failure:^(NSError *error, NSInteger statusCode) {
        [self showInfoWidthError:error];
    }];

    
}

- (void)shoppingCartTVCell:(FSShoppingCartTVCell *)cell minusButtonTouchUpInside:(UIButton *)sender {
    NSLog(@"减");
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ShopCart *model = self.commodityArray[indexPath.row];
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"UID"];
    NSString *mid = [[NSUserDefaults standardUserDefaults] objectForKey:@"MID"] ? [[NSUserDefaults standardUserDefaults] objectForKey:@"MID"] : @"2";
    
    __block NSInteger cartNum = [model.productNum integerValue];
    
    NSString *urlString = @"";
    
    if (cartNum > 1) { // 更新商品的数量
        urlString = [NSString stringWithFormat:UpCart, UUID, mid, model.productId, uid,[NSString stringWithFormat:@"%ld", cartNum - 1], @"1"];
    } else { // 从购物车删除商品
        
        urlString = [NSString stringWithFormat:DelCartUrl,UUID,mid,model.productId,uid];
        
    }
    
    [SVProgressHUD show];
    [XFNetworking GET:urlString parameters:nil success:^(id responseObject, NSInteger statusCode) {
        
        [SVProgressHUD dismiss];
        NSDictionary *dataDict = [self dictWithData:responseObject];
        
        if ([dataDict[@"issuccess"] boolValue]) { // 成功
            
            cartNum--;
            model.productNum = @(cartNum);
            
            // 更新 UI
            [cell.countLabel setText:[model.productNum stringValue]];
            
            // 设置 tabbar badge
            NSInteger badgeValue = [[[[[[self tabBarController] tabBar] items] objectAtIndex:2] badgeValue] integerValue];
            badgeValue--;
            if (badgeValue == 0) {
                [[[[[self tabBarController] tabBar] items] objectAtIndex:2] setBadgeValue:nil];
            } else {
                [[[[[self tabBarController] tabBar] items] objectAtIndex:2] setBadgeValue:[NSString stringWithFormat:@"%ld", badgeValue]];
            }
            
            if (model.isSelect) {
                CGFloat discount = [model.salePrice floatValue];
                self.totalPrice -= discount;
                
                [self.bottomView.totalPriceLabel setText:[NSString stringWithFormat:@"￥%.2f", self.totalPrice]];
                [self.bottomView.totalPriceLabel sizeToFit];
            }
            if (cartNum == 0) { // 从本地删除购物车
                
                [self.commodityArray removeObjectAtIndex:indexPath.row];
                [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
            }
            
            if (self.commodityArray.count == 0) { // 没数据了
                self.emptyView.hidden = NO;
                self.footerView.hidden = YES;
                self.bottomView.hidden = YES;
                [self.tableView reloadData];
                
            }
            
        }
        
    } failure:^(NSError *error, NSInteger statusCode) {
        [self showInfoWidthError:error];
    }];
    

}

- (void)shoppingCartTVCell:(FSShoppingCartTVCell *)cell selectButtonTouchUpInside:(UIButton *)sender {
    NSLog(@"选");
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ShopCart *model = self.commodityArray[indexPath.row];
    
    if (sender.isSelected) { // 选中

        model.isSelect = YES;
        
        CGFloat price = [model.productNum integerValue] * [model.salePrice floatValue];
        
        self.totalPrice += price;
        [self.bottomView.totalPriceLabel setText:[NSString stringWithFormat:@"￥%.2f", self.totalPrice]];
        [self.bottomView.totalPriceLabel sizeToFit];
        self.bottomView.selectAllButton.selected = [self isAllSelected];
        
    } else { // 不选
        
        model.isSelect = NO;

        CGFloat price = [model.productNum integerValue] * [model.salePrice floatValue];
        
        self.totalPrice -= price;
        
        [self.bottomView.totalPriceLabel setText:[NSString stringWithFormat:@"￥%.2f", self.totalPrice]];
        [self.bottomView.totalPriceLabel sizeToFit];

        self.bottomView.selectAllButton.selected = NO;
        
    }

}

#pragma mark - Custom

- (void)getCommodityData {
    if ([self.refreshControl isRefreshing]) {
        [self.refreshControl endRefreshing];
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uidString = [defaults objectForKey:@"UID"];
    NSString *midString = [defaults objectForKey:@"MID"];
    NSString *urlString = [NSString stringWithFormat:SHOPPINGCARTGOODS,UUID,uidString,midString];
    NSLog(@"===购物车请求===%@",urlString);
    [SVProgressHUD showWithStatus:@"正在加载..."];
    [XFNetworking GET:urlString parameters:nil success:^(id responseObject, NSInteger statusCode) {
        [SVProgressHUD dismiss];
        NSDictionary *dataDict = [self dictWithData:responseObject];
        
        [self.commodityArray removeAllObjects];
        
        if ([dataDict[@"issuccess"] boolValue]) {
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:dataDict[@"point"] forKey:@"point"];
            [userDefaults setObject:dataDict[@"TickCount"] forKey:@"TickCount"];
            
            for (NSDictionary *dic in dataDict[@"list"]) {
                
                ShopCart *model = [ShopCart modelWithDict:dic];
                model.isSelect = YES;
                [self.commodityArray addObject:model];
            }
            
            if (self.commodityArray.count) {
                
                self.footerView.hidden = NO;
                self.bottomView.hidden = NO;
                self.emptyView.hidden = YES;
                [self.tableView reloadData];
                
                self.totalPrice = [self getTotalPrice];
                
                [self.bottomView.totalPriceLabel setText:[NSString stringWithFormat:@"￥%.2f", self.totalPrice]];
                [self.bottomView.totalPriceLabel sizeToFit];
                
                self.bottomView.selectAllButton.selected = YES;
                
            } else {
                self.footerView.hidden = YES;
                self.bottomView.hidden = YES;
                self.emptyView.hidden = NO;
            }
            
            [self.refreshControl endRefreshing];

        }
        else {
            if (!self.commodityArray.count) {
                self.footerView.hidden = YES;
                self.bottomView.hidden = YES;
                self.emptyView.hidden = NO;

                
            }
        }
        
    } failure:^(NSError *error, NSInteger statusCode) {
        [self.refreshControl endRefreshing];
        [self showInfoWidthError:error];
    }];
    
}

- (IBAction)selectAllButtonTouchUpInside:(UIButton *)sender {
    sender.selected = !sender.isSelected;

    CGFloat totalPrice = 0.0f;
    
    if (sender.isSelected) { // 全选
        
        for (ShopCart *model in self.commodityArray) {
            CGFloat price = [model.productNum integerValue] * [model.salePrice floatValue];
            model.isSelect = YES;
            totalPrice += price;
            
        }
        self.totalPrice = totalPrice;
        
    } else { // 全不选
        for (ShopCart *model in self.commodityArray) {
            model.isSelect = NO;
        }
        self.totalPrice = 0.0f;
    }
    [self.tableView reloadData];
    [self.bottomView.totalPriceLabel setText:[NSString stringWithFormat:@"￥%.2f", self.totalPrice]];
    [self.bottomView.totalPriceLabel sizeToFit];
}

- (IBAction)orderButtonTouchUpInside:(UIButton *)sender {
    NSLog(@"下单");
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < self.commodityArray.count; i++) {
        
        ShopCart *model = self.commodityArray[i];
        
        if (model.isSelect) {
            
            [arr addObject:model];
        }
    }
    
    if (arr.count == 0) {
        return [Tools myHud:@"请选择商品" inView:self.view];
    }
    
    // 保存商品列表
    NSMutableArray *listArray = [NSMutableArray array];
    for (int i = 0; i < arr.count; i++) {
        
        ShopCart *model = arr[i];
        NSDictionary *dic = @{@"Id":[NSString stringWithFormat:@"%zd",[model.ID integerValue]],
                              @"num":[NSString stringWithFormat:@"%zd",[model.productNum integerValue]]};
        
        [listArray addObject:dic];
    }
    
    NSDictionary *listDict = @{@"List":listArray};
    NSString *jsonString = [Utillity DataTOjsonString:listDict];
    NSString *urlString = [NSString stringWithFormat:SUMBITORDER,jsonString];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"%20" withString:@""];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"%0A" withString:@""];
    SLog(@"=====选好了=====%@",urlString);
    
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:POST setSerializer:Json isShowLoading:YES success:^(id data)
     {
         if ([data[@"issuccess"] boolValue]) {
             
             // 提交订单页
             SubmitOrderViewController *paymentVC = [[SubmitOrderViewController alloc] init];
             paymentVC.goodsArray = arr;
             [self.navigationController pushViewController:paymentVC animated:YES];
             
         }
         else [Tools myHud:data[@"context"] inView:self.view];
         
     } failure:^(NSError *error) {
         NSLog(@"%@",error);
         [self showInfoWidthError:error];
     }];

}

- (CGFloat)getTotalPrice {
    CGFloat totalPrice = 0.0f;
    
    for (ShopCart *model in self.commodityArray) {
        if (!model.isSelect) {
            continue;
        }
        if (model.isSelect) {
            CGFloat price = [model.productNum integerValue] * [model.salePrice floatValue];
            totalPrice += price;
        }
    }
    return totalPrice;
}

- (BOOL)isAllSelected {
    BOOL b = YES;
    for (ShopCart *model in self.commodityArray) {
        if (!model.isSelect) {
            b = NO;
            break;
        }
    }
    return b;
}

/// 逛逛
- (IBAction)strollButtonTouchUpInside:(UIButton *)sender {
    if ([self.tabBarController.tabBar isHidden]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        self.tabBarController.selectedIndex = 1;
    }
}

- (void)getShoppingCartCount {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uidString = [defaults objectForKey:@"UID"];
    NSString *midString = [defaults objectForKey:@"MID"];
    
    NSString *urlString = [NSString stringWithFormat:SHOPPINGCARTNUM, UUID, uidString, midString];
    
    NSLog(@"购物车 = %@",urlString);
    [XFNetworking GET:urlString parameters:nil success:^(id responseObject, NSInteger statusCode) {
        
        NSDictionary *dict = [self dictWithData:responseObject];
        
        if ([dict[@"sum"] integerValue] == 0) {
            [[[[[self tabBarController] tabBar] items] objectAtIndex:2] setBadgeValue:nil];
            return;
        }
        
        // 设置 tabbar badge
        [[[[[self tabBarController] tabBar] items] objectAtIndex:2] setBadgeValue:[NSString stringWithFormat:@"%@", dict[@"sum"]]];
        
    } failure:^(NSError *error, NSInteger statusCode) {
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@", error.domain]];
    }];
}

#pragma mark 获取积分等
-(void)requestPoint {
    NSString *urlString = [NSString stringWithFormat:GetUSERINFO,[[NSUserDefaults standardUserDefaults] objectForKey:@"UID"]];
    
    NSLog(@"==获取积分、余额、优惠券==%@",urlString);
    
    [XFNetworking GET:urlString parameters:nil success:^(id responseObject, NSInteger statusCode) {
        NSDictionary *dataDict = [self dictWithData:responseObject];
        
        if ([[dataDict objectForKey:@"issuccess"] boolValue]) {
            
            self.point = dataDict[@"point"];
            self.tick = dataDict[@"TickNum"];
            
            [self.footerView.pointLabel setText:[NSString stringWithFormat:@"积分%@，可抵用%.2f元", self.point, [self.point floatValue] / 1000.0f]];
            [self.footerView.pointLabel sizeToFit];
            
            [self.footerView.couponLabel setText:[NSString stringWithFormat:@"优惠券%@张", self.tick]];
            [self.footerView.couponLabel sizeToFit];

            [self.tableView reloadData];
        }
    } failure:^(NSError *error, NSInteger statusCode) {
        [self showInfoWidthError:error];
    }];
    
}

#pragma mark 获取购物车数量
- (void)getShoppingCartNum {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uidString = [defaults objectForKey:@"UID"];
    NSString *midString = [defaults objectForKey:@"MID"];
    
    NSString *urlString = [NSString stringWithFormat:SHOPPINGCARTNUM,UUID,uidString,midString];
    [XFNetworking GET:urlString parameters:nil success:^(id responseObject, NSInteger statusCode) {
        NSDictionary *data = [self dictWithData:responseObject];
        if ([data[@"issuccess"] boolValue]) {
            int sum = [[data objectForKey:@"sum"] intValue];
            
            // 设置 tabbar badge
            if (sum == 0) {
                [[[[[self tabBarController] tabBar] items] objectAtIndex:2] setBadgeValue:nil];
            } else {
                [[[[[self tabBarController] tabBar] items] objectAtIndex:2] setBadgeValue:[NSString stringWithFormat:@"%ld", sum]];
            }
            
        } else {
            [SVProgressHUD showInfoWithStatus:data[@"context"]];
        }
        [_tableView reloadData];
    } failure:^(NSError *error, NSInteger statusCode) {
        [self showInfoWidthError:error];
    }];
}


#pragma mark -
#pragma mark - LazyLoad

- (NSMutableArray *)commodityArray {
    if (!_commodityArray) {
        _commodityArray = [NSMutableArray array];
        
    }
    return _commodityArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.refreshControl = self.refreshControl;
        _tableView.separatorInset = UIEdgeInsetsMake(0, -10, 0, 0);
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
        _tableView.tableFooterView = [[UIView alloc] init];
        //_tableView.tableFooterView.height = 10;
        //_tableView.tableFooterView = self.footerView;

    }
    return _tableView;
}

- (UIRefreshControl *)refreshControl {
    if (!_refreshControl) {
        _refreshControl = [[UIRefreshControl alloc] init];
        [_refreshControl addTarget:self action:@selector(getCommodityData) forControlEvents:UIControlEventValueChanged];
    }
    return _refreshControl;
}

- (FSShoppingCartBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([FSShoppingCartBottomView class]) owner:self options:nil] lastObject];
        
        _bottomView.layer.shadowColor = [UIColor blackColor].CGColor;
        _bottomView.layer.shadowOpacity = .3f;
        _bottomView.layer.shadowOffset = CGSizeMake(0, 0);
        _bottomView.layer.shadowRadius = 2;
        //_bottomView.layer.shouldGroupAccessibilityChildren = NO;
        _bottomView.hidden = YES;
    }
    return _bottomView;
}

- (FSShoppingCartTVFooterView *)footerView {
    if (!_footerView) {
        _footerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([FSShoppingCartTVFooterView class]) owner:self options:nil] lastObject];
        _footerView.hidden = YES;
    }
    return _footerView;
}

- (FSEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([FSEmptyView class]) owner:self options:nil] lastObject];
        _emptyView.hidden = YES;
    }
    return _emptyView;
}

@end
