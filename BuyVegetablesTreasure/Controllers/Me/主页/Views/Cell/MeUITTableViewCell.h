//
//  MeUITTableViewCell.h
//  BuyVegetablesTreasure
//
//  Created by ky on 15/10/21.
//  Copyright (c) 2015年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NumView.h"
#import "MeModel.h"

@interface MeUITTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backImage;
@property (weak, nonatomic) IBOutlet UIImageView *selectImage;
@property (weak, nonatomic) IBOutlet UILabel *point;


@property (nonatomic, copy) UILabel *name;
@property (nonatomic, copy) UILabel *mobile;
@property (nonatomic, copy) UIImageView *icon;
@property (nonatomic, copy) UIButton *isVip;
@property (nonatomic, copy) NumView  *numView;
@property (nonatomic, copy) void(^pushLogin)(NSArray *arr);

@property (nonatomic, copy) void(^goViewController)(UIViewController *viewController);

-(void)setDataSource;

@end
