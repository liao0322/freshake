//
//  UIImage+category.h
//  eatToLiveAround
//
//  Created by sc on 15-5-19.
//  Copyright (c) 2015年 ZG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (category)

/**
 *  根据宽度进行缩放
 *
 *  @param defineWidth 宽度
 *
 */
- (UIImage *) imageCompressForTargetWidth:(CGFloat)defineWidth;

/**
 *  剪切图片
 *
 *  @param rect 要剪切的范围
 */
- (UIImage *) clipImageInRect:(CGRect)rect;

/**
 *  根据颜色来生成一张纯色的图片
 *
 *  @param aColor 颜色
 *
 *  @return 图片
 */
+ (UIImage *) imageWithColor:(UIColor *)aColor;

/**
 *  对图片尺寸进行压缩
 *
 *  @param targetSize 压缩后的尺寸
 *
 *  @return UIImage
 */
- (UIImage*) scaledToSize:(CGSize)targetSize;

/**
 *  是否对对图片尺寸进行高质量的压缩
 *
 *  @param targetSize  压缩后的尺寸
 *  @param highQuality 压缩后的尺寸 * 2
 *
 *  @return UIImage
 */
- (UIImage*) scaledToSize:(CGSize)targetSize highQuality:(BOOL)highQuality;

/**
 *  根据最大的尺寸是否缩放
 *
 *  @param size CGSize
 *
 *  @return UIImage
 */
- (UIImage*) scaledToMaxSize:(CGSize )size;

- (UIImage *) reSize:(CGSize)reSize;

@end
