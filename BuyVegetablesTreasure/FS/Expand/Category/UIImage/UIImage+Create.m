//
//  UIImage+Create.m
//  XFiOSKitDemo
//
//  Created by DamonLiao on 02/12/2016.
//  Copyright © 2016 DamonLiao. All rights reserved.
//

#import "UIImage+Create.h"

@implementation UIImage (Create)

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageOriginalWithName:(NSString *)name {
    return [UIImage imageOriginalWithImage:[UIImage imageNamed:name]];
}

+ (UIImage *)imageOriginalWithImage:(UIImage *)image {
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}


- (UIImage *)circleImage {
    CGSize imageSize = self.size;
    
    // 开启位图上下文，跟图片尺寸一样大，NO代表透明
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext(); // 获得上下文
    
    // 添加一个圆，设置裁剪区域
    CGRect rect = CGRectMake(0, 0, imageSize.width, imageSize.height);
    CGContextAddEllipseInRect(ctx, rect);
    
    CGContextClip(ctx); // 裁剪
    [self drawInRect:rect]; // 将图片画上去
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [image antiAlias];
}

- (UIImage *)antiAlias
{
    CGFloat border = 1.0f;
    CGRect rect = CGRectMake(border, border, self.size.width-2*border, self.size.height-2*border);
    UIImage *img = nil;
    
    UIGraphicsBeginImageContext(CGSizeMake(rect.size.width,rect.size.height));
    [self drawInRect:CGRectMake(-1, -1, self.size.width, self.size.height)];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContext(self.size);
    [img drawInRect:rect];
    UIImage* antiImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return antiImage;
}

@end
