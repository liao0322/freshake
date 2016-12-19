//
//  RechargeView.h
//  BuyVegetablesTreasure
//
//  Created by Song on 16/3/14.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RechargeView : UIView

@property (nonatomic,copy)void(^RechargeBtn)(NSString *money);

//是否底部View
@property (nonatomic, copy  ) NSString *isBottomView;

//金额
@property (nonatomic, copy  ) NSString *money;


@property (nonatomic, readonly) UILabel *TitleLabel;
@property (nonatomic, readonly) UILabel *SumLabel;
@property (nonatomic, strong  ) UIButton *PayButton;

-(void)SetUI:(NSString *)money WithTitle:(NSString *)title AndColor:(NSString *)color;

@end
