//
//  FSAdModel.h
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2017/3/15.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import "XFModel.h"

@interface FSAdModel : XFModel

/**
 * id
 */
@property (copy, nonatomic) NSString *id;

/**
 * 门店id
 */
@property (copy, nonatomic) NSString *shopId;

/**
 * 广告类型id
 */
@property (copy, nonatomic) NSString *typeId;

/**
 * 图片url
 */
@property (copy, nonatomic) NSString *imgUrl;

/**
 * 展示方向
 */
@property (copy, nonatomic) NSString *source;

/**
 * 广告事件类型id
 */
@property (copy, nonatomic) NSString *eventTypeId;

/**
 * 广告事件id
 */
@property (copy, nonatomic) NSString *eventId;

/**
 * 广告事件url
 */
@property (copy, nonatomic) NSString *eventUrl;

/**
 * 添加时间
 */
@property (copy, nonatomic) NSString *addTime;

/**
 * 添加人id
 */
@property (copy, nonatomic) NSString *addUserId;

/**
 * 排序
 */
@property (copy, nonatomic) NSString *sortorder;

/**
 * 是否启用
 */
@property (copy, nonatomic) NSString *usable;

/**
 * 展示开始时间
 */
@property (copy, nonatomic) NSString *startTime;

/**
 * 展示结束时间
 */
@property (copy, nonatomic) NSString *endTime;

@end
