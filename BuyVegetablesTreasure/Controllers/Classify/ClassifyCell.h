//
//  ClassifyCell.h
//  BuyVegetablesTreasure
//
//  Created by sc on 15/10/14.
//  Copyright (c) 2015年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassifyCell : UITableViewCell

// 图片
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

// 名字
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

// 人数
@property (weak, nonatomic) IBOutlet UILabel *personLabel;

// 地址
@property (weak, nonatomic) IBOutlet UILabel *siteLabel;

// 距离
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@end
