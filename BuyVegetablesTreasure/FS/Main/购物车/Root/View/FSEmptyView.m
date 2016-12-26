//
//  FSEmptyView.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/26.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSEmptyView.h"

@interface FSEmptyView ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UIButton *strollButton;


@end


@implementation FSEmptyView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.iconImageView.centerX = self.width * 0.5;
    self.iconImageView.y = self.height * 0.3;
    
    self.tipsLabel.centerX = self.iconImageView.centerX;
    self.tipsLabel.y = self.iconImageView.bottom + self.height * 0.051;
    
    self.strollButton.centerX = self.iconImageView.centerX;
    self.strollButton.y = self.tipsLabel.bottom + self.height * 0.1;
}


@end
