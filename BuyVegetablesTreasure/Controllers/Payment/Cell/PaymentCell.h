//
//  PaymentCell.h
//  BuyVegetablesTreasure
//
//  Created by sc on 15/10/15.
//  Copyright (c) 2015年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *weChatPayButton;

@property (weak, nonatomic) IBOutlet UIButton *alipayPayButton;

@property (weak, nonatomic) IBOutlet UIView *weChatPayView;

@property (weak, nonatomic) IBOutlet UIView *alipayPayView;

- (IBAction)weChatPay;

- (IBAction)alipayPay;

@end
