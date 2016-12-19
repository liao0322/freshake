//
//  MyOrderInfoCell.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/5/11.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"

@interface MyOrderInfoCell : UITableViewCell

@property (nonatomic, copy) void(^btnClickBlock)(NSInteger index);

- (void)setModel:(Order *)model;

@end
