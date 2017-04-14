//
//  FSSearchResultTVCell.h
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/21.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchModel.h"

@class FSSearchResultTVCell;

@protocol FSSearchResultTVCellDelegate <NSObject>

- (void)searchResultTVCell:(FSSearchResultTVCell *)cell plusButtonTouchUpInside:(UIButton *)sender;

- (void)searchResultTVCell:(FSSearchResultTVCell *)cell minusButtonTouchUpInside:(UIButton *)sender;

@end

@interface FSSearchResultTVCell : UITableViewCell
@property (nonatomic) SearchModel *model;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UIButton *minusButton;
@property (weak, nonatomic) IBOutlet UIButton *plusButton;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (weak, nonatomic) IBOutlet UIImageView *addGoodsImage;


@property (weak, nonatomic) id<FSSearchResultTVCellDelegate> delegate;

@end
