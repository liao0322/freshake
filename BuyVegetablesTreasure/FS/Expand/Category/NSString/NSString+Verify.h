//
//  NSString+Verify.h
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/26.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Verify)

- (BOOL)isPhoneNumber;

/// 判断一段字符串是否为空
- (BOOL)isEmpty;
@end
