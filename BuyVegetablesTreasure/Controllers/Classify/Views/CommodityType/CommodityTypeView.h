//
//  CommodityTypeView.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/4/20.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftClassModel.h"

@interface CommodityTypeView : UIView

@property (nonatomic, copy) void(^moveTableView)(NSInteger index);

- (void)moveType:(NSInteger)index;
- (void)createCommodityType:(NSArray *)dataScoure;

@end
