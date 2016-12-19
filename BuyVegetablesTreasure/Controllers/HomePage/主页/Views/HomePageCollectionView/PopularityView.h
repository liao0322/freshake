//
//  PopularityView.h
//  BuyVegetablesTreasure
//
//  Created by sc on 15/10/14.
//  Copyright (c) 2015年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopularityView : UIView

@property (nonatomic) UICollectionView *popularityCollectionView;
@property (nonatomic, copy) UIRefreshControl *freshControl;
@property (nonatomic, copy) UICollectionViewFlowLayout *flowLayout;

@end
