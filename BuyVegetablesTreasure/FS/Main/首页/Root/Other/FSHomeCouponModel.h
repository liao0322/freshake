//
//  FSHomeCouponModel.h
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2017/4/7.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import "FSBaseModel.h"

@interface FSHomeCouponModel : FSBaseModel

/// 面额
@property (copy, nonatomic) NSString *Price;
/// 使用规则
@property (copy, nonatomic) NSString *Remark;
/// 优惠券id
@property (copy, nonatomic) NSString *TickId;
/// 优惠劵名称
@property (copy, nonatomic) NSString *TickName;
/// 活动开始时间
@property (copy, nonatomic) NSString *beginDate;
/// 满多少金额
@property (copy, nonatomic) NSString *consumeMoney;
///  活动结束时间
@property (copy, nonatomic) NSString *endDate;

@end
