 //
//  EditSiteViewController.h
//  BuyVegetablesTreasure
//
//  Created by sc on 15/10/16.
//  Copyright (c) 2015年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditSiteViewController : UITableViewController

@property (nonatomic, assign) BOOL isShowContent;

@property (nonatomic, assign) BOOL isEidt;

@property (nonatomic, copy) void(^addressBlock)(NSString *addressString);

@end
