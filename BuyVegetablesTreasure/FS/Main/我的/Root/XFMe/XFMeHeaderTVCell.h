//
//  XFMeHeaderTVCell.h
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2017/2/10.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XFMeHeaderTVCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *pointLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponsLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponsTitleLabel;

@property (nonatomic) void(^avatarButtonBlock)();
@property (nonatomic) void(^pointTapBlock)();
@property (nonatomic) void(^balanceTapBlock)();
@property (nonatomic) void(^couponsTapBlock)();

@end
