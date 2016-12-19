//
//  GoodsAdvertisingCell.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/12/8.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdvertisingModel.h"

@interface GoodsAdvertisingCell : UITableViewCell

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) void(^imgClick)(AdvertisingModel *model);

@end
