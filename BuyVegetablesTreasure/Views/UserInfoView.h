//
//  UserInfoView.h
//  BuyVegetablesTreasure
//
//  Created by sc on 15/10/15.
//  Copyright (c) 2015年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoView : UIView

@property (weak, nonatomic) IBOutlet UILabel     *userTypeLabel;
@property (weak, nonatomic) IBOutlet UITextField *userInfoTextField;

@property (nonatomic, copy) UIButton *manButton;
@property (nonatomic, copy) UIButton *girlButton;

@end
