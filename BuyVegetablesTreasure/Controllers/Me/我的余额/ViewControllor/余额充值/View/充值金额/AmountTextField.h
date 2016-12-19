//
//  AmountTextField.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/11/28.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AmountTextField : UIView

@property (nonatomic, strong) void(^amountBlock)(NSString *priceString, NSString *idString);

@end
