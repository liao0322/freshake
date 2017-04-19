//
//  FSMyShareViewController.m
//  BuyVegetablesTreasure
//
//  Created by 江玉元 on 2017/4/11.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import "FSMyShareViewController.h"
#import "FSMyShareCollectionViewCell.h"
#import "FSMyShareModel.h"
#import <MJExtension.h>
#import <UShareUI/UShareUI.h>
#import "FSShowImageCollectionViewController.h"

@interface FSMyShareViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (copy, nonatomic) NSString *uidString;

@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic) NSMutableArray *dataArray;

@property (nonatomic) UIImage *iconImage;

@end

@implementation FSMyShareViewController

static NSString * const MyShareCollectionCellID = @"MyShareCollectionCellID";

static NSInteger const cols = 3;
static CGFloat const margin = 2.5;
#define itemW ((SCREEN_WIDTH - 10) - (cols - 1) * margin) / cols
#define itemH  SCREEN_WIDTH == 320 ? 181 : 213


- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestDataFromNet];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)initialize {
    [super initialize];
    self.title = @"我的分享";
    self.view.backgroundColor = [UIColor colorViewBG];
}

- (void)setupViews {
    [super setupViews];
    [self.view addSubview:self.collectionView];
}

- (void)registerViews {
    [super registerViews];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([FSMyShareCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:MyShareCollectionCellID];
}

- (void)requestDataFromNet {
    [XFWaterWaveView showLoading];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.uidString = [userDefaults objectForKey:@"UID"];
    
    NSString *urlString = [NSString stringWithFormat:GetProShareImg,self.uidString];

    [XFNetworking GET:urlString parameters:nil success:^(id responseObject, NSInteger statusCode) {
        NSArray *dicArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (!dicArray.count) {
            [XFWaterWaveView dismissLoading];
            self.collectionView.backgroundView = self.noDataView;
            return;
        }
        
        NSMutableArray *dataArr = [FSMyShareModel mj_objectArrayWithKeyValuesArray:dicArray];
        if (!dataArr.count) {
            return;
        }
        self.collectionView.backgroundView = nil;
        self.dataArray = dataArr;
        [self.collectionView reloadData];
        [XFWaterWaveView dismissLoading];
    } failure:^(NSError *error, NSInteger statusCode) {
        
        [XFWaterWaveView dismissLoading];
        [self showInfoWidthError:error];

    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FSMyShareModel *model = self.dataArray[indexPath.row];
    FSMyShareCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MyShareCollectionCellID forIndexPath:indexPath];
    cell.model = model;
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FSShowImageCollectionViewController *showImageVC = [FSShowImageCollectionViewController new];
    showImageVC.imageDataArray = self.dataArray;
    showImageVC.ImageRow = indexPath.row;
    showImageVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:showImageVC animated:NO completion:^{
        showImageVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
    }];
}



#pragma mark - LazyLoad

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH - 10, SCREEN_HEIGHT - 5) collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor colorViewBG];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = CGSizeMake(itemW, itemH);
        _flowLayout.minimumInteritemSpacing = margin;
        _flowLayout.minimumLineSpacing = margin;
    }
    return _flowLayout;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


@end
