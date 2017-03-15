//
//  XFPersistenceDelegate.h
//  InnerForCourier
//
//  键值缓存协议定义
//
//  Created by DamonLiao on 2017/2/4.
//  Copyright © 2017年 DamonLiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XFKVCPersistenceDelegate <NSObject>

/**
 *  设置key键对应的值为value
 *
 *  @param value value值
 *  @param key   键值
 */
+ (void)setValue:(id)value forKey:(NSString *)key;

/**
 *  获取key键对应的值，不存在则返回nil
 *
 *  @param key 键值
 *
 *  @return key键对应的值
 */
+ (id)get:(NSString *)key;

/**
 *  判断是否存在key键
 *
 *  @param key 键值
 *
 *  @return 存在结果
 */
+ (BOOL)contain:(NSString *)key;

/**
 *  删除key键
 *
 *  @param key 键值
 */
+ (void)remove:(NSString *)key;

/**
 *  清理所有数据
 */
+ (void)clear;

@end
