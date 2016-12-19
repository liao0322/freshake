//
//  NSDate+category.h
//  eatToLiveAround
//
//  Created by sc on 15-5-19.
//  Copyright (c) 2015年 ZG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (category)

/**
 *  是否是同一天
 *
 *  @param anotherDate 其他的Date
 *
 *  @return yes no
 */
- (BOOL) isSameDay:(NSDate*)anotherDate;

/**
 *  多少秒之前
 *
 *  @return NSInteger
 */
- (NSInteger) secondsAgo;

/**
 *  多少分钟之前
 *
 *  @return NSInteger
 */
- (NSInteger) minutesAgo;

/**
 *  多少小时之前
 *
 *  @return NSInteger
 */
- (NSInteger) hoursAgo;

/**
 *  多少月之前
 *
 *  @return NSInteger
 */
- (NSInteger) monthsAgo;

/**
 *  多少年之前
 *
 *  @return NSInteger
 */
- (NSInteger) yearsAgo;

/**
 *  exp: @"%ld个月前"  @"%ld天前" @"%ld小时前" @"%ld分钟前" @"%ld秒前"
 *
 *  @return 字符串
 */
- (NSString *) stringTimesAgo;

@end
