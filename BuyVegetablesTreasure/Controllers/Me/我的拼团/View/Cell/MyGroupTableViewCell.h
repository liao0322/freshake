//
//  MyGroupTableViewCell.h
//  BuyVegetablesTreasure
//
//  Created by ky on 15/11/27.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"
@interface MyGroupTableViewCell : UITableViewCell

@property (nonatomic, strong) UIButton *typeBtn;

//点击详情
@property (nonatomic,copy)void(^pushDetail)(NSInteger index);


-(void)setData:(Order *)model;

@end
