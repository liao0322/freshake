//
//  FSSelectDeliverySiteCell.h
//  BuyVegetablesTreasure
//
//  Created by 江玉元 on 2016/12/24.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SiteModel.h"


@interface FSSelectDeliverySiteCell : UITableViewCell

@property (nonatomic, strong) SiteModel *model;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UILabel *siteLabel;

@property (nonatomic, strong) UIButton *defaultBtn;
@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, strong) UIButton *deleteBtn;

@property (nonatomic, strong) void(^editBtnClick)();

@property (nonatomic, strong) void(^defaultBtnClick)();

@property (nonatomic, strong) void(^deleteBtnClick)();


@end
