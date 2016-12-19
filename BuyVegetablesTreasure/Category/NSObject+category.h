//
//  NSObject+category.h
//  eatToLiveAround
//
//  Created by sc on 15-5-19.
//  Copyright (c) 2015年 ZG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (category)

/**
 *  获取fileName的完整地址
 *
 *  @param fileName 名字
 *
 *  @return 完整地址
 */

+ (NSString* ) pathInCacheDirectory:(NSString *)fileName;
/**
 *  创建缓存文件夹
 *
 *  @param dirName 文件夹名字
 *
 *  @return 是否创建成功
 */
+ (BOOL) createDirInCache:(NSString *)dirName;

/**
 *  图片缓存到本地
 *
 *  @param image      UIImage Class
 *  @param imageName  imageName
 *  @param folderName 缓存文件夹名称
 *
 *  @return yes no
 */
+ (BOOL) saveImage:(UIImage *)image imageName:(NSString *)imageName inFolder:(NSString *)folderName;

/**
 *  删除图片缓存
 *
 *  @param folderName 缓存文件夹
 *
 *  @return 是否删除成功
 */
+ (BOOL) deleteImageCacheInFolder:(NSString *)folderName;

@end
