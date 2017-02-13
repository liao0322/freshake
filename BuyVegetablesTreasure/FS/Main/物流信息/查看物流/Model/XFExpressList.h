//
//  XFExpressList.h
//  InnerForCourier
//
//  Created by DamonLiao on 2017/2/11.
//  Copyright © 2017年 DamonLiao. All rights reserved.
//

#import "XFModel.h"

@interface XFExpressList : XFModel

/**
 * 订单id
 */
@property (copy, nonatomic) NSString *orderId;

/**
 * 操作状态
 */
@property (copy, nonatomic) NSString *orderStatus;

/**
 * 操作人
 */
@property (copy, nonatomic) NSString *operUserId;

/**
 * 操作时间
 */
@property (copy, nonatomic) NSString *operTime;

/**
 * 备注
 */
@property (copy, nonatomic) NSString *remark;

/**
 * 订单no
 */
@property (copy, nonatomic) NSString *orderNo;

@property (assign, nonatomic, getter=isFirst) BOOL first;

@end
