//
//  CollectTableViewCell.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/5/4.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCollectModel.h"
#import "CookingProgramListModel.h"

@interface CollectTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *goodsImageView;
@property (nonatomic, strong) UILabel *goodsNameLabel;
@property (nonatomic, strong) UILabel *goodsPriceLabel;
@property (nonatomic, strong) UIButton *goPlayBtn;

@property (nonatomic, strong) UIView *deleteView;
@property (nonatomic, strong) UIImageView *deleteImg;

@property (nonatomic, copy) void(^goPayViewController)();

- (void)setModel:(MyCollectModel *)model;
//- (void)setVedioModel:(CookingProgramListModel *)model;

@end
