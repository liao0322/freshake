//
//  GroupDateilTableViewCell.h
//  BuyVegetablesTreasure
//
//  Created by XiaoBeiMAC on 15/11/26.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupModel.h"

@interface GroupDateilTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *footView;

@property (nonatomic, strong) void(^payGroup)();
@property (nonatomic, strong) void(^payOwn)();

- (void)setGroupModel:(GroupModel *)model;

@end
