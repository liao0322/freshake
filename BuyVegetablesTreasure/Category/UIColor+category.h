//
//  UIColor+category.h
//  eatToLiveAround
//
//  Created by sc on 15-5-19.
//  Copyright (c) 2015年 ZG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (category)

/**
 *  根据16进制返回颜色
 *
 *  @param hex 16进制
 *
 *  @return UIColor
 */
+ (UIColor *) colorWithRGBHex:(UInt32)hex;

/**
 *  根据16进制字符串返回颜色
 *
 *  @param stringToConvert 16进制字符串
 *
 *  @return UIColor
 */
+ (UIColor *) colorWithHexString:(NSString *)stringToConvert;

/**
 *  根据16进制字符串返回待透明度的颜色
 *
 *  @param stringToConvert 16进制字符串
 *  @param alpha           透明度
 *
 *  @return UIColor
 */
+ (UIColor *) colorWithHexString:(NSString *)stringToConvert andAlpha:(CGFloat)alpha;

@end
