//
//  FSShoppingCartIcon.h
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/28.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSShoppingCartIcon : UIView
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (nonatomic) void(^toShoppingCartBlock)();

@end
