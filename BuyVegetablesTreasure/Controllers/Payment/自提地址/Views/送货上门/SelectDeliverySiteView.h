//
//  SelectDeliverySiteView.h
//  BuyVegetablesTreasure
//
//  Created by sc on 16/3/30.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectDeliverySiteCell.h"

@interface SelectDeliverySiteView : UIView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, copy) NSArray *siteArray;

@property (nonatomic, copy) void(^userAddress)(SiteModel *mapArray);
@property (nonatomic, copy) void(^addBtnClick)(BOOL isDel, NSInteger index);

- (void)refreshSite;

@end
