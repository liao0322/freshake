//
//  XFMeHeaderTVCell.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2017/2/10.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import "XFMeHeaderTVCell.h"

@interface XFMeHeaderTVCell ()

@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *avatarButton;

@end

@implementation XFMeHeaderTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.avatarButton.layer.cornerRadius = 30.0f;
    self.avatarButton.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *pointTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pointTap:)];
    UITapGestureRecognizer *pointTitleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pointTap:)];
    [self.pointLabel addGestureRecognizer:pointTap];
    [self.pointTitleLabel addGestureRecognizer:pointTitleTap];
    
    UITapGestureRecognizer *balanceTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(balanceTap:)];
    UITapGestureRecognizer *balanceTitleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(balanceTap:)];
    [self.balanceLabel addGestureRecognizer:balanceTap];
    [self.balanceTitleLabel addGestureRecognizer:balanceTitleTap];
    
    UITapGestureRecognizer *couponsTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(couponsTap:)];
    UITapGestureRecognizer *couponsTitleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(couponsTap:)];
    [self.couponsLabel addGestureRecognizer:couponsTap];
    [self.couponsTitleLabel addGestureRecognizer:couponsTitleTap];
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    
    if (![userDefaults objectForKey:@"UID"]) {
        return;
    }
    
    if ([Tools isBlankString:[userDefaults objectForKey:@"nick_name"]]) {
        self.nicknameLabel.text = @"去取个昵称吧~";
    }
    else {
        self.nicknameLabel.text = [userDefaults objectForKey:@"nick_name"];
    }
    
    NSString *mobileStr = [NSString stringWithFormat:@"%@", [userDefaults objectForKey:@"mobile"]];
    
    if (mobileStr.length >= 11) {
        self.phoneNumberLabel.text = [mobileStr stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    } else {
        self.phoneNumberLabel.text = [userDefaults objectForKey:@"mobile"];
    }
    [self.avatarButton sd_setImageWithURL:[userDefaults objectForKey:@"avatar"] forState:UIControlStateNormal placeholderImage:IMAGE(@"FS默认头像")];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)avatarTouchUpInside:(id)sender {
    if (self.avatarButtonBlock) {
        self.avatarButtonBlock();
    }
}

- (void)pointTap:(id)sender {
    if (self.pointTapBlock) {
        self.pointTapBlock();
    }
}

- (void)balanceTap:(id)sender {
    if (self.balanceTapBlock) {
        self.balanceTapBlock();
    }
}

- (void)couponsTap:(id)sender {
    if (self.couponsTapBlock) {
        self.couponsTapBlock();
    }
}

@end
