//
//  OrderStateView.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/5/11.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOrderModel.h"

@interface OrderStateView : UIView

@property (nonatomic, copy) NSString *stateUrl;
@property (nonatomic, copy) void(^requestOrder)(NSString *urlString);

- (void)setCountLabelWithModel:(MyOrderModel *)model;

@end
