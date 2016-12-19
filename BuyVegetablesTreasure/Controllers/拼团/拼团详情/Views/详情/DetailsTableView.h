//
//  DetailsTableView.h
//  BuyVegetablesTreasure
//
//  Created by sc on 16/4/5.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyGroupModel.h"
#import "GroupDetailModel.h"

@interface DetailsTableView : UIView

@property (nonatomic, assign) MyGroupModel *myGroupModel;
@property (nonatomic, copy) NSArray *dataSource;
@property (nonatomic, copy) void(^goController)(UIViewController *viewController);
@property (nonatomic, copy) void(^refreshDataSource)();

- (void)refreshTableView;


@end
