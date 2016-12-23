//
//  FSMyCollectTableViewCell.h
//  BuyVegetablesTreasure
//
//  Created by 江玉元 on 2016/12/23.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSMyCollectModel.h"

@interface FSMyCollectTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *goodsImageView;

@property (nonatomic, strong) UILabel *goodsNameLabel;

@property (nonatomic, strong) UILabel *goodsPriceLabel;

@property (nonatomic, strong) UIButton *goBuyBtn;

@property (nonatomic, strong) UIView *deleteView;

@property (nonatomic, strong) UIImageView *deleteImg;

@property (nonatomic, copy) void(^goPayViewController)();

- (void)setModel:(FSMyCollectModel *)model;


@end
