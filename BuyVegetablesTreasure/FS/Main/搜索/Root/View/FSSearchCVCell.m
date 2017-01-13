//
//  FSSearchCVCell.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/11.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSSearchCVCell.h"

@implementation FSSearchCVCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.0f];
        [self.contentView addSubview:self.textLabel];
        self.textLabel.font = [UIFont fontWithName:@"PingFangTC-Light" size:14.0f];
        self.layer.cornerRadius = 5.0f;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.textLabel sizeToFit];
    self.textLabel.x = 10;
    self.textLabel.centerY = self.height * 0.5;
    
}

#pragma mark - LazyLoad

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:14];
        [_textLabel setText:@"test"];
        [_textLabel sizeToFit];
    }
    return _textLabel;
}

@end
