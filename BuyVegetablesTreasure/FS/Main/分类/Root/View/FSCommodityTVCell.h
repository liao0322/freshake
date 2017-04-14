//
//  FSCommodityTVCell.h
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/16.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FSCommodityModel;
@class FSCommodityTVCell;

@protocol FSCommodityTVCellDelegate <NSObject>

- (void)commodityTVCell:(FSCommodityTVCell *)cell plusButtonTouchUpInside:(UIButton *)sender;
- (void)commodityTVCell:(FSCommodityTVCell *)cell minusButtonTouchUpInside:(UIButton *)sender;

@end

@interface FSCommodityTVCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *vipLabel;

@property (weak, nonatomic) IBOutlet UIButton *plusButton;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (weak, nonatomic) IBOutlet UIButton *minusButton;


@property (weak, nonatomic) IBOutlet UIImageView *addGoodsImage;

@property (nonatomic) FSCommodityModel *model;

@property (weak, nonatomic) id<FSCommodityTVCellDelegate> delegate;

@end
