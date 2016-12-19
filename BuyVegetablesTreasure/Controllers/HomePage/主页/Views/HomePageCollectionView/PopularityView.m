//
//  PopularityView.m
//  BuyVegetablesTreasure
//
//  Created by sc on 15/10/14.
//  Copyright (c) 2015年 c521xiong. All rights reserved.
//

#import "PopularityView.h"

@implementation PopularityView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self createPopularityCollectionView];
        
    }
    return self;
}

#pragma mark - 控件初始化

- (void)createPopularityCollectionView{
    
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];

    _flowLayout.itemSize = CGSizeMake(ScreenWidth / 2 - 15, ScreenWidth / 2 - 15 + 80);
    
    _flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    // Cell行之间的最小间距
    _flowLayout.minimumInteritemSpacing = 10;
    
    // Cell列之间的最小间距
    _flowLayout.minimumLineSpacing = 10;
    
    _popularityCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) collectionViewLayout:_flowLayout];

    _popularityCollectionView.backgroundColor = [UIColor colorWithHexString:@"0xF6F6F6"];
    
    [self addSubview:_popularityCollectionView];
}

@end
