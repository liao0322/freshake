//
//  CountdownButton.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/5/13.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "CountdownButton.h"

#define FrameWidth self.frame.size.width
#define FrameHeight self.frame.size.height

@interface CountdownButton ()

@property (nonatomic, strong) NSTimer *countdownTimer;

@end

@implementation CountdownButton

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initCountdownBtn];
    }
    return self;
}

- (void)initCountdownBtn {

    if (self.countdownLabel == nil) {
        
        _countdownTtitle = @"获取验证码";
        _fontSize = 12;
        _time = 60;
        _endBgColor = _startBgColor = [UIColor clearColor];
        
        self.countdownLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, FrameWidth, FrameHeight)];
        self.countdownLabel.text = _countdownTtitle;
        self.countdownLabel.font = [UIFont systemFontOfSize:_fontSize];
        self.countdownLabel.textColor = [UIColor blackColor];
        self.countdownLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.countdownLabel];
    }
}

- (void)startTiming {
    
    self.enabled = NO;
    self.countdownLabel.text = [NSString stringWithFormat:@"%zd s",_time];
    self.countdownLabel.backgroundColor = _startBgColor;
    self.countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerStart) userInfo:nil repeats:YES];
}

- (void)timerStart {
    
    _time --;
    
    if (_time <= 0) {
        
        [_countdownTimer invalidate];
        
        self.enabled = YES;
        self.countdownLabel.text = _countdownTtitle;
        self.countdownLabel.backgroundColor = _endBgColor;
        
        _time = 60;
    }
    else {
        
        self.countdownLabel.backgroundColor = _startBgColor;
        self.countdownLabel.text = [NSString stringWithFormat:@"%zd s",_time];
    }
}

- (void)setCountdownTtitle:(NSString *)countdownTtitle {
    _countdownTtitle = countdownTtitle;
    self.countdownLabel.text = countdownTtitle;
}

- (void)setFontSize:(CGFloat)fontSize {
    _fontSize = fontSize;
    self.countdownLabel.font = [UIFont systemFontOfSize:_fontSize];
}

- (void)setCountdownTextColor:(UIColor *)countdownTextColor {
    _countdownTextColor = countdownTextColor;
    self.countdownLabel.textColor = countdownTextColor;
}

- (void)setEndBgColor:(UIColor *)endBgColor {
    _endBgColor = endBgColor;
    self.countdownLabel.backgroundColor = endBgColor;
}

@end
