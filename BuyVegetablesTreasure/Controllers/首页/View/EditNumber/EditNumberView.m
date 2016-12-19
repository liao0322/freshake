//
//  EditNumberView.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/12/12.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "EditNumberView.h"

@interface EditNumberView ()

@property (nonatomic, strong) UILabel *numberLabel;

@end

@implementation EditNumberView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self initEditNumberView];
    }
    
    return self;
}

- (void)initEditNumberView {
    
    CGFloat btnWidth = 30;
    
    self.numberLabel = [UILabel new];
    self.numberLabel.text = @"0";
    self.numberLabel.font = [UIFont systemFontOfSize:13];
    self.numberLabel.textColor = [UIColor blackColor];
    self.numberLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.numberLabel];
    
    self.numberLabel.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .topEqualToView(self)
    .bottomEqualToView(self);
    
    for (int i = 0; i < 2; i++) {
        
        UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        editBtn.tag = i + 100;
        [editBtn setImage:IMAGE(i == 0 ? @"减号" : @"加号") forState:UIControlStateNormal];
        [editBtn addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:editBtn];
        
        editBtn.sd_layout
        .topEqualToView(self)
        .bottomEqualToView(self)
        .widthIs(btnWidth);
        
        if (i == 0) {
            editBtn.sd_layout.leftEqualToView(self);
        }
        else {
            editBtn.sd_layout.rightEqualToView(self);
        }
    }
}

- (void)setNumberString:(NSString *)numberString {
    self.numberLabel.text = numberString;
}

- (void)edit:(UIButton *)editBtn {
    
    int currentNumber = [self.numberLabel.text intValue];
    if (editBtn.tag == 100 && currentNumber <= 0) {
        self.numberLabel.text = @"0";
    }
    else {
        self.editGoodsNumber(editBtn.tag - 100, currentNumber);
    }
}

@end
