//
//  FSNewCommodityViewController.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/28.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSNewCommodityViewController.h"
#import "FSNewCommodityTVCell.h"
#import "FSShoppingCartIcon.h"
#import "FSShoppingCartViewController.h"
#import "GoodsDetailViewController.h"
#import "NewPruduct.h"
#import "FSLoginViewController.h"
#import "FSNavigationController.h"

@interface FSNewCommodityViewController ()
<
    UITableViewDelegate,
    UITableViewDataSource,
    FSNewCommodityTVCellDelegate
>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (copy, nonatomic) NSMutableArray *dataArray;

@property (nonatomic) FSShoppingCartIcon *cartView;

@property (nonatomic) UIImageView *cartAnimView;

@property (assign, nonatomic) NSInteger totalCartNumber;

@end

@implementation FSNewCommodityViewController

static NSString * const newCommodityTVCellID = @"newCommodityTVCellID";

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestDataFromNet];
    [self getShoppingCartNum];
}
- (void)initialization {
    [super initialization];
    self.title = self.isNewGoods ? @"新品" : @"促销";
    self.tableView.separatorInset = UIEdgeInsetsMake(0, -10, 0, 0);
    self.tableView.tableFooterView = [UIView new];
}

- (void)registerCells {
    [super registerCells];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FSNewCommodityTVCell class]) bundle:nil] forCellReuseIdentifier:newCommodityTVCellID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addSubviews {
    [super addSubviews];
    [self.view addSubview:self.cartView];
}

- (void)getDataFromRemote {
    [super getDataFromRemote];

}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.cartView.width = 54;
    self.cartView.height = 54;
    self.cartView.right = self.view.width - 15;
    self.cartView.bottom = self.view.height - 40;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    rows = self.dataArray.count ? self.dataArray.count : 0;
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FSNewCommodityTVCell *cell = [tableView dequeueReusableCellWithIdentifier:newCommodityTVCellID forIndexPath:indexPath];
    cell.delegate = self;
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewPruduct *model = self.dataArray[indexPath.row];
    
    GoodsDetailViewController *goodsDetailVc = [[GoodsDetailViewController alloc] init];
    NSString *productIdString = [[model.Id stringValue] stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    goodsDetailVc.ProductId = [productIdString integerValue];
    
    [self.navigationController pushViewController:goodsDetailVc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 135.0f;
}

#pragma mark - FSNewCommodityTVCellDelegate

- (void)newCommodityTVCell:(FSNewCommodityTVCell *)cell plusButtonTouchUpInside:(UIButton *)sender {
    NSLog(@"点击了加号");
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NewPruduct *model = self.dataArray[indexPath.row];
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"UID"];
    NSString *mid = [[NSUserDefaults standardUserDefaults] objectForKey:@"MID"] ? [[NSUserDefaults standardUserDefaults] objectForKey:@"MID"] : @"2";
    
    __block NSInteger cartNum = [model.CartNum integerValue];
    
    // 检查用户是否登录，如果未登录，跳转到登录页
    // 如果 uid 为空
    if ([Tools isBlankString:uid]) {
        
        FSLoginViewController *loginVC = [[FSLoginViewController alloc] init];
        FSNavigationController *navController = [[FSNavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:navController animated:YES completion:nil];
        return ;
    }
    
    
    NSString *totPriceString = @"0";
    NSString *urlString = @"";
    
    if (cartNum == 0) { // 第一次添加到购物车
        
        urlString = [NSString stringWithFormat:ADDCARTURL, [model.Id stringValue], UUID, uid, totPriceString, @"1", mid, @"11"];
        
    } else { // 更新购物车数量
        urlString = [NSString stringWithFormat:UpCart, UUID, mid, [model.Id stringValue],uid,[NSString stringWithFormat:@"%ld", cartNum + 1], @"0"];
    }
    [SVProgressHUD show];
    // 发送请求
    [XFNetworking GET:urlString parameters:nil success:^(id responseObject, NSInteger statusCode) {
        [SVProgressHUD dismiss];
        
        NSDictionary *dataDict = [self dictWithData:responseObject];
        
        if ([dataDict[@"issuccess"] boolValue]) { // 成功
            
            // 动画
            CGRect rect = [cell.iconImageView convertRect:cell.iconImageView.bounds toView:self.view];
            [self initImage:rect withImage:cell.iconImageView.image];
            
            cartNum++;
            model.CartNum = [NSString stringWithFormat:@"%ld", cartNum];

            // 更新 UI
            [cell.countLabel setText:model.CartNum];
            
            // 设置 tabbar badge
            self.totalCartNumber += 1;
            
            [self.cartView.countLabel setText:[NSString stringWithFormat:@"%ld", self.totalCartNumber]];
            [self.cartView setNeedsLayout];
        }
        
    } failure:^(NSError *error, NSInteger statusCode) {
        [self showInfoWidthError:error];
    }];
}

- (void)newCommodityTVCell:(FSNewCommodityTVCell *)cell minusButtonTouchUpInside:(UIButton *)sender {
    NSLog(@"点击了减号");
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    NewPruduct *model = self.dataArray[indexPath.row];
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"UID"];
    NSString *mid = [[NSUserDefaults standardUserDefaults] objectForKey:@"MID"] ? [[NSUserDefaults standardUserDefaults] objectForKey:@"MID"] : @"2";
    
    __block NSInteger cartNum = [model.CartNum integerValue];
    
    NSString *urlString = @"";
    
    if (cartNum > 1) { // 更新商品的数量
        urlString = [NSString stringWithFormat:UpCart, UUID, mid, [model.Id stringValue], uid,[NSString stringWithFormat:@"%ld", cartNum - 1], @"1"];
    } else { // 从购物车删除商品
        urlString = [NSString stringWithFormat:DelCartUrl,UUID,mid,[model.Id stringValue],uid];
    }
    
    [SVProgressHUD show];
    [XFNetworking GET:urlString parameters:nil success:^(id responseObject, NSInteger statusCode) {
        
        [SVProgressHUD dismiss];
        NSDictionary *dataDict = [self dictWithData:responseObject];
        
        if ([dataDict[@"issuccess"] boolValue]) { // 成功
            
            cartNum--;
            model.CartNum = [NSString stringWithFormat:@"%ld", cartNum];
            
            // 更新 UI
            [cell.countLabel setText:model.CartNum];
            
            // 设置 tabbar badge
            self.totalCartNumber += 1;
            [self.cartView.countLabel setText:[NSString stringWithFormat:@"%ld", self.totalCartNumber]];
            [self.cartView setNeedsLayout];

        }
        
    } failure:^(NSError *error, NSInteger statusCode) {
        [self showInfoWidthError:error];
    }];

}

#pragma mark - Custom

#pragma mark 获取数据
-(void)requestDataFromNet
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *midString = [userDefaults objectForKey:@"MID"];
    NSString *uidString = [Tools isBlankString:[userDefaults objectForKey:@"UID"]] ? @"" : [userDefaults objectForKey:@"UID"];
    NSString *urlString = [NSString stringWithFormat:GETPRUCTLIST,midString,uidString,_specialOffer,_latest];
    [SVProgressHUD showWithStatus:@"正在加载..."];
    [XFNetworking GET:urlString parameters:nil success:^(id responseObject, NSInteger statusCode) {
        [SVProgressHUD dismiss];
        NSDictionary *data = [self dictWithData:responseObject];
        
        if ([[NSString stringWithFormat:@"%@",data[@"issuccess"]] isEqualToString:@"1"]) {
            
            [self.dataArray removeAllObjects];
            
            for (NSDictionary *dict in data[@"ClassList"]) {
                NewPruduct *model = [[NewPruduct alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [self.dataArray addObject:model];
            }
        }
        
        if (self.dataArray.count == 0) {
            _tableView.backgroundView = self.noDataView;
        } else {
            _tableView.backgroundView = nil;
            self.cartView.hidden = NO;
        }
        
        [_tableView reloadData];
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
            self.totalCartNumber = sum;
            
            [self.cartView.countLabel setText:[NSString stringWithFormat:@"%d",sum]];
            [self.cartView setNeedsLayout];
        } else {
            [SVProgressHUD showInfoWithStatus:data[@"context"]];
        }
        [_tableView reloadData];
    } failure:^(NSError *error, NSInteger statusCode) {
        [self showInfoWidthError:error];
    }];
}

#pragma mark 加入购物车动画
- (void)initImage:(CGRect)rect withImage:(UIImage *)image {
    
    CGFloat posY = self.cartView.centerY;
    CGFloat posX = self.cartView.centerX;
    
    self.cartAnimView = [[UIImageView alloc] initWithFrame:rect];
    self.cartAnimView.image = image;
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.cartAnimView];
    //[self.view addSubview:self.cartAnimView];
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1.0;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 0;
    
    //这个是让旋转动画慢于缩放动画执行
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.cartAnimView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    });
    
    [UIView animateWithDuration:1.0 animations:^{
        
        self.cartAnimView.frame = CGRectMake(posX, posY, 0, 0);
        
    } completion:^(BOOL finished) {
        [self.cartAnimView removeFromSuperview];
        self.cartAnimView = nil;
    }];
}

#pragma mark - LazyLoad

- (FSShoppingCartIcon *)cartView {
    if (!_cartView) {
        
        _cartView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([FSShoppingCartIcon class]) owner:nil options:nil] firstObject];
        
        __weak __typeof(self)weakSelf = self;
        _cartView.toShoppingCartBlock = ^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;

            NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"UID"];
            
            // 检查用户是否登录，如果未登录，跳转到登录页
            // 如果 uid 为空
            if ([Tools isBlankString:uid]) {
                
                FSLoginViewController *loginVC = [[FSLoginViewController alloc] init];
                FSNavigationController *navController = [[FSNavigationController alloc] initWithRootViewController:loginVC];
                [strongSelf presentViewController:navController animated:YES completion:nil];
                return ;
            }
            
            FSShoppingCartViewController *shoppingCartVC = [FSShoppingCartViewController new];
            [strongSelf.navigationController pushViewController:shoppingCartVC animated:YES];
        };
        
        _cartView.hidden = YES;

    }
    return _cartView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
