//
//  FSNewCommodityTVCell.h
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/28.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FSNewCommodityTVCell;
@class NewPruduct;

@protocol FSNewCommodityTVCellDelegate <NSObject>

- (void)newCommodityTVCell:(FSNewCommodityTVCell *)cell plusButtonTouchUpInside:(UIButton *)sender;
- (void)newCommodityTVCell:(FSNewCommodityTVCell *)cell minusButtonTouchUpInside:(UIButton *)sender;
@end

@interface FSNewCommodityTVCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *minusButton;
@property (weak, nonatomic) IBOutlet UIButton *plusButton;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIImageView *addGoodsImage;

@property (weak, nonatomic) id<FSNewCommodityTVCellDelegate> delegate;

@property (nonatomic) NewPruduct *model;

@end
