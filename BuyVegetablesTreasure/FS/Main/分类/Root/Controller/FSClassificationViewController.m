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

@interface FSClassificationViewController ()
<
    UITableViewDelegate,
    UITableViewDataSource,
    UICollectionViewDelegate,
    UICollectionViewDataSource
>



@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) UITableView *tableView;

/// 商品数组
@property (copy, nonatomic) NSMutableArray *commodityArray;

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

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.tableView.frame = self.view.bounds;


}

#pragma mark - Override

- (void)getDataFromRemote {
    [super getDataFromRemote];
    // 获取商品数据
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *midString = [userDefaults objectForKey:@"MID"];
    NSString *uidString = [userDefaults objectForKey:@"UID"];
    
    NSString *urlString = [NSString stringWithFormat:CLASSIFYURL, midString, uidString];

    NSLog(@"%@",urlString);
    
    [XFNetworking GET:urlString parameters:nil success:^(id responseObject, NSInteger statusCode) {
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
        
        /*
        NSLog(@"分类请求错误%@",error);
        
        [_commodityTableView.commodityTableView.mj_header endRefreshing];
         */
        // [Tools myHud:@"加载失败！请重新加载" inView:[[UIApplication sharedApplication].delegate window]];
    }];
    
}

- (void)initialization {
    [super initialization];
    
}

- (void)setupNavigationBar {
    [super setupNavigationBar];
    
}

- (void)addSubviews {
    [super addSubviews];

    [self.view addSubview:self.tableView];

}

- (void)registerCells {
    [super registerCells];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FSCommodityTVCell class]) bundle:nil] forCellReuseIdentifier:commodityTVCellID];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([FSClassificationCVCell class]) bundle:nil] forCellWithReuseIdentifier:classificationCVCellID];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // FSClassificationModel *model = self.commodityArray[section];
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FSCommodityTVCell *cell = [tableView dequeueReusableCellWithIdentifier:commodityTVCellID forIndexPath:indexPath];
    return cell;
    
}
#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCREEN_WIDTH / (375 / 110);
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.collectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return(int)(SCREEN_WIDTH / 4 + 0.5) + 10;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FSClassificationCVCell *cell = (FSClassificationCVCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.imageView.backgroundColor = [UIColor orangeColor];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    FSClassificationCVCell *cell = (FSClassificationCVCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.imageView.backgroundColor = [UIColor whiteColor];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - UICollectionViewDelegateFlowLayout

// cell size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat cellWH = SCREEN_WIDTH / 4;
    
    ;
    
    
    return (CGSize){(int)(cellWH + 0.5), (int)(cellWH + 0.5)};
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.commodityArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FSClassificationCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:classificationCVCellID forIndexPath:indexPath];
    
    if (indexPath.section == 2) {
        [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionLeft];
    }
    return cell;
    
}

#pragma mark - Custom
#pragma mark -
#pragma mark - LazyLoad


- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.y = 0;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor colorViewBG];

    }
    return _collectionView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)commodityArray {
    if (!_commodityArray) {
        _commodityArray = [NSMutableArray array];
    }
    return _commodityArray;
}






@end
