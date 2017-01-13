//
//  NSString+Extension.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2017/1/13.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

- (NSString *)clearLeadAndTailSpace {
    if(self.length == 0){
        return @"";
    }
    NSString *string = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return string;
}

- (NSString *)clearAllSpace {
    if(self.length == 0){
        return @"";
    }
    NSString *string = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    return string;
}

@end
