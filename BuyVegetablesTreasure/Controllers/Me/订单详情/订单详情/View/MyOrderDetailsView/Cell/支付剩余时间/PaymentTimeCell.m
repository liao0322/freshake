//
//  PaymentTimeCell.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/9/7.
//
//

#import "PaymentTimeCell.h"

@interface PaymentTimeCell ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation PaymentTimeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initCell];
    }
    
    return self;
}

- (void)initCell {
    
    _timeLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:13];
    _timeLabel.textColor = [UIColor blackColor];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.numberOfLines = 0;
    [self.contentView addSubview:_timeLabel];
    
    _timeLabel.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15)
    .topSpaceToView(self.contentView, 15)
    .autoHeightRatio(0);
    
    [self setupAutoHeightWithBottomView:_timeLabel bottomMargin:15];
}

- (void)setOrderDetailsModel:(MyOrderDetailsModel *)orderDetailsModel {
    
    if (isBlankString(_timeLabel.text)) {
        
        _timeLabel.text = [NSString stringWithFormat:@"您于%@下的订单\n请在%@内付款,超时订单将自动取消",orderDetailsModel.add_time,[self timeConversion:[orderDetailsModel.RemainingTime integerValue]]];
    }
}

- (NSString *)timeConversion:(NSInteger)time {
    
    NSString *nTime;
    if (time >= 0 && time < 60) {
        nTime = [NSString stringWithFormat:@"%02zd秒",time];
    }
    else if (time > 60 && time < 3600) {
        nTime = [NSString stringWithFormat:@"%02zd分%02zd秒", time / 60 ,time % 60];
    }
    else {
        nTime = [NSString stringWithFormat:@"%02zd时%02zd分%02zd秒", time / 3600, time % 3600 / 60, time % 3600 % 60];
    }
    return nTime;
}

@end
