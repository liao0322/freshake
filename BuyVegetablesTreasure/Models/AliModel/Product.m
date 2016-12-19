//
//  Product.m
//  LaMALL
//
//  Created by qianfeng on 15-7-4.
//  Copyright (c) 2015年 yuanjinsong. All rights reserved.
//

#import "Product.h"

@implementation Product

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"%@类不存在%@属性",NSStringFromClass([self class]),key);
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([value isKindOfClass:[NSNumber class]]) {
        // 第一种转换方式
        NSNumberFormatter * numberFormat = [[NSNumberFormatter alloc]init];
        value = [numberFormat stringFromNumber:value];
        
        // 第二种转换方式
        //        value = [value stringValue];
    }
    [super setValue:value forKey:key];
}


@end
