//
//  XFStrikethroughLabel.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/27.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "XFStrikethroughLabel.h"

@implementation XFStrikethroughLabel

- (void)drawRect:(CGRect)rect {
    // 调用super的drawRect:方法,会按照父类绘制label的文字
    [super drawRect:rect];
    
    // 取文字的颜色作为删除线的颜色
    [self.textColor set];
    CGFloat w = rect.size.width;
    CGFloat h = rect.size.height;
    // 绘制(这个数字是为了找到label的中间位置,0.35这个数字是试出来的,如果不在中间可以自己调整)
    UIRectFill(CGRectMake(0, h * 0.5, w, 1));
}

@end
