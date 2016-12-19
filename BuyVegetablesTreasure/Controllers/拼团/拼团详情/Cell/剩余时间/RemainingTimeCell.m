//
//  RemainingTimeCell.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/4/6.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "RemainingTimeCell.h"

@interface RemainingTimeCell ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSString *payState;
@property (nonatomic, assign) int remainingTime;

@end

@implementation RemainingTimeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _payState = @"";
        [self initCell];
    }
    
    return self;
}

- (void)initCell {
    
    _remainingTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 30)];
    _remainingTimeLabel.font = [UIFont systemFontOfSize:17];
    _remainingTimeLabel.textColor = [UIColor colorWithHexString:@"0xfc9d15"];
    _remainingTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_remainingTimeLabel];
    
    for (int i = 0; i < 2; i++) {
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, (CGRectGetHeight(_remainingTimeLabel.frame) + 20) * i, ScreenWidth, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"0xE2E2E2"];
        [self.contentView addSubview:line];
    }
}

- (void)setTime:(NSString *)time {
 
    if (_timer == nil) {

//        if ([_model.IsPay boolValue]) {
//            
//            _payState = @"开团";
//        }
//        else _payState = @"支付";

        _remainingTime = [time intValue];
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(calculateTime) userInfo:nil repeats:YES];
    }
}

- (void)calculateTime {
    
    if (_remainingTime <= 0) {
        
        _remainingTime = 0;
        [_timer invalidate];
        _refreshBlock();
    }
    else {
        
        _remainingTime--;
    }

    int hInt = _remainingTime / 60 / 60;;
    int mInt = (_remainingTime - hInt * 3600) / 60;
    int sInt = _remainingTime % 60;
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@剩余时间 %02d:%02d:%02d 结束", _payState, hInt,mInt,sInt]];
    [attributeString setAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"0xfc9d15"], NSFontAttributeName : [UIFont systemFontOfSize:20]} range:NSMakeRange(5, 9)];
    _remainingTimeLabel.attributedText = attributeString;
}

- (void)stopTimer {
    [_timer invalidate];
}

@end
