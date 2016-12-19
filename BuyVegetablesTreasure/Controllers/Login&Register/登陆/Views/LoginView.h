//
//  LoginView.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/5/9.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginView : UIView

@property (nonatomic, copy) void (^loginBlock)(NSString *userName, NSString *passWord);
@property (nonatomic, copy) void(^goViewController)(UIViewController *viewController);

@end
