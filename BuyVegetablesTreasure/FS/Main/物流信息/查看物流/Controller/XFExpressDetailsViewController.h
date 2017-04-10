//
//  XFExpressDetailsViewController.h
//  InnerForCourier
//
//  Created by DamonLiao on 2017/2/4.
//  Copyright © 2017年 DamonLiao. All rights reserved.
//

#import "XFViewController.h"
@class Order;
@class MyOrderDetailsModel;


@interface XFExpressDetailsViewController : XFViewController

- (instancetype)initWithOrder:(Order *)order;
- (instancetype)initWithMyOrderDetailsModel:(MyOrderDetailsModel *)model;

@end
