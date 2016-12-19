//
//  ShoppingCartView.h
//  BuyVegetablesTreasure
//
//  Created by sc on 15/11/19.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingCartView : UIView

@property (nonatomic, copy) void(^goHomePage)();
@property (nonatomic, copy) UIButton *goHomePageShopping;
@end
