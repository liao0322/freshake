//
//  GropCell.h
//  BuyVegetablesTreasure
//
//  Created by sc on 16/4/5.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupModel.h"

@interface GropCell : UITableViewCell

@property (nonatomic, strong) void(^goGroup)();

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *peopleLabel;

- (void)setGroupModel:(GroupModel *)model;

@end
