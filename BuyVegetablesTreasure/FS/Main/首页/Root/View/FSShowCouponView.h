//
//  FSShowCouponView.h
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2017/4/5.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^GetCouponBlock)();

@interface FSShowCouponView : UIView

@property (strong, nonatomic) GetCouponBlock getCouponBlock;
@property (copy, nonatomic) NSArray *couponArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
