//
//  FSViewExpressFirstLineTVCell.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2017/1/16.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import "FSViewExpressFirstLineTVCell.h"

@interface FSViewExpressFirstLineTVCell ()

@property (weak, nonatomic) IBOutlet UIView *iconBGView;

// 商品缩略图
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

// 物流状态
@property (weak, nonatomic) IBOutlet UILabel *expressStatusTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *expressStatusLabel;

// 承运来源
@property (weak, nonatomic) IBOutlet UILabel *expressCompanyNameTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *expressCompanyNameLabel;

// 运单编号
@property (weak, nonatomic) IBOutlet UILabel *waybillNumberTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *waybillNumberLabel;

// 官方电话
@property (weak, nonatomic) IBOutlet UILabel *expressCompanyPhoneNumberTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *expressCompanyPhoneNumberButton;



@end

@implementation FSViewExpressFirstLineTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.iconBGView.layer.borderColor = [UIColor grayColor].CGColor;
    self.iconBGView.layer.borderWidth = 0.3;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)phoneNumberButtonTouchUpInside:(UIButton *)sender {
    NSLog(@"打电话");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://10086"]];
}

@end
