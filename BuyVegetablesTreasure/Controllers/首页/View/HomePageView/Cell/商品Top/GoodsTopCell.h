//
//  GoodsTopCell.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/12/8.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdvertisingModel.h"

@interface GoodsTopCell : UITableViewCell

@property (nonatomic, strong) AdvertisingModel *model;
@property (nonatomic, strong) void(^imgClick)(AdvertisingModel *model);

@end
