//
//  UIImage+Create.h
//  XFiOSKitDemo
//
//  Created by DamonLiao on 02/12/2016.
//  Copyright © 2016 DamonLiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Create)

/// 根据颜色生成纯色图片
+ (UIImage *)imageWithColor:(UIColor *)color;

/// 获取一张按图片自身颜色渲染的图片
+ (UIImage *)imageOriginalWithName:(NSString *)name;
+ (UIImage *)imageOriginalWithImage:(UIImage *)image;

- (UIImage*)imageWithCornerRadius:(CGFloat)radius;

- (UIImage *)circleImage;

- (UIImage *)antiAlias;
@end
