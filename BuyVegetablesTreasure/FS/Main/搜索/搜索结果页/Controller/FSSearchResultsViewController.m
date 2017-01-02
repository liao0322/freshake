//
//  FSSearchResultsViewController.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/11.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSSearchResultsViewController.h"
#import "FSSearchResultTVCell.h"
#import "SearchModel.h"
#import "FSSearchViewController.h"
#import "GoodsDetailViewController.h"
#import "FSShoppingCartIcon.h"
#import "FSLoginViewController.h"
#import "FSNavigationController.h"
#import "FSShoppingCartViewController.h"

@interface FSSearchResultsViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, FSSearchResultTVCellDelegate>

@property (nonatomic) UITableView *tableView;

@property (nonatomic) UISearchBar *searchBar;

@property (copy, nonatomic) NSMutableArray *dataArray;

@property (nonatomic) FSShoppingCartIcon *cartView;

//@property (nonatomic) UIImageView *cartAnimView;

@property (assign, nonatomic) NSInteger totalCartNumber;

@end

@implementation FSSearchResultsViewController

static NSString * const searchResultTVCellID = @"searchResultTVCellID";

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)addSubviews {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.cartView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.tableView.frame = self.view.bounds;
    
    self.cartView.width = 54;
    self.cartView.height = 54;
    self.cartView.right = self.view.width - 15;
    self.cartView.bottom = self.view.height - 40;
}

#pragma mark - Override

- (void)getDataFromRemote {
    [super getDataFromRemote];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *mid = [userDefaults objectForKey:@"MID"];
    NSString *uid = [userDefaults objectForKey:@"UID"];
    
    NSString *urlString = [NSString stringWithFormat:QUERYGOODS,self.serachKeyWord,@"1",mid,uid];
    
    NSString *jsonString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [SVProgressHUD show];
    [XFNetworking GET:jsonString parameters:nil success:^(id responseObject, NSInteger statusCode) {
        [SVProgressHUD dismiss];
        
        NSDictionary *dict = [self dictWithData:responseObject];
        
        if (self.dataArray.count > 0) {
            [self.dataArray removeAllObjects];
        }
        NSArray *arr = dict[@"ClassList"];

        for (NSDictionary *dic in arr) {
            for (NSDictionary *dcit in dic[@"List"]) {
                SearchModel *model = [SearchModel modelWithDict:dcit];
                [self.dataArray addObject:model];
            }
        }
        [self.tableView reloadData];
        
        if (self.dataArray.count ==0 ) {
            [Tools myHud:@"抱歉，未搜索到任何商品" inView:self.view];
        }
        
    } failure:^(NSError *error, NSInteger statusCode) {
        [self showInfoWidthError:error];
    }];
    
    [self getShoppingCartNum];
    
}

- (void)registerCells {
    [super registerCells];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FSSearchResultTVCell class]) bundle:nil] forCellReuseIdentifier:searchResultTVCellID];
    
    
}

- (void)setupNavigationBar {
    [super setupNavigationBar];
    
    self.navigationItem.titleView = self.searchBar;
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    if (self.dataArray.count) {
        rows = self.dataArray.count;
        self.cartView.hidden = NO;
    } else {
        self.cartView.hidden = YES;
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FSSearchResultTVCell *cell = [tableView dequeueReusableCellWithIdentifier:searchResultTVCellID forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 135.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchModel *model = self.dataArray[indexPath.row];
    
    GoodsDetailViewController *goods = [[GoodsDetailViewController alloc] init];
    goods.ProductId = [model.id integerValue];
    
    [self.navigationController pushViewController:goods animated:YES];
    
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    FSSearchViewController *searchVC = [[FSSearchViewController alloc] init];
    searchVC.searchController.searchBar.text = self.serachKeyWord;
    [self.navigationController popViewControllerAnimated:NO];
    return NO;
}

#pragma mark - FSSearchResultTVCellDelegate
- (void)searchResultTVCell:(FSSearchResultTVCell *)cell plusButtonTouchUpInside:(UIButton *)sender {
    
    NSLog(@"点击了加号");
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    SearchModel *model = self.dataArray[indexPath.row];
    
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
        
        urlString = [NSString stringWithFormat:ADDCARTURL, model.id, UUID, uid, totPriceString, @"1", mid, @"11"];
        
    } else { // 更新购物车数量
        urlString = [NSString stringWithFormat:UpCart, UUID, mid, model.id,uid,[NSString stringWithFormat:@"%ld", cartNum + 1], @"0"];
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

- (void)searchResultTVCell:(FSSearchResultTVCell *)cell minusButtonTouchUpInside:(UIButton *)sender {
    
    NSLog(@"点击了减号");
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    SearchModel *model = self.dataArray[indexPath.row];
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"UID"];
    NSString *mid = [[NSUserDefaults standardUserDefaults] objectForKey:@"MID"] ? [[NSUserDefaults standardUserDefaults] objectForKey:@"MID"] : @"2";
    
    __block NSInteger cartNum = [model.CartNum integerValue];
    
    NSString *urlString = @"";
    
    if (cartNum > 1) { // 更新商品的数量
        urlString = [NSString stringWithFormat:UpCart, UUID, mid, model.id, uid,[NSString stringWithFormat:@"%ld", cartNum - 1], @"1"];
    } else { // 从购物车删除商品
        urlString = [NSString stringWithFormat:DelCartUrl,UUID,mid,model.id,uid];
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
    
    __block UIImageView *cartAnimView = [[UIImageView alloc] initWithFrame:rect];
    cartAnimView.image = image;
    
    [[UIApplication sharedApplication].keyWindow addSubview:cartAnimView];
    //[self.view addSubview:self.cartAnimView];
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1.0;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 0;
    
    //这个是让旋转动画慢于缩放动画执行
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [cartAnimView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    });
    
    [UIView animateWithDuration:1.0 animations:^{
        
        cartAnimView.frame = CGRectMake(posX, posY, 0, 0);
        
    } completion:^(BOOL finished) {
        [cartAnimView removeFromSuperview];
        cartAnimView = nil;
    }];
}


#pragma mark - LazyLoad

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorInset = UIEdgeInsetsMake(0, -10, 0, 0);
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.delegate = self;
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchBar.text = self.serachKeyWord;
    }
    return _searchBar;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

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
            
//            [strongSelf.navigationController dismissViewControllerAnimated:YES completion:nil];

            FSShoppingCartViewController *shoppingCartVC = [FSShoppingCartViewController new];
            [strongSelf.navigationController pushViewController:shoppingCartVC animated:YES];
        };
        
        _cartView.hidden = YES;
        
    }
    return _cartView;
}

@end
