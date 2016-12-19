//
//  SubmitOrderViewController.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/10/19.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "ParentViewController.h"

@interface SubmitOrderViewController : ParentViewController

@property (nonatomic, strong) NSArray *goodsArray;
/// 是否立即购买
@property (nonatomic, assign) BOOL buySoon;
#pragma mark - 收藏
/// 是否收藏
@property (nonatomic, assign) BOOL isCollect;
/// 分店ID
@property (nonatomic, strong) NSString *fendianId;
/// 商家ID
@property (nonatomic, strong) NSString *midString;
/// 分店地址
@property (nonatomic, strong) NSString *fendianAddress;

@end
