//
//  XFMeCollectionViewCell.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2017/3/23.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import "XFMeCollectionViewCell.h"

@interface XFMeCollectionViewCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelTopConstraint;

@end

@implementation XFMeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}
- (void)updateConstraints {
    [super updateConstraints];

    self.imageTopConstraint.constant = (self.height - 60) * 0.4;
    self.labelTopConstraint.constant = (self.height - 60) * 0.4;
}

@end
