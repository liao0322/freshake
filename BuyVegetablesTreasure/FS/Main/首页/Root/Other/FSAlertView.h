//
//  FSAlertView.h
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2017/4/5.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSAlertView : UIView

+ (void)showSuccessWithString:(NSString *)string;
+ (void)showErrorWithString:(NSString *)string;

@end
