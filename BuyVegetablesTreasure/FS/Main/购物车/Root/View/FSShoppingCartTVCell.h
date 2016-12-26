//
//  FSShoppingCartTVCell.h
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/20.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShopCart;
@class FSShoppingCartTVCell;

@protocol FSShoppingCartTVCellDelegate <NSObject>

- (void)shoppingCartTVCell:(FSShoppingCartTVCell *)cell plusButtonTouchUpInside:(UIButton *)sender;

- (void)shoppingCartTVCell:(FSShoppingCartTVCell *)cell minusButtonTouchUpInside:(UIButton *)sender;

- (void)shoppingCartTVCell:(FSShoppingCartTVCell *)cell selectButtonTouchUpInside:(UIButton *)sender;

@end

@interface FSShoppingCartTVCell : UITableViewCell

@property (nonatomic) ShopCart *model;

@property (weak, nonatomic) id<FSShoppingCartTVCellDelegate> delegate;


@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *minusButton;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIButton *plusButton;
@end
