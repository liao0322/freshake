//
//  UIButton+Create.m
//  XFiOSKitDemo
//
//  Created by DamonLiao on 02/12/2016.
//  Copyright © 2016 DamonLiao. All rights reserved.
//

#import "UIButton+Create.h"

@implementation UIButton (Create)

#pragma mark - SystemButton

+ (UIButton *)systemButtonWithOrigin:(CGPoint)origin
                               title:(NSString *)title {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(origin.x, origin.y, 0, 0);
    [button setTitle:title forState:UIControlStateNormal];
    [button sizeToFit];
    return button;
}

+ (UIButton *)systemButtonWithOrigin:(CGPoint)origin
                               title:(NSString *)title
                          titleColor:(UIColor *)titleColor {
    
    UIButton *button = [self systemButtonWithOrigin:origin title:title];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    return button;
}

+ (UIButton *)systemButtonWithOrigin:(CGPoint)origin
                               title:(NSString *)title
                          titleColor:(UIColor *)titleColor
                              target:(nullable id)target
                              action:(SEL)action {
    
    UIButton *button = [self systemButtonWithOrigin:origin title:title titleColor:titleColor];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark - CustomButton

+ (UIButton *)buttonWithOrigin:(CGPoint)origin
                         title:(NSString *)title {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(origin.x, origin.y, 0, 0);
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button sizeToFit];
    return button;
    
}

+ (UIButton *)buttonWithFrame:(CGRect)frame
                  normalColor:(UIColor *)normalColor
                        title:(NSString *)title {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageWithColor:normalColor] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    button.frame = frame;
    return button;
}

+ (UIButton *)buttonWithFrame:(CGRect)frame
                  normalColor:(UIColor *)normalColor
                        title:(NSString *)title
                 cornerRadius:(CGFloat)cornerRadius {
    
    UIButton *button = [self buttonWithFrame:frame normalColor:normalColor title:title];
    button.layer.cornerRadius = cornerRadius;
    button.layer.masksToBounds = YES;
    return button;
}

+ (UIButton *)buttonWithFrame:(CGRect)frame
                  normalColor:(UIColor *)normalColor
                        title:(NSString *)title
                 cornerRadius:(CGFloat)cornerRadius
             highlightedColor:(UIColor *)highlightedColor {

    UIButton *button = [self buttonWithFrame:frame normalColor:normalColor title:title cornerRadius:cornerRadius];
    [button setBackgroundImage:[UIImage imageWithColor:highlightedColor] forState:UIControlStateHighlighted];
    return button;
}

+ (UIButton *)buttonWithFrame:(CGRect)frame
                  normalColor:(UIColor *)normalColor
                        title:(NSString *)title
                 cornerRadius:(CGFloat)cornerRadius
             highlightedColor:(UIColor *)highlightedColor
                disabledColor:(UIColor *)disabledColor {
    
    UIButton *button = [self buttonWithFrame:frame normalColor:normalColor title:title cornerRadius:cornerRadius highlightedColor:highlightedColor];
    [button setBackgroundImage:[UIImage imageWithColor:disabledColor] forState:UIControlStateDisabled];
    return button;
    
}


+ (UIButton *)buttonWithImageName:(NSString *)imageName
              backgroundImageName:(NSString *)backgroundImageName {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];

    [button setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
    
    [button setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:UIControlStateNormal];
    [button sizeToFit];
    return button;
}

+ (UIButton *)buttonWithImageName:(NSString *)imageName
              backgroundImageName:(NSString *)backgroundImageName
             highlightedImageName:(NSString *)highlightedImageName
   highlightedBackgroundImageName:(NSString *)highlightedBackgroundImageName {
    
    UIButton *button = [self buttonWithImageName:imageName backgroundImageName:backgroundImageName];
    [button setImage:[UIImage imageNamed:highlightedImageName] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageNamed:highlightedBackgroundImageName] forState:UIControlStateHighlighted];
    return button;
}


@end
