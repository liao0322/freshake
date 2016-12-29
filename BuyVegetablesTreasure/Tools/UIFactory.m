//
//  UIFactory.m
//  BaoqianliShop
//
//  Created by ky on 15/8/28.
//  Copyright (c) 2015年 ky. All rights reserved.
//

#import "UIFactory.h"

@implementation UIFactory



+ (UIBarButtonItem *)createPKBBIWithTitle:(NSString *)title image:(UIImage *)image target:(id)tartget action:(SEL)selector
{
    // 设置一个容器来装图片和标题
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
    
    // 设置图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:contentView.bounds];
    imageView.image = image;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [contentView addSubview:imageView];
    
    // 设置标题
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, contentView.bounds.size.width, 14)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = title;
    label.font = [UIFont systemFontOfSize:10];
    [contentView addSubview:label];
    
    // 设置点击事件
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:tartget action:selector];
    [contentView addGestureRecognizer:tapGesture];
    
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithCustomView:contentView];
    
    return bbi;
}
+ (UIBarButtonItem *)createPBBIWithRightTitle:(NSString *)title leftImage:(UIImage *)image target:(id)tartget action:(SEL)selector
{
    // 设置一个容器来装图片和标题
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 55, 40)];
    
    // 设置图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 20, 20)];
    imageView.image = image;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [contentView addSubview:imageView];
    
    // 设置标题
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(23, 0, 30, 40)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = title;
    label.font = [UIFont systemFontOfSize:15];
    [contentView addSubview:label];
    
    // 设置点击事件
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:tartget action:selector];
    [contentView addGestureRecognizer:tapGesture];
    
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithCustomView:contentView];
    
    return bbi;

}
+ (UIBarButtonItem *)createTitleBBIWithTitle:(NSString *)title target:(id)target action:(SEL)selector
{
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:selector];
    bbi.tintColor = Color;
    
    return bbi;
}
+ (UIBarButtonItem *)createBackBBIWithTarget:(id)target action:(SEL)selector
{
    // 创建带背景图片的按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tintColor = [UIColor colorDomina];
    [btn setImage:[[UIImage imageNamed:@"返回箭头"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0, 40, 40)];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    // 用btn来创建自定义的BBI
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    return bbi  ;
}
//+ (UIBarButtonItem *)createBackBBIWithTarget:(id)target action:(SEL)selector
//{
//    // 设置一个容器来装图片和标题
//    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 23, 23)];
//    // 创建带背景图片的按钮
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
//    [btn setImage:IMAGE(@"返回箭头") forState:UIControlStateNormal];
//    btn.imageView.contentMode = UIViewContentModeCenter;
//    [btn setFrame:contentView.bounds];
//    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
//    [contentView addSubview:btn];
//    
//    // 用btn来创建自定义的BBI
//    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithCustomView:contentView];
//    
//    return bbi  ;
//}
+ (UIBarButtonItem *)createImageBBI:(UIImage *)image WithTarget:(id)target action:(SEL)selector
{
    // 创建带背景图片的按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, 25, 25)];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:image forState:UIControlStateNormal];
    btn.tintColor = [UIColor colorDomina];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(3, 3,3, 3)];
    // 用btn来创建自定义的BBI
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    return bbi  ;
}
+ (UIBarButtonItem *)createSpaceBBIWithWidth:(CGFloat)width
{
    UIBarButtonItem *spaceBbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceBbi.width = width;
    
    return spaceBbi;
}
@end
