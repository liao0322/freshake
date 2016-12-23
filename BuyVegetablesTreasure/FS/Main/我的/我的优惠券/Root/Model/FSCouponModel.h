//
//  FSCouponModel.h
//  BuyVegetablesTreasure
//
//  Created by 江玉元 on 2016/12/21.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSParentModel.h"

@interface FSCouponModel : FSParentModel

@property (nonatomic, copy) NSString *AddTime;      // 添加时间
@property (nonatomic, copy) NSString *ExpileDate;   // 有效期
@property (nonatomic, copy) NSString *Id;           // 优惠券ID
@property (nonatomic, copy) NSString *IsExpile;     // 是否有效   0-有效，1-无效
@property (nonatomic, copy) NSString *IsReceive;    // 是否领取   0-领取，1-未领取
@property (nonatomic, copy) NSString *Mobile;       // 电话
@property (nonatomic, copy) NSString *Price;        // 优惠价格
@property (nonatomic, copy) NSString *SN;           // 密码
@property (nonatomic, copy) NSString *TickId;
@property (nonatomic, copy) NSString *TickName;     // 优惠券名
@property (nonatomic, copy) NSString *UserId;       // 用户ID
@property (nonatomic, copy) NSString *consumeMoney; // 满多少金额使用
@property (nonatomic, copy) NSString *hasLingQu;
@property (nonatomic, copy) NSString *type;         // 优惠券类型
@property (nonatomic, copy) NSString *typeObjectId; // 类型ID
@property (nonatomic, copy) NSString *usedContent;  // 使用规则
@property (nonatomic, copy) NSString *typeId;       // 优惠券ID
@property (nonatomic, copy) NSString *Remark;

@property (nonatomic, copy) NSString *XZContent;
@property (nonatomic, copy) NSString *beginDate;

@property (nonatomic, assign) BOOL isSelect; // 是否选中

@end
