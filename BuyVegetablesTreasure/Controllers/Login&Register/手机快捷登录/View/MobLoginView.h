//
//  MobLoginView.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/5/13.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CountdownButton.h"

@interface MobLoginView : UIView

@property (nonatomic, strong) CountdownButton *countdownBtn;

@property (nonatomic, copy) void(^sendVerification)(NSString *phoneString);
@property (nonatomic, copy) void(^login)(NSString *userName,NSString *verification);

@end
