//
//  EvaluationViewCell.h
//  BuyVegetablesTreasure
//
//  Created by Kai on 16/1/6.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EvaluationModel.h"

@interface EvaluationViewCell : UITableViewCell

@property (nonatomic, strong) EvaluationModel *model;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) void(^imgClickBlock)(EvaluationModel *model, NSInteger index);

@end
