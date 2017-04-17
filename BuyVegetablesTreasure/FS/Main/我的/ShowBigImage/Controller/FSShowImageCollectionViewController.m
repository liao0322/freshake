//
//  FSShowImageCollectionViewController.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2017/4/17.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import "FSShowImageCollectionViewController.h"
#import "FSShowImageCVCell.h"

@interface FSShowImageCollectionViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@end

@implementation FSShowImageCollectionViewController

static NSString * const FSShowImageCVCellID = @"FSShowImageCVCellID";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)setupViews {
    [super setupViews];
    
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.pagingEnabled = YES;
    
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.flowLayout.itemSize = [UIScreen mainScreen].bounds.size;
    self.flowLayout.minimumLineSpacing = 0;
    self.flowLayout.minimumInteritemSpacing = 0;
}

- (void)registerViews {
    [super registerViews];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([FSShowImageCVCell class]) bundle:nil] forCellWithReuseIdentifier:FSShowImageCVCellID];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FSShowImageCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FSShowImageCVCellID forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
