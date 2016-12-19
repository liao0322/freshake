//
//  RegisterView.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/5/10.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CountdownButton.h"

@interface RegisterView : UIView

@property (nonatomic, copy) UIButton *agreementBtn;
@property (nonatomic, copy) CountdownButton *countdownBtn;

@property (nonatomic, copy) void(^sendVerification)(NSString *phoneString);
@property (nonatomic, copy) void(^registered)(NSArray *registeredInfoArray);
@property (nonatomic, copy) void(^goViewContrller)(UIViewController *viewController);

@end
