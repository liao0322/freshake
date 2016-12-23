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

@interface FSSearchResultsViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic) UITableView *tableView;

@property (nonatomic) UISearchBar *searchBar;

@property (copy, nonatomic) NSMutableArray *dataArray;

@end

@implementation FSSearchResultsViewController

static NSString * const searchResultTVCellID = @"searchResultTVCellID";

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)addSubviews {
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.tableView.frame = self.view.bounds;
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
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FSSearchResultTVCell *cell = [tableView dequeueReusableCellWithIdentifier:searchResultTVCellID forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
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

@end
