//
//  FSClassificationViewController.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/14.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSClassificationViewController.h"
#import "FSClassificationModel.h"
#import <MJExtension.h>
#import "FSCommodityModel.h"
#import "FSClassificationCVCell.h"
#import "FSCommodityTVCell.h"
#import "FSSearchViewController.h"
#import "FSLoginViewController.h"
#import "FSNavigationController.h"
#import "GoodsDetailViewController.h"


@interface FSClassificationViewController ()
<
    UITableViewDelegate,
    UITableViewDataSource,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    FSCommodityTVCellDelegate,
    UISearchBarDelegate
>



@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) UITableView *tableView;

/// 商品数组
@property (copy, nonatomic) NSMutableArray *commodityArray;

@property (assign, nonatomic) CGFloat lastTVY;

@property (nonatomic) UIRefreshControl *refreshControl;

@property (nonatomic) NSIndexPath *selectedIndexPath;

@property (nonatomic) UISearchBar *searchBar;

@property (assign, nonatomic) BOOL isCellSelected;

@property (nonatomic) UIImageView *cartAnimView;

@end

@implementation FSClassificationViewController

static NSString * const classificationCVCellID = @"classificationCVCellID";
static NSString * const commodityTVCellID = @"commodityTVCellID";

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.refreshControl.refreshing) {
        return;
    }
    if (self.commodityArray.count) {
        return;
    }
    if (self.tableView.contentOffset.y == 0) {
        
        [UIView animateWithDuration:0.25
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^(void){
                             self.tableView.contentOffset = CGPointMake(0, -self.refreshControl.frame.size.height);
                         } completion:^(BOOL finished){
                             [self.refreshControl beginRefreshing];
                             [self.refreshControl sendActionsForControlEvents:UIControlEventValueChanged];
                         }];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshData];
}

- (void)viewDidDisappear:(BOOL)animated {
    if (!self.refreshControl.refreshing) {
        return;
    }
    [self.refreshControl endRefreshing];
    [self setTabBarHidden:NO];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.collectionView.x = 0;
    self.collectionView.y = 64;
    self.collectionView.width = self.view.width;
    self.collectionView.height = (int)(self.view.width / 4 + 0.5);
    
    self.tableView.frame = self.view.bounds;
    self.tableView.y = self.collectionView.bottom + 5;
    self.tableView.height = self.view.height - self.collectionView.bottom;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);


}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Override

- (void)initialization {
    [super initialization];
    self.view.backgroundColor = [UIColor colorViewBG];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    self.isCellSelected = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userIsLogined) name:@"UserIsLogined" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userIsLogout) name:@"UserIsLogout" object:nil];

}

- (void)setupNavigationBar {
    [super setupNavigationBar];
    
    self.navigationItem.titleView = self.searchBar;
    
}

- (void)addSubviews {
    [super addSubviews];

    [self.view addSubview:self.tableView];
    [self.view addSubview:self.collectionView];

}

- (void)registerCells {
    [super registerCells];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FSCommodityTVCell class]) bundle:nil] forCellReuseIdentifier:commodityTVCellID];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([FSClassificationCVCell class]) bundle:nil] forCellWithReuseIdentifier:classificationCVCellID];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger section = 0;
    if (self.commodityArray.count) {
        section = self.commodityArray.count;
    }
    return section;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    FSClassificationModel *model = self.commodityArray[section];
    NSInteger row = 0;
    if (self.commodityArray.count) {
        row = model.List.count;
    }
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FSCommodityTVCell *cell = [tableView dequeueReusableCellWithIdentifier:commodityTVCellID forIndexPath:indexPath];
    FSClassificationModel *classificationModel = self.commodityArray[indexPath.section];
    FSCommodityModel *commodityModel = classificationModel.List[indexPath.row];
    cell.model = commodityModel;
    cell.delegate = self;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCREEN_WIDTH / (375 / 110);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"");
    FSClassificationModel *cModel = self.commodityArray[indexPath.section];
    FSCommodityModel *model = cModel.List[indexPath.row];
    
    GoodsDetailViewController *goodsDetailVc = [[GoodsDetailViewController alloc] init];
    NSString *productIdString = [model.id stringByReplacingOccurrencesOfString:@"," withString:@""];
    goodsDetailVc.ProductId = [productIdString integerValue];
    
    [self.navigationController pushViewController:goodsDetailVc animated:YES];
}



#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.isCellSelected = YES;
    
    // 当前选中的cell 和 前一个cell相同，那么不做任何操作
    if (self.selectedIndexPath == indexPath) {
        return;
    }
    // 当前选中的cell
    FSClassificationCVCell *cell = (FSClassificationCVCell *)[collectionView cellForItemAtIndexPath:indexPath];
    // 前一个选中的cell
    FSClassificationCVCell *prevCell = (FSClassificationCVCell *)[collectionView cellForItemAtIndexPath:self.selectedIndexPath];
    
    cell.imageView.tintColor = [UIColor orangeColor];
    prevCell.imageView.tintColor = [UIColor colorDomina];

    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    self.selectedIndexPath = indexPath;
    self.isCellSelected = NO;
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    FSClassificationCVCell *cell = (FSClassificationCVCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.imageView.tintColor = [UIColor colorDomina];
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - UICollectionViewDelegateFlowLayout

// cell size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat cellWH = SCREEN_WIDTH / 4;
    return (CGSize){(int)(cellWH + 0.5), (int)(cellWH + 0.5)};
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSInteger section = 0;
    if (self.commodityArray.count) {
        section = self.commodityArray.count;
    }
    return section;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FSClassificationCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:classificationCVCellID forIndexPath:indexPath];
    
    FSClassificationModel *model = self.commodityArray[indexPath.section];
    [cell.titleLabel setText:model.CategoryName];
    [cell.imageView setImage:[[UIImage imageNamed:@"美味生鲜"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FSClassificationCVCell *cCell = (FSClassificationCVCell *)cell;
    if (indexPath == self.selectedIndexPath) {
        cCell.imageView.tintColor = [UIColor orangeColor];
    } else {
        cCell.imageView.tintColor = [UIColor colorDomina];
    }
}

#pragma mark - FSCommodityTVCellDelegate

- (void)commodityTVCell:(FSCommodityTVCell *)cell plusButtonTouchUpInside:(UIButton *)sender {
    NSLog(@"点击了加号");
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    FSClassificationModel *cModel = self.commodityArray[indexPath.section];
    
    FSCommodityModel *model = cModel.List[indexPath.row];
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"UID"];
    NSString *mid = [[NSUserDefaults standardUserDefaults] objectForKey:@"MID"] ? [[NSUserDefaults standardUserDefaults] objectForKey:@"MID"] : @"2";
    
    __block NSInteger cartNum = [model.CartNum integerValue];
    
    // 检查用户是否登录，如果未登录，跳转到登录页
    // 如果 uid 为空
    if ([Tools isBlankString:uid]) {
        
        FSLoginViewController *loginVC = [[FSLoginViewController alloc] init];
        
        FSNavigationController *navController = [[FSNavigationController alloc] initWithRootViewController:loginVC];
        
        [self presentViewController:navController animated:YES completion:nil];
        
        //[self.navigationController pushViewController:[FSLoginViewController new] animated:YES];
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
            //[self.commodityArray replaceObjectAtIndex:indexPath.row withObject:model];
            //[cModel.List replaceObjectAtIndex:indexPath.row withObject:model];
            // 更新 UI
            [cell.countLabel setText:model.CartNum];
            
            // 设置 tabbar badge
            NSInteger badgeValue = [[[[[[self tabBarController] tabBar] items] objectAtIndex:2] badgeValue] integerValue];
            badgeValue++;
            [[[[[self tabBarController] tabBar] items] objectAtIndex:2] setBadgeValue:[NSString stringWithFormat:@"%ld", badgeValue]];
            
        }
        
    } failure:^(NSError *error, NSInteger statusCode) {
        [self showInfoWidthError:error];
    }];
    
}

- (void)commodityTVCell:(FSCommodityTVCell *)cell minusButtonTouchUpInside:(UIButton *)sender {
    NSLog(@"点击了减号");
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    FSClassificationModel *cModel = self.commodityArray[indexPath.section];
    
    FSCommodityModel *model = cModel.List[indexPath.row];
    
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
            //[self.commodityArray replaceObjectAtIndex:indexPath.row withObject:model];
            
            // 更新 UI
            [cell.countLabel setText:model.CartNum];
            
            // 设置 tabbar badge
            NSInteger badgeValue = [[[[[[self tabBarController] tabBar] items] objectAtIndex:2] badgeValue] integerValue];
            badgeValue--;
            if (badgeValue == 0) {
                [[[[[self tabBarController] tabBar] items] objectAtIndex:2] setBadgeValue:nil];
            } else {
                [[[[[self tabBarController] tabBar] items] objectAtIndex:2] setBadgeValue:[NSString stringWithFormat:@"%ld", badgeValue]];
            }
        }
        
    } failure:^(NSError *error, NSInteger statusCode) {
        [self showInfoWidthError:error];
    }];
    
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.lastTVY = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.collectionView) {
        return;
    }
    
    if (scrollView.contentOffset.y > 0) {
        
        if (self.lastTVY > scrollView.contentOffset.y) { // 往下
            [self setTabBarHidden:NO];
        } else { // 往上
            [self setTabBarHidden:YES];
        }
    }
    self.lastTVY = scrollView.contentOffset.y;
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    NSLog(@"");
    if (scrollView == self.collectionView) {
        return;
    }
    if (self.isCellSelected) {
        return;
    }
    
    NSIndexPath *topIndexpath = [[self.tableView indexPathsForVisibleRows] firstObject];
    NSIndexPath *willSelectIndexPath = [NSIndexPath indexPathForRow:0 inSection:topIndexpath.section];
    
    NSLog(@" top section = %ld", topIndexpath.section);
    NSLog(@" will section = %ld", willSelectIndexPath.section);
    
    // 前一个选中的cell
    FSClassificationCVCell *prevCell = (FSClassificationCVCell *)[self.collectionView cellForItemAtIndexPath:self.selectedIndexPath];
    
    // 将要选中的cell
    FSClassificationCVCell *aCell = (FSClassificationCVCell *)[self.collectionView cellForItemAtIndexPath:willSelectIndexPath];
    
    prevCell.imageView.tintColor = [UIColor colorDomina];
    aCell.imageView.tintColor = [UIColor orangeColor];
    
    self.selectedIndexPath = willSelectIndexPath;
    
    [self.collectionView selectItemAtIndexPath:willSelectIndexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    FSSearchViewController *searchVC = [[FSSearchViewController alloc] init];
    
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:searchVC];
    navController.navigationBar.tintColor = [UIColor colorDomina];
    [self presentViewController:navController animated:NO completion:nil];
    return NO;
}

#pragma mark - Custom

- (void)userIsLogined {
    [self getDataFromRemote];
}

- (void)userIsLogout {
    [self getDataFromRemote];
}

#pragma mark 加入购物车动画
- (void)initImage:(CGRect)rect withImage:(UIImage *)image {
    
    UITabBar *tabBar = [[self tabBarController] tabBar];
    
    CGFloat posY = SCREEN_HEIGHT - 49;
    CGFloat itemW = tabBar.width * 0.25;
    
    CGFloat posX = itemW * 2 + 15;
    
    NSLog(@"%@", NSStringFromCGRect(tabBar.frame));
    
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
        
        self.cartAnimView.frame = CGRectMake(posX + 27.5, posY + 27.5, 0, 0);
        
    } completion:^(BOOL finished) {
        [self.cartAnimView removeFromSuperview];
        self.cartAnimView = nil;
    }];
}

- (void)refreshData {
    // 获取商品数据
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *midString = [userDefaults objectForKey:@"MID"];
    NSString *uidString = [userDefaults objectForKey:@"UID"];
    
    NSString *urlString = [NSString stringWithFormat:CLASSIFYURL, midString, uidString];
    
    NSLog(@"%@",urlString);
    
    if (self.categoryId) {
        urlString = [NSString stringWithFormat:PUSHCLASSIFYURL,midString,_categoryId,uidString];
    }
    
    [XFNetworking GET:urlString parameters:nil success:^(id responseObject, NSInteger statusCode) {
        [self.refreshControl endRefreshing];
        [self.commodityArray removeAllObjects];
        
        // 类别数据
        NSDictionary *dictData = [self dictWithData:responseObject];
        NSArray *arr = dictData[@"ClassList"];
        
        [FSClassificationModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"List": NSStringFromClass([FSCommodityModel class])
                     };
        }];
        
        for (NSDictionary *dict in arr) {
            FSClassificationModel *classificationModel = [FSClassificationModel mj_objectWithKeyValues:dict];
            [self.commodityArray addObject:classificationModel];
        }
        
        NSLog(@"%@",self.commodityArray);
        [self.tableView reloadData];
        
        self.collectionView.hidden = NO;
        [self.collectionView reloadData];
        //[self collectionView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
        
        
        /*
         [_commodityTypeView createCommodityType:_commodityArray];
         [_commodityTableView refreshTableView];
         [_commodityTableView.commodityTableView.mj_header endRefreshing];
         
         if (_commodityArray.count == 0 && !_isSingleGoods) {
         
         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"该提货点没有商品，请选择其他提货点" preferredStyle:UIAlertControllerStyleAlert];
         [self.navigationController presentViewController:alertController animated:YES completion:nil];
         
         UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
         {
         [self goAddressSelect];
         }];;
         [alertController addAction:alertAction];
         }
         */
        
    } failure:^(NSError *error, NSInteger statusCode) {
        [self.refreshControl endRefreshing];
        [self showInfoWidthError:error];
    }];
    
    
}



//隐藏显示tabbar
- (void)setTabBarHidden:(BOOL)hidden
{
    UIView *tab = self.tabBarController.view;
    CGRect  tabRect=self.tabBarController.tabBar.frame;
    if ([tab.subviews count] < 2) {
        return;
    }
    
    UIView *view;
    if ([[tab.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]]) {
        view = [tab.subviews objectAtIndex:1];
    } else {
        view = [tab.subviews objectAtIndex:0];
    }
    
    if (hidden) {
        view.frame = tab.bounds;
        tabRect.origin.y=[[UIScreen mainScreen] bounds].size.height+self.tabBarController.tabBar.frame.size.height;
    } else {
        view.frame = CGRectMake(tab.bounds.origin.x, tab.bounds.origin.y, tab.bounds.size.width, tab.bounds.size.height);
        tabRect.origin.y=[[UIScreen mainScreen] bounds].size.height-self.tabBarController.tabBar.frame.size.height;
    }
    
    [UIView animateWithDuration:0.5f animations:^{
        self.tabBarController.tabBar.frame=tabRect;
    }completion:^(BOOL finished) {
        
    }];
    
}

#pragma mark -

#pragma mark - LazyLoad

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.y = 0;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.hidden = YES;
        
        /*
        _collectionView.layer.shadowColor = [UIColor blackColor].CGColor;
        _collectionView.layer.shadowOpacity = .5f;
        _collectionView.layer.shadowOffset = CGSizeMake(0, 0);
        _collectionView.layer.shadowRadius = 3;
        _collectionView.layer.shouldGroupAccessibilityChildren = NO;
         */
        

    }
    return _collectionView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.refreshControl = self.refreshControl;
        _tableView.separatorInset = UIEdgeInsetsMake(0, -10, 0, 0);
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.backgroundColor = [UIColor colorViewBG];

    }
    return _tableView;
}

- (NSMutableArray *)commodityArray {
    if (!_commodityArray) {
        _commodityArray = [NSMutableArray array];
    }
    return _commodityArray;
}

- (UIRefreshControl *)refreshControl {
    if (!_refreshControl) {
        _refreshControl = [[UIRefreshControl alloc] init];
        [_refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    }
    return _refreshControl;
}


- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.delegate = self;
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchBar.placeholder = @"搜索";
    }
    return _searchBar;
}

@end
