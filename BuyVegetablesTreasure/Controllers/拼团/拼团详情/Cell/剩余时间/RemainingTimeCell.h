//
//  RemainingTimeCell.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/4/6.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupDetailModel.h"

@interface RemainingTimeCell : UITableViewCell

@property (nonatomic, strong) GroupDetailModel *model;
@property (nonatomic, copy) UILabel *remainingTimeLabel;
@property (nonatomic, copy) void(^refreshBlock)();

- (void)setTime:(NSString *)time;

@end
