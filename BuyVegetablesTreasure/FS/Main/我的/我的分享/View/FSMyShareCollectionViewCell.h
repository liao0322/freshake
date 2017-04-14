//
//  FSMyShareCollectionViewCell.h
//  BuyVegetablesTreasure
//
//  Created by 江玉元 on 2017/4/11.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FSMyShareModel;

@interface FSMyShareCollectionViewCell : UICollectionViewCell

@property (nonatomic) FSMyShareModel *model;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;


@end
