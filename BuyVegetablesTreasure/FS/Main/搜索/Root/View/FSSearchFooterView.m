//
//  FSSearchFooterView.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/15.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSSearchFooterView.h"

@implementation FSSearchFooterView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.clearHistoryButton.width = 120;
    self.clearHistoryButton.height = 30;

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.clearHistoryButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.clearHistoryButton.layer.cornerRadius = 5.0f;
    self.clearHistoryButton.layer.borderWidth = 1.0f;
}

@end
