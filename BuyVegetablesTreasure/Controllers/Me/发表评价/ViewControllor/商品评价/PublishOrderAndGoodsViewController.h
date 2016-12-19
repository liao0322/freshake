//
//  PublishOrderAndGoodsViewController.h
//  BuyVegetablesTreasure
//
//  Created by XiaoBeiMAC on 15/11/30.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"

@interface PublishOrderAndGoodsViewController : UIViewController

@property(nonatomic,strong)Order *orderModel;
@property(nonatomic,assign)NSInteger indexRow;

@end
