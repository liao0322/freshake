//
//  UIFactory.h
//  BaoqianliShop
//
//  Created by ky on 15/8/28.
//  Copyright (c) 2015年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface UIFactory : NSObject


/**
 创建上图下文字BBI
 */
+ (UIBarButtonItem *)createPKBBIWithTitle:(NSString *)title image:(UIImage *)image target:(id)tartget action:(SEL)selector;

/**
 创建左图右文字的BBI
 */
+ (UIBarButtonItem *)createPBBIWithRightTitle:(NSString *)title leftImage:(UIImage *)image target:(id)tartget action:(SEL)selector;

/**
 创建只有标题的BBI
 */
+ (UIBarButtonItem *)createTitleBBIWithTitle:(NSString *)title target:(id)target action:(SEL)selector;

/**
 创建返回的BBI
 */
+ (UIBarButtonItem *)createBackBBIWithTarget:(id)target action:(SEL)selector;

/**
 创建只有图片的BBI
 */
+ (UIBarButtonItem *)createImageBBI:(UIImage *)image WithTarget:(id)target action:(SEL)selector;

/**
 创建调整位置的BBI
 */
+ (UIBarButtonItem *)createSpaceBBIWithWidth:(CGFloat)width;


@end
