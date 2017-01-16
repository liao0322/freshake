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
#import "GoodsDetailViewController.h"

@interface FSShoppingCartViewController ()
<
    UITableViewDelegate,
    UITableViewDataSource,
    FSShoppingCartTVCellDelegate
>

// 正常商品数据
@property (copy, nonatomic) NSMutableArray *commodityArray;

// 失效商品数据
@property (copy, nonatomic) NSMutableArray *invalidCommodityArray;



@property (nonatomic) UITableView *tableView;

@property (nonatomic) UIRefreshControl *refreshControl;

// 结算按钮所在的view
@property (nonatomic) FSShoppingCartBottomView *bottomView;

@property (nonatomic) FSShoppingCartTVFooterView *footerView;

// 购物车为空时显示的view
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
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    [XFWaterWaveView showLoading];
    [self getCommodityData];
    [self getShoppingCartNum];
    [self requestPoint];
}

#pragma mark - Override

- (void)initialization {
    [super initialization];
    self.title = @"购物车";
    self.totalPrice = 0.0f;
    self.view.backgroundColor = [UIColor colorWithRGBHex:0xededed];
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger sections = 0;
    if (self.commodityArray.count) {
        sections += 1;
    }
    if (self.invalidCommodityArray.count) {
        sections += 1;
    }
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    if (section == 0 && self.commodityArray.count) {
        rows = self.commodityArray.count;
    } else {
        rows = self.invalidCommodityArray.count;
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FSShoppingCartTVCell *cell = [tableView dequeueReusableCellWithIdentifier:shoppingCartTVCellID forIndexPath:indexPath];
    cell.delegate = self;
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    ShopCart *model = nil;
    
    if (section == 0 && self.commodityArray.count) {
        model = self.commodityArray[row];
    } else {
        model = self.invalidCommodityArray[row];
    }

    cell.model = model;
    return cell;
}

/*
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = nil;
    if (self.invalidCommodityArray.count) { // 有无效商品
        
        if (self.commodityArray.count) { // 有正常商品
            if (section == 1) {
                label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 30)];
                label.font = [UIFont systemFontOfSize:14];
                [label setTextColor:[UIColor lightGrayColor]];
                [label setText:@"已失效商品"];
            }
        } else {
            if (section == 0) {
                label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 30)];
                label.font = [UIFont systemFontOfSize:14];
                [label setTextColor:[UIColor lightGrayColor]];
                [label setText:@"已失效商品"];
            }
        }
    }
    UIView *view = [UIView new];
    [view addSubview:label];
    
    return view;
}
 */

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    ShopCart *model = nil;
    
    if (section == 0 && self.commodityArray.count) {
        model = self.commodityArray[row];
    } else {
        model = self.invalidCommodityArray[row];
    }
    
    GoodsDetailViewController *goodsDetailVc = [[GoodsDetailViewController alloc] init];
    NSString *productIdString = [model.ID stringByReplacingOccurrencesOfString:@"," withString:@""];
    goodsDetailVc.ProductId = [model.productId integerValue];
    
    [self.navigationController pushViewController:goodsDetailVc animated:YES];

}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    ShopCart *model = nil;
    if (section == 0 && self.commodityArray.count) {
        model = self.commodityArray[row];
    } else {
        model = [self.invalidCommodityArray objectAtIndex:row];
    }
    
    UITableViewRowAction *removeAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {

//        ShopCart *model = self.commodityArray[row];
        
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
                [self.bottomView.totalPriceLabel setText:[NSString stringWithFormat:@"￥%.2f", fabs(self.totalPrice)]];
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
            if (section == 0 && self.commodityArray.count) {
                [self.commodityArray removeObjectAtIndex:row];
            } else {
                [self.invalidCommodityArray removeObjectAtIndex:row];
            }
            
            // 刷新 tableView
            /*
            if (section == 0) { // 只有一组
                if (self.commodityArray.count == 0 && self.invalidCommodityArray.count == 0) { // 都没数据
                    [self.tableView reloadData];
                } else if (self.commodityArray.count == 0 && self.invalidCommodityArray.count != 0) {
                    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationTop];
                }
                else {
                    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                }
                
            } else {
                
                if (self.invalidCommodityArray.count) {
                    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                } else {
                    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationTop];
                }
                
            }
             */
            
            if (self.commodityArray.count == 0 && self.invalidCommodityArray.count == 0) { // 没数据了
                self.emptyView.hidden = NO;
                self.bottomView.hidden = YES;
                self.tableView.hidden = YES;
                [self.tableView reloadData];
            } else if (self.commodityArray.count == 0) { // 正常商品没数据
                self.bottomView.hidden = YES;
                self.emptyView.hidden = YES;
                self.tableView.hidden = NO;
                [self.tableView reloadData];
            } else { // 无效商品没数据
                self.bottomView.hidden = NO;
                self.emptyView.hidden = YES;
                self.tableView.hidden = NO;
                [self.tableView reloadData];
            }
            
        } failure:^(NSError *error, NSInteger statusCode) {
            [self showInfoWidthError:error];
        }];
    }];
    
    return @[removeAction];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCREEN_WIDTH / (375 / 130.0f);
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15.0f;
    
    /*
    CGFloat height = 0.0001f;
    if (self.invalidCommodityArray.count && self.commodityArray.count) {
        if (section == 0) {
            height = 15.0f;
        } else {
            height = 30.0f;
        }
    } else if (self.invalidCommodityArray.count) {
        height = 30.0f;
    } else {
        height = 15.0f;
    }
    return height;
     */
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGFloat height = 0.0001f;
    if (section == 0 && self.commodityArray.count) {
        height = 80.0f;
    }
    return height;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [UIView new];
    if (section == 0 && self.commodityArray.count) {
        footerView = self.footerView;
    }
    return footerView;
    
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
                
                [self.bottomView.totalPriceLabel setText:[NSString stringWithFormat:@"￥%.2f", fabs(self.totalPrice)]];
                [self.bottomView.totalPriceLabel sizeToFit];
            }
        }
        
    } failure:^(NSError *error, NSInteger statusCode) {
        [self showInfoWidthError:error];
    }];

    
}

// 从购物车移除商品
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
                
                [self.bottomView.totalPriceLabel setText:[NSString stringWithFormat:@"￥%.2f", fabs(self.totalPrice)]];
                [self.bottomView.totalPriceLabel sizeToFit];
            }
            
            if (cartNum == 0) { // 从本地删除购物车
                
                [self.commodityArray removeObjectAtIndex:indexPath.row];
                
                if (self.commodityArray.count == 0) {
                    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationTop];
                } else {
                    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                }
            }
            
            if (self.commodityArray.count == 0 && self.invalidCommodityArray.count == 0) { // 没数据了
                self.emptyView.hidden = NO;
                self.bottomView.hidden = YES;
                self.tableView.hidden = YES;
                [self.tableView reloadData];
            } else if (self.commodityArray.count == 0) { // 正常商品没数据
                self.bottomView.hidden = YES;
                self.emptyView.hidden = YES;
                self.tableView.hidden = NO;
                [self.tableView reloadData];
            } else { // 无效商品没数据
                self.bottomView.hidden = NO;
                self.emptyView.hidden = YES;
                self.tableView.hidden = NO;
                [self.tableView reloadData];
            }
            
        }
        
    } failure:^(NSError *error, NSInteger statusCode) {
        [self showInfoWidthError:error];
    }];

}

// 选择商品
- (void)shoppingCartTVCell:(FSShoppingCartTVCell *)cell selectButtonTouchUpInside:(UIButton *)sender {
    NSLog(@"选");
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ShopCart *model = self.commodityArray[indexPath.row];
    if (sender.isSelected) { // 选中
        model.isSelect = YES;
        CGFloat price = [model.productNum integerValue] * [model.salePrice floatValue];
        
        self.totalPrice += price;
        [self.bottomView.totalPriceLabel setText:[NSString stringWithFormat:@"￥%.2f", fabs(self.totalPrice)]];
        [self.bottomView.totalPriceLabel sizeToFit];
        self.bottomView.selectAllButton.selected = [self isAllSelected];
        
    } else { // 不选
        
        model.isSelect = NO;
        CGFloat price = [model.productNum integerValue] * [model.salePrice floatValue];
        self.totalPrice -= price;
        [self.bottomView.totalPriceLabel setText:[NSString stringWithFormat:@"￥%.2f", fabs(self.totalPrice)]];
        [self.bottomView.totalPriceLabel sizeToFit];
        self.bottomView.selectAllButton.selected = NO;
    }
}

#pragma mark - Custom

// 获取购物车数据
- (void)getCommodityData {

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uidString = [defaults objectForKey:@"UID"];
    NSString *midString = [defaults objectForKey:@"MID"];
    NSString *urlString = [NSString stringWithFormat:SHOPPINGCARTGOODS,UUID,uidString,midString];
    
    [XFNetworking GET:urlString parameters:nil success:^(id responseObject, NSInteger statusCode) {
        [XFWaterWaveView dismissLoading];
        NSDictionary *dataDict = [self dictWithData:responseObject];
        
        [self.commodityArray removeAllObjects];
        [self.invalidCommodityArray removeAllObjects];
        
        if ([dataDict[@"issuccess"] boolValue]) {
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:dataDict[@"point"] forKey:@"point"];
            [userDefaults setObject:dataDict[@"TickCount"] forKey:@"TickCount"];
            
            for (NSDictionary *dic in dataDict[@"list"]) {
                
                ShopCart *model = [ShopCart modelWithDict:dic];
                
                if ([model.upselling isEqualToString:@"1"] && ([model.stock integerValue] > 0)) {
                    model.isSelect = YES;
                    model.invalid = NO;
                    [self.commodityArray addObject:model];
                } else {
                    model.isSelect = NO;
                    model.invalid = YES;
                    [self.invalidCommodityArray addObject:model];
                }
            }
            
            
            /*
            if (self.commodityArray.count == 0 && self.invalidCommodityArray.count == 0) { // 没数据了
                self.emptyView.hidden = NO;
                self.bottomView.hidden = YES;
                self.tableView.hidden = YES;
                [self.tableView reloadData];
            } else if (self.commodityArray.count == 0) { // 正常商品没数据
                self.bottomView.hidden = YES;
                [self.tableView reloadData];
            }
            */
            
            if ((self.commodityArray.count && self.invalidCommodityArray.count) || self.commodityArray.count) {
                
                self.tableView.hidden = NO;
                self.bottomView.hidden = NO;
                self.emptyView.hidden = YES;
                [self.tableView reloadData];
                self.totalPrice = [self getTotalPrice];
                [self.bottomView.totalPriceLabel setText:[NSString stringWithFormat:@"￥%.2f", fabs(self.totalPrice)]];
                [self.bottomView.totalPriceLabel sizeToFit];
                self.bottomView.selectAllButton.selected = YES;
            } else if (self.invalidCommodityArray.count){
                self.bottomView.hidden = YES;
                self.emptyView.hidden = YES;
                self.tableView.hidden = NO;
                [self.tableView reloadData];
            } else {
                self.bottomView.hidden = YES;
                self.emptyView.hidden = NO;
                self.tableView.hidden = YES;
            }
            
            
            /*
            if (self.commodityArray.count || self.invalidCommodityArray.count) { // 有数据
                
                self.bottomView.hidden = NO;
                self.emptyView.hidden = YES;
                self.tableView.hidden = NO;
                [self.tableView reloadData];
                
                self.totalPrice = [self getTotalPrice];
                
                [self.bottomView.totalPriceLabel setText:[NSString stringWithFormat:@"￥%.2f", fabs(self.totalPrice)]];
                [self.bottomView.totalPriceLabel sizeToFit];
                
                self.bottomView.selectAllButton.selected = YES;
                
            } else {
                self.bottomView.hidden = YES;
                self.emptyView.hidden = NO;
                self.tableView.hidden = YES;
            }
             */
        }
        else {
            if (!self.commodityArray.count || !self.invalidCommodityArray.count) {
                self.bottomView.hidden = YES;
                self.emptyView.hidden = NO;
                self.tableView.hidden = YES;
            }
        }
        
    } failure:^(NSError *error, NSInteger statusCode) {
        [self showInfoWidthError:error];
        [XFWaterWaveView dismissLoading];
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
    [self.bottomView.totalPriceLabel setText:[NSString stringWithFormat:@"￥%.2f", fabs(self.totalPrice)]];
    [self.bottomView.totalPriceLabel sizeToFit];
}

// 结算
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
             NSLog(@"%@", paymentVC.goodsArray);
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
                [[[[[self tabBarController] tabBar] items] objectAtIndex:2] setBadgeValue:[NSString stringWithFormat:@"%d", sum]];
            }
            
        } else {
            [SVProgressHUD showInfoWithStatus:data[@"context"]];
        }
        [_tableView reloadData];
    } failure:^(NSError *error, NSInteger statusCode) {
        [self showInfoWidthError:error];
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

            [self.tableView reloadData];
        } else {
            
            NSLog(@"%@", dataDict[@"context"]);
        }
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

- (NSMutableArray *)invalidCommodityArray {
    if (!_invalidCommodityArray) {
        _invalidCommodityArray = [NSMutableArray array];
    }
    return _invalidCommodityArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.refreshControl = self.refreshControl;
        _tableView.separatorInset = UIEdgeInsetsMake(0, -10, 0, 0);
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.hidden = YES;

//        self.tableView.sectionFooterHeight = 80.0f;
//        _tableView.backgroundColor = [UIColor colorWithRGBHex:0xededed];

        //_tableView.tableFooterView.height = 10;
        //_tableView.tableFooterView = self.footerView;

    }
    return _tableView;
}
/*
- (UIRefreshControl *)refreshControl {
    if (!_refreshControl) {
        _refreshControl = [[UIRefreshControl alloc] init];
        [_refreshControl addTarget:self action:@selector(getCommodityData) forControlEvents:UIControlEventValueChanged];
    }
    return _refreshControl;
}
*/
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
