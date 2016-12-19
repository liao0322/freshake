//
//  UIColor+Extension.m
//  XFiOSKitDemo
//
//  Created by DamonLiao on 02/12/2016.
//  Copyright © 2016 DamonLiao. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)

+ (UIColor *)colorWithComponent:(NSInteger)component alpha:(NSInteger)alpha {
    CGFloat white = component / 255.0;
    return [UIColor colorWithWhite:white alpha:alpha];
}

+ (UIColor *)colorWithComponent:(NSInteger)component {
    return [self colorWithWhite:component alpha:1.0];
}

+ (UIColor *)colorWithR:(NSInteger)red G:(NSInteger)green B:(NSInteger)blue A:(NSInteger)alpha {
    CGFloat r = red / 255.0;
    CGFloat g = green / 255.0;
    CGFloat b = blue / 255.0;
    return [UIColor colorWithRed:r green:g blue:b alpha:alpha];
}

+ (UIColor *)colorWithR:(NSInteger)red G:(NSInteger)green B:(NSInteger)blue {
    return [self colorWithR:red G:green B:blue A:1.0];
}

+ (UIColor *)colorWithHex:(NSInteger)hex {
    NSInteger r = (hex & 0xFF0000) >> 16;
    NSInteger g = (hex & 0xFF00) >> 8;
    NSInteger b = hex & 0xFF;
    return [self colorWithR:r G:g B:b];
}

+ (UIColor *)randomColor {
    NSInteger r = arc4random_uniform(256);
    NSInteger g = arc4random_uniform(256);
    NSInteger b = arc4random_uniform(256);
    return [self colorWithR:r G:g B:b];
}



@end
