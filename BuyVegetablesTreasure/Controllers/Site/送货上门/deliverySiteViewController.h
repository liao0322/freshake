//
//  deliverySiteViewController.h
//  BuyVegetablesTreasure
//
//  Created by sc on 16/3/29.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SiteModel.h"

@interface deliverySiteViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, assign) SiteModel *siteModel;
@property (nonatomic, assign) BOOL isDeleteSite;

@end
