//
//  FSShowImageCVCell.h
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2017/4/17.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>


@class FSMyShareModel;

@interface FSShowImageCVCell : UICollectionViewCell

@property (nonatomic) FSMyShareModel *model;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (nonatomic) void(^ToShareBlock)();

@end
