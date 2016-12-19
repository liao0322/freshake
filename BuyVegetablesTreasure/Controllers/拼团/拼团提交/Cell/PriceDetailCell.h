//
//  PriceDetailCell.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/4/7.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupModel.h"

@interface PriceDetailCell : UITableViewCell

@property (nonatomic, strong) UILabel *couponPriceLabel;
@property (nonatomic, strong) void (^isSelect)(BOOL isSelect);

- (void)setCouponPrice:(float)price;
- (void)setDistancePrice:(NSString *)price;
- (void)setGroupModel:(GroupModel *)gourpModel;

@end
