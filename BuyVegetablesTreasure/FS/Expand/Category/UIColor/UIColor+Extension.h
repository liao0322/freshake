//
//  UIColor+Extension.h
//  XFiOSKitDemo
//
//  Created by DamonLiao on 02/12/2016.
//  Copyright © 2016 DamonLiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)

+ (UIColor *)colorWithComponent:(NSInteger)component alpha:(NSInteger)alpha;
+ (UIColor *)colorWithComponent:(NSInteger)component;

+ (UIColor *)colorWithR:(NSInteger)red G:(NSInteger)green B:(NSInteger)blue A:(NSInteger)alpha;
+ (UIColor *)colorWithR:(NSInteger)red G:(NSInteger)green B:(NSInteger)blue;


+ (UIColor *)colorWithHex:(NSInteger)hex;
+ (UIColor *)randomColor;

@end
