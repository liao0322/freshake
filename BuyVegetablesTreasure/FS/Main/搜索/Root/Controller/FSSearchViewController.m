//
//  FSSearchViewController.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/7.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSSearchViewController.h"
#import "FSSearchAssociationViewController.h"
#import "XFEqualSpaceFlowLayout.h"
#import "FSSearchCVCell.h"
#import "FSSearchHeaderTitleView.h"
#import "FSSearchFooterView.h"
#import "FSSearchResultsViewController.h"
#import "NSString+Extension.h"


@interface FSSearchViewController ()
<
    UISearchControllerDelegate,
    UISearchBarDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    UISearchResultsUpdating
>


@property (nonatomic) FSSearchAssociationViewController *associationVC;

@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) XFEqualSpaceFlowLayout *flowLayout;

@property (copy, nonatomic) NSMutableArray *hotSearchArray;
@property (copy, nonatomic) NSMutableArray *historySearchArray;

@property (copy, nonatomic) NSMutableArray *keyWordsArray;

@end

@implementation FSSearchViewController

static NSString * const searchCVCellID = @"searchCVCellID";
static NSString * const searchHeaderID = @"searchHeaderID";
static NSString * const searchFooterID = @"searchFooterID";

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 让search bar 成为第一响应者
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // self.searchController.active = YES;
        [self.searchController.searchBar becomeFirstResponder];

    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - ViewSetup

- (void)getDataFromRemote {
    [super getDataFromRemote];
    
    [self getSearchData];
    // [self getHotSearchData];
    //[self getHistorySearchData];
    
}

- (void)getSearchData {
    // 获取热搜数据
    NSString *mid = [[NSUserDefaults standardUserDefaults] objectForKey:@"MID"];
    
    NSString *urlString = [NSString stringWithFormat:GetHotS, mid];
    [XFNetworking GET:urlString parameters:nil success:^(id responseObject, NSInteger statusCode) {
        id data = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        
        BOOL isSuccess = [data[@"issuccess"] boolValue];
        if (!isSuccess) {
            [SVProgressHUD showInfoWithStatus:data[@"content"]];
            return;
        }
        
        [self.hotSearchArray removeAllObjects];
        
        for (NSDictionary *dic in data[@"list"]) {
            NSString *str = [dic[@"context"] clearAllSpace];
            if ([str length] > 0) {
                [self.hotSearchArray addObject:str];
            }
        }
        
        for (NSDictionary *dic in data[@"list1"]) {
            NSString *str = [dic[@"hotContext"] clearAllSpace];
            if ([str length] > 0) {
                [self.hotSearchArray addObject:str];
            }
        }
        self.searchController.searchBar.placeholder = data[@"searchMessger"];
        
        if ([self isLogined]) {
            [self getHistorySearchData];
        } else {
            // 更新数据
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 1)];
            [self.collectionView insertSections:indexSet];
        }

        
    } failure:^(NSError *error, NSInteger statusCode) {
        NSLog(@"请求失败");
    }];
}


- (void)getHistorySearchData {
    NSString *urlString = [NSString stringWithFormat:HISTORYURL,[[NSUserDefaults standardUserDefaults] objectForKey:@"UID"]];
    
    [XFNetworking GET:urlString parameters:nil success:^(id responseObject, NSInteger statusCode) {
        id data = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        NSArray *dataList = data[@"list"];
        if (!dataList.count) {
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 1)];
            [self.collectionView insertSections:indexSet];
            return;
        }
        if ([data[@"issuccess"] boolValue]) {
            
            if (self.historySearchArray.count > 0) {
                [self.historySearchArray removeAllObjects];
            }
            
            for (NSDictionary *dic in data[@"list"]) {
                [self.historySearchArray addObject:[dic[@"context"] clearAllSpace]];
            }
            
        } else {
            NSLog(@"%@", data[@"context"]);
        }
        
        // 更新热搜和历史搜索的数据
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)];
        [self.collectionView insertSections:indexSet];
        
    } failure:^(NSError *error, NSInteger statusCode) {
        // 更新热搜的数据
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 1)];
        [self.collectionView insertSections:indexSet];
        NSLog(@"请求失败");
    }];
}


- (void)initialization {
    [super initialization];
    
    [self.collectionView registerClass:[FSSearchCVCell class] forCellWithReuseIdentifier:searchCVCellID];

    [self.collectionView registerNib:[UINib nibWithNibName:@"FSSearchHeaderTitleView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:searchHeaderID];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([FSSearchFooterView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:searchFooterID];
    
    self.definesPresentationContext = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.titleView = self.searchController.searchBar;

}

- (void)addSubviews {
    [super addSubviews];
    [self.view addSubview:self.collectionView];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.collectionView.frame = self.view.bounds;

}

#pragma mark - UISearchControllerDelegate

- (void)willPresentSearchController:(UISearchController *)searchController {
    //[searchController.searchBar setShowsCancelButton:NO];
}

- (void)didPresentSearchController:(UISearchController *)searchController {
    NSLog(@"");
    
    /*
     [UIView animateWithDuration:0.1 animations:^{} completion:^(BOOL finished) {
         [self.searchController.searchBar becomeFirstResponder];
     }];
     */

}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    // [searchBar setShowsCancelButton:NO];
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
    for (id cc in [searchBar.subviews[0] subviews]) {
        if ([cc isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)cc;
            [btn setTitle:@"取消" forState:UIControlStateNormal];
        }
    }
}

// 取消button点击时调用
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self dismissViewControllerAnimated:NO completion:nil];
    NSLog(@"取消");
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSInteger section = 0;
    section += self.hotSearchArray.count ? 1 : 0;
    section += self.historySearchArray.count ? 1 : 0;
    return section;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger row = 0;
    
    if (section == 0) {
        row = self.hotSearchArray.count;
    } else {
        row = self.historySearchArray.count;
    }
    return row;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *text = nil;

    FSSearchCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:searchCVCellID forIndexPath:indexPath];
    if (indexPath.section == 0) {
        text = self.hotSearchArray[indexPath.row];
    } else {
        text = self.historySearchArray[indexPath.row];
    }
    [cell.textLabel setText:text];

    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        FSSearchHeaderTitleView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:searchHeaderID forIndexPath:indexPath];
        if (indexPath.section == 0) {
            headerView.titleLabel.text = @"热门搜索";
        } else {
            headerView.titleLabel.text = @"历史搜索";
        }
        
        return headerView;
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        
        if (indexPath.section != 1) {
            return nil;
        }
        FSSearchFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:searchFooterID forIndexPath:indexPath];
//        footerView.x = 0;
//        footerView.y = 0;
        
        [footerView.clearHistoryButton addTarget:self action:@selector(clearHistory:) forControlEvents:UIControlEventTouchUpInside];
        
        return footerView;
    }
    
    return nil;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *searchKeyWord = @"";
    
    if (indexPath.section == 0) {
        searchKeyWord = self.hotSearchArray[indexPath.row];
    } else {
        searchKeyWord = self.historySearchArray[indexPath.row];
    }
    
    FSSearchResultsViewController *resultsVC = [[FSSearchResultsViewController alloc] init];
    resultsVC.serachKeyWord = searchKeyWord;
    
    self.searchController.searchBar.text = searchKeyWord;
    [self.navigationController pushViewController:resultsVC animated:NO];

}


#pragma mark - UICollectionViewDelegateFlowLayout

// cell size
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *text = nil;
    
    if (indexPath.section == 0) {
        text = self.hotSearchArray[indexPath.row];
    } else {
        text = self.historySearchArray[indexPath.row];
    }
    
    CGSize cellSize = [text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}];
    
    return (CGSize){cellSize.width + 20, 40};
 
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(15, 15, 15, 15);
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 20.0f;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {

    return (CGSize){ScreenWidth, 36};
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    if (section != 1) {
        return CGSizeZero;
    }
    return (CGSize){SCREEN_WIDTH, 50};
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSLog(@" search = %@", searchController.searchBar.text);
    
    NSString *searchKeyWord = searchController.searchBar.text;

    if (searchKeyWord.length == 0) {
        return;
    }
    
    [self QueryGoodsWithText:searchKeyWord];
    
}

#pragma mark - UIScrollViewDelegate

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.navigationController.navigationBar endEditing:YES];
}

#pragma mark - Custom

#pragma mark - 查询商品
- (void)QueryGoodsWithText:(NSString *)text {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *midString = [userDefaults objectForKey:@"MID"];
    NSString *uidString = [userDefaults objectForKey:@"UID"];
    
    NSString *jsonString = [NSString stringWithFormat:QUERYGOODS,text,@"1",midString,uidString];
    jsonString = [jsonString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",jsonString);
    
    [XFNetworking GET:jsonString parameters:nil success:^(id responseObject, NSInteger statusCode) {
        if (self.keyWordsArray.count) {
            [self.keyWordsArray removeAllObjects];
        }
        
        NSDictionary *dictData = [self dictWithData:responseObject];
        
        NSArray *arr = dictData[@"ClassList"];
        
        for (NSDictionary *dic in arr) {
            for (NSDictionary *dict in dic[@"List"]) {
                NSString *name = dict[@"productName"];
                [self.keyWordsArray addObject:name];
            }
        }
        
        self.associationVC.dataArray = self.keyWordsArray;
        self.associationVC.nav = (FSNavigationController *)self.navigationController;
        [self.associationVC.tableView reloadData];
        
    } failure:^(NSError *error, NSInteger statusCode) {
        [self showInfoWidthError:error];
    }];
    

}

- (BOOL)isLogined {
    // 判断用户是否登录
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"UID"] && ![[[NSUserDefaults standardUserDefaults]objectForKey:@"UID"] isEqualToString:@""]) {
        
        // 用户已登录
        return YES;
        
    }else{
        // 用户未登录
        return NO;
    }
}

- (void)clearHistory:(UIButton *)sender {
    NSLog(@"clear history");
    
    NSString *urlString = [NSString stringWithFormat:DELSEARCH,[[NSUserDefaults standardUserDefaults] objectForKey:@"UID"]];
    
    [XFNetworking GET:urlString parameters:nil success:^(id responseObject, NSInteger statusCode) {
        NSDictionary *dataDict = [self dictWithData:responseObject];
        
        if (![dataDict[@"issuccess"] boolValue]) {
            [SVProgressHUD showInfoWithStatus:dataDict[@"context"]];
        }
        // 清除历史记录数据
        [self.historySearchArray removeAllObjects];
        
        [self.collectionView reloadData];
    } failure:^(NSError *error, NSInteger statusCode) {
        [self showInfoWidthError:error];
    }];
}


#pragma mark - LazyLoad

- (UISearchController *)searchController {
    if (!_searchController) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:self.associationVC];
        _searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchController.hidesNavigationBarDuringPresentation = NO;
        _searchController.searchResultsUpdater = self;
        _searchController.delegate = self;
        _searchController.searchBar.delegate = self;
        _searchController.dimsBackgroundDuringPresentation = NO;

        // [_searchController.searchBar setImage:[UIImage imageNamed:@"home_search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    }
    return _searchController;
}

- (FSSearchAssociationViewController *)associationVC {
    if (!_associationVC) {
        _associationVC = [[FSSearchAssociationViewController alloc] init];
    }
    return _associationVC;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
//        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[UICollectionViewFlowLayout new]];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;

    }
    return _collectionView;
}

- (XFEqualSpaceFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[XFEqualSpaceFlowLayout alloc] init];
    }
    return _flowLayout;
}

- (NSMutableArray *)hotSearchArray {
    if (!_hotSearchArray) {
        _hotSearchArray = [NSMutableArray array];
    }
    return _hotSearchArray;
}

- (NSMutableArray *)historySearchArray {
    if (!_historySearchArray) {
        _historySearchArray = [NSMutableArray array];
    }
    return _historySearchArray;
}

- (NSMutableArray *)keyWordsArray {
    if (!_keyWordsArray) {
        _keyWordsArray = [NSMutableArray array];
    }
    return _keyWordsArray;
}


@end
