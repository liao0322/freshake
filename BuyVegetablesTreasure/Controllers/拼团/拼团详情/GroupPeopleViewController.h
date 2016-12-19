//
//  GroupPeopleViewController.h
//  BuyVegetablesTreasure
//
//  Created by XiaoBeiMAC on 15/11/27.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParentViewController.h"
#import "MyGroupModel.h"

@interface GroupPeopleViewController : ParentViewController

@property (nonatomic, assign) MyGroupModel *model;
@property (nonatomic, assign) BOOL isPay;

@end
