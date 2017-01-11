//
//  ChooseAddressViewController.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/11/25.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "ParentViewController.h"

@interface ChooseAddressViewController : ParentViewController

/// 自提状态
@property (nonatomic, assign) BOOL deliveryStatus;
/// 配送状态
@property (nonatomic, assign) BOOL distributionStatus;
/// 地址
@property (nonatomic, strong) void(^addressBlock)(id model, BOOL deliveryStatus);

#pragma mark - 收藏
/// 商家ID
@property (nonatomic, copy) NSString *midStr;
/// 是否收藏
@property (nonatomic, assign) BOOL isCollect;

@property (nonatomic, assign) BOOL isDeleteSite;


@end
