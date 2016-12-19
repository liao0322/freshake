
//
//  ParentModel.m
//  MiZheDemo
//
//  Created by Kai on 15/6/29.
//  Copyright (c) 2015年 Kai. All rights reserved.
//




#import "ParentModel.h"

@implementation ParentModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}

- (void)setValue:(id)value forKey:(NSString *)key{
    
    if ([value isKindOfClass:[NSNumber class]]) {
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        numberFormatter.numberStyle = /*kCFNumberFormatterRoundHalfEven*/kCFNumberFormatterRoundFloor;
        value = [numberFormatter stringFromNumber:value];
        value = [value stringByReplacingOccurrencesOfString:@"," withString:@""];
    }
    
    [super setValue:value forKey:key];
}

@end
