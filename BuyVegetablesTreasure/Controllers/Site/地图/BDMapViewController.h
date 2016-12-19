//
//  BDMapViewController.h
//  BuyVegetablesTreasure
//
//  Created by sc on 15/11/5.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Map.h"

@interface BDMapViewController : UIViewController

@property (nonatomic, assign) BOOL isAddSite;
@property (nonatomic, assign) BOOL isCurrentSite;
@property (nonatomic, strong) NSString *currentCity;
@property (nonatomic, copy) NSString *cityString;
@property (nonatomic, copy) void(^storeBlcok)(NSArray *mapArray,NSString *cityString);
@property (nonatomic, copy) void(^userSiteBlock)(AMapPOI *mapArray);

@end
