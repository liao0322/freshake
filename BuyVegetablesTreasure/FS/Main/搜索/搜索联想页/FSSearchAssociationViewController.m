//
//  FSSearchAssociationViewController.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/15.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSSearchAssociationViewController.h"
#import "FSSearchResultsViewController.h"

@interface FSSearchAssociationViewController ()<UITableViewDelegate, UITableViewDataSource>





@end

@implementation FSSearchAssociationViewController

static NSString * const defaultTVCellID = @"defaultTVCellID";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (void)registerCells {
    [super registerCells];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:defaultTVCellID];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FSSearchResultsViewController *resultsVC = [[FSSearchResultsViewController alloc] init];
    resultsVC.serachKeyWord = self.dataArray[indexPath.row];
    UISearchController *searchVC = (UISearchController *)self.parentViewController;
    searchVC.searchBar.text = self.dataArray[indexPath.row];
    
    [self.nav pushViewController:resultsVC animated:NO];
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = self.dataArray.count ? self.dataArray.count : 0;
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultTVCellID forIndexPath:indexPath];
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    UISearchController *searchVC = (UISearchController *)self.parentViewController;
    [searchVC.searchBar resignFirstResponder];
}

#pragma mark - LazyLoad

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
    
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
