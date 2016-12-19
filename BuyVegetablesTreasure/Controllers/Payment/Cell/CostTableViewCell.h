//
//  CostTableViewCell.h
//  BuyVegetablesTreasure
//
//  Created by sc on 15/10/15.
//  Copyright (c) 2015年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopCart.h"

#import "GoodsView.h"

@interface CostTableViewCell : UITableViewCell

@property (nonatomic, copy) UILabel *serviceLabel;
@property (nonatomic, copy) UILabel *priceLabel;
@property (nonatomic, copy) UILabel *servicePriceLabel;
@property (nonatomic, copy) UILabel *line;
@property (nonatomic, copy) GoodsView *goodsView;

- (void)setArray:(NSArray *)arr;

@end
