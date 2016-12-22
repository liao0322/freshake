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

#pragma mark - Override

- (void)getDataFromRemote {
    [super getDataFromRemote];
    
    //[self.refreshControl beginRefreshing];
}

- (void)initialization {
    [super initialization];
    self.view.backgroundColor = [UIColor colorViewBG];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];

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
}

/*
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionHeader = nil;
    if (section == 0) {
        sectionHeader = self.collectionView;
    }
    return sectionHeader;
}
*/

/*
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return(int)(SCREEN_WIDTH / 4 + 0.5) + 10;
}
 */


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FSClassificationCVCell *cell = (FSClassificationCVCell *)[collectionView cellForItemAtIndexPath:indexPath];
    // cell.imageView.backgroundColor = [UIColor orangeColor];
    
    cell.imageView.tintColor = [UIColor orangeColor];
    [cell.imageView setImage:[[UIImage imageNamed:@"美味生鲜"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];

    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    self.selectedIndexPath = indexPath;
    
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
    
    if (indexPath == self.selectedIndexPath) {
        cell.imageView.tintColor = [UIColor orangeColor];
    } else {
        cell.imageView.tintColor = [UIColor colorDomina];
    }
    return cell;
    
}

#pragma mark - FSCommodityTVCellDelegate

- (void)commodityTVCell:(FSCommodityTVCell *)cell plusButtonTouchUpInside:(UIButton *)sender {
    
}

- (void)commodityTVCell:(FSCommodityTVCell *)cell minusButtonTouchUpInside:(UIButton *)sender {
    
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.lastTVY = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.collectionView) {
        return;
    }
    
    NSIndexPath *topIndexpath = [[self.tableView indexPathsForVisibleRows] firstObject];
    NSIndexPath *willSelectIndexPath = [NSIndexPath indexPathForRow:0 inSection:topIndexpath.section];
    
    //[self.collectionView selectItemAtIndexPath:willSelectIndexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    
    if (scrollView.contentOffset.y > 0) {
        
        if (self.lastTVY > scrollView.contentOffset.y) { // 往下
            [self setTabBarHidden:NO];
        } else { // 往上
            [self setTabBarHidden:YES];
        }
    }
    self.lastTVY = scrollView.contentOffset.y;
    

    
    //FSClassificationCVCell *cell = [self.collectionView cellForItemAtIndexPath:willSelectIndexPath];
    //cell.imageView.tintColor = [UIColor orangeColor];
    
    
    //[self.collectionView selectItemAtIndexPath:willSelectIndexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    
    
    
    //[self collectionView:self.collectionView didSelectItemAtIndexPath:willSelectIndexPath];
    
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

- (void)refreshData {
    // 获取商品数据
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *midString = [userDefaults objectForKey:@"MID"];
    NSString *uidString = [userDefaults objectForKey:@"UID"];
    
    NSString *urlString = [NSString stringWithFormat:CLASSIFYURL, midString, uidString];
    
    NSLog(@"%@",urlString);
    
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
        [self.collectionView reloadData];
        [self collectionView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        /*
         _commodityTypeView.hidden = NO;
         _commodityTableView.hidden = NO;
         _commodityTableView.commodityArray = _commodityArray;
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
