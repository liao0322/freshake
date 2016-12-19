//
//  SelectDeliverySiteCell.h
//  BuyVegetablesTreasure
//
//  Created by sc on 16/3/30.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SiteModel.h"

@interface SelectDeliverySiteCell : UITableViewCell

@property (nonatomic, strong) SiteModel *model;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UILabel *siteLabel;
@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, strong) UILabel *colorLabel;
@property (nonatomic, strong) UILabel *editLine;
@property (nonatomic, strong) void(^editBtnClick)();

//- (void)setModel:(SiteModel *)model;

@end
