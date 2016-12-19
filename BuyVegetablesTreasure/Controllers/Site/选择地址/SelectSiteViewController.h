//
//  SelectSiteViewController.h
//  BuyVegetablesTreasure
//
//  Created by sc on 15/10/16.
//  Copyright (c) 2015年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Address.h"
#import "Map.h"

@interface SelectSiteViewController : UITableViewController

@property (nonatomic, copy) void(^siteBlock)(Address *address);

@property (nonatomic, copy) void(^merchantsBlock)(Map *merchantsArray);

@property (nonatomic, copy) NSString *goodsCountString;

@end
