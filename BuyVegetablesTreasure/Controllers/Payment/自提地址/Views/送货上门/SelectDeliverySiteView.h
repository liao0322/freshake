//
//  SelectDeliverySiteView.h
//  BuyVegetablesTreasure
//
//  Created by sc on 16/3/30.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectDeliverySiteCell.h"
#import "FSSelectDeliverySiteCell.h"

@interface SelectDeliverySiteView : UIView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSArray *siteArray;

@property (nonatomic, copy) void(^userAddress)(SiteModel *mapArray);
@property (nonatomic, copy) void(^addBtnClick)(BOOL isDel, NSInteger index);
@property (nonatomic, copy) void(^deleteAddress)(NSString *idString);
@property (nonatomic, copy) void(^defaultAddress)(BOOL isDel,SiteModel *model);
//@property (nonatomic, copy) void(^defaultBtnClick)(BOOL isDefault, NSInteger index);
- (void)refreshSite;

@end
