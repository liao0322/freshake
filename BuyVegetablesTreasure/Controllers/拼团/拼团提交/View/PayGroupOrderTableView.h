//
//  PayGroupOrderTableView.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/4/7.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupModel.h"

@interface PayGroupOrderTableView : UIView

@property (nonatomic, copy) NSArray *dataArray;
@property (nonatomic, copy) NSString *fendianId;        // 取货ID
@property (nonatomic, copy) NSString *accept_address;   // 地址
@property (nonatomic, copy) NSString *express_id;       // 配送方式
@property (nonatomic, copy) NSString *express_fee;      // 配送价格
/// 可用积分
@property (nonatomic, assign) CGFloat availableIntegral;
/// 积分按钮
@property (nonatomic, strong) UISwitch *integralSwitch;

@property (nonatomic, assign) BOOL isDelivery;
@property (nonatomic, assign) BOOL isDistribution;

@property (nonatomic, copy) NSString *isSend;
@property (nonatomic, copy) NSString *fullPrice;
@property (nonatomic, strong) GroupModel *gourpModel;

@property (nonatomic, copy) void (^goAddress)(UIViewController *viewController);
@property (nonatomic, copy) void (^reloadPrice)();
@property (nonatomic, copy) void (^currentCoor)(CLLocationCoordinate2D coor);

- (void)refreshTableView;

@end
