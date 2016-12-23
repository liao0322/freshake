//
//  FSParentModel.m
//  BuyVegetablesTreasure
//
//  Created by 江玉元 on 2016/12/21.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSParentModel.h"

@implementation FSParentModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

}

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([value isKindOfClass:[NSNumber class]]) {
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        numberFormatter.numberStyle = kCFNumberFormatterRoundFloor;
        value = [numberFormatter stringFromNumber:value];
        value = [value stringByReplacingOccurrencesOfString:@"," withString:@""];
    }
    
    [super setValue:value forKey:key];
}

@end
