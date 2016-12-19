//
//  UIColor+Project.m
//  XFiOSKitDemo
//
//  Created by DamonLiao on 2016/12/3.
//  Copyright © 2016年 DamonLiao. All rights reserved.
//

#import "UIColor+Project.h"
#import "XFColorDefine.h"
#import "UIColor+Extension.h"

@implementation UIColor (Project)

+ (UIColor *)colorDomina {
    return [UIColor colorWithHex:XFColorDomina];
}

+ (UIColor *)colorButtonHighlighted {
    return [UIColor colorWithHex:XFColorButtonHighlighted];
}

+ (UIColor *)colorNavBarBG {
    return [UIColor colorWithHex:XFColorNavBarBG];
}

+ (UIColor *)colorSeparatorLine {
    return [UIColor colorWithHex:XFColorSeparator];
}

+ (UIColor *)colorViewBG {
    return [UIColor colorWithHex:XFColorViewBG];
}

+ (UIColor *)colorTextDomina {
    return [UIColor colorWithHex:XFColorTextDomina];
}

+ (UIColor *)colorTextAssistant {
    return [UIColor colorWithHex:XFColorTextAssistantA];
}

@end
