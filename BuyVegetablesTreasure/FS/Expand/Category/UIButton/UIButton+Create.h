//
//  UIButton+Create.h
//  XFiOSKitDemo
//
//  Created by DamonLiao on 02/12/2016.
//  Copyright © 2016 DamonLiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Create)

+ (UIButton *)systemButtonWithOrigin:(CGPoint)origin
                               title:(NSString *)title;

+ (UIButton *)systemButtonWithOrigin:(CGPoint)origin
                               title:(NSString *)title
                          titleColor:(UIColor *)titleColor;

+ (UIButton *)systemButtonWithOrigin:(CGPoint)origin
                               title:(NSString *)title
                          titleColor:(UIColor *)titleColor
                              target:(id)target
                              action:(SEL)action;

+ (UIButton *)buttonWithOrigin:(CGPoint)origin
                         title:(NSString *)title;

// 通过颜色创建Button

+ (UIButton *)buttonWithFrame:(CGRect)frame
                  normalColor:(UIColor *)normalColor
                        title:(NSString *)title
                 cornerRadius:(CGFloat)cornerRadius;

+ (UIButton *)buttonWithFrame:(CGRect)frame
                  normalColor:(UIColor *)normalColor
                        title:(NSString *)title
                 cornerRadius:(CGFloat)cornerRadius
             highlightedColor:(UIColor *)highlightedColor;

+ (UIButton *)buttonWithFrame:(CGRect)frame
                  normalColor:(UIColor *)normalColor
                        title:(NSString *)title
                 cornerRadius:(CGFloat)cornerRadius
             highlightedColor:(UIColor *)highlightedColor
                disabledColor:(UIColor *)disabledColor;




// 通过图片创建Button

+ (UIButton *)buttonWithImageName:(NSString *)imageName
              backgroundImageName:(NSString *)backgroundImageName;

+ (UIButton *)buttonWithImageName:(NSString *)imageName
              backgroundImageName:(NSString *)backgroundImageName
             highlightedImageName:(NSString *)highlightedImageName
   highlightedBackgroundImageName:(NSString *)highlightedBackgroundImageName;










@end
