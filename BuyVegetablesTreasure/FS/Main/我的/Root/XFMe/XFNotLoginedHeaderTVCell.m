//
//  XFNotLoginedHeaderTVCell.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2017/2/12.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import "XFNotLoginedHeaderTVCell.h"

@interface XFNotLoginedHeaderTVCell ()

@property (weak, nonatomic) IBOutlet UIButton *loginButton;


@end

@implementation XFNotLoginedHeaderTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.loginButton.layer.cornerRadius = 3.0f;
    self.loginButton.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)login:(id)sender {
    if (self.loginBlock) {
        self.loginBlock();
    }
}

@end
