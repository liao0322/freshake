//
//  GroupStatusCell.h
//  BuyVegetablesTreasure
//
//  Created by sc on 16/4/5.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupDetailModel.h"

@interface GroupStatusCell : UITableViewCell

- (void)setModel:(GroupDetailModel *)model;

@property (nonatomic, copy) void(^refreshBlock)();

@end
