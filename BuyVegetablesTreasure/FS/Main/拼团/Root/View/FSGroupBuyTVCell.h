//
//  FSGroupBuyTVCell.h
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/27.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFStrikethroughLabel.h"

#import "GroupModel.h"

@interface FSGroupBuyTVCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupPriceTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupPriceLabel;
@property (weak, nonatomic) IBOutlet XFStrikethroughLabel *salePriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *groupBuyButton;

@property (nonatomic) GroupModel *model;
@end
