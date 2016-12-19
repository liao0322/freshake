//
//  HotTableViewCell.h
//  BuyVegetablesTreasure
//
//  Created by ky on 15/11/4.
//  Copyright (c) 2015年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotTableViewCell : UITableViewCell

@property(nonatomic,strong) void (^GoSearch) (NSInteger butTag);

- (void)SetupUIWithArray:(NSArray *)arr;

@end
