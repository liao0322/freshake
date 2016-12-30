//
//  MyOrderViewController.h
//  BuyVegetablesTreasure
//
//  Created by ky on 15/10/21.
//  Copyright (c) 2015年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOrderView.h"
#import "FSBaseViewController.h"

@interface MyOrderViewController : FSBaseViewController
@property (nonatomic, assign) NSInteger Index;
@property (nonatomic, strong) MyOrderView *myOrderView;

@end
