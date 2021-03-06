//
//  GroupStatusCell.m
//  BuyVegetablesTreasure
//
//  Created by sc on 16/4/5.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "GroupStatusCell.h"

@interface GroupStatusCell ()

@property (nonatomic, copy) UILabel *statusLabel;
@property (nonatomic, copy) UILabel *timeLabel;
@property (nonatomic, copy) UIImageView *statusImageView;

@property (nonatomic, copy) NSString *hString;
@property (nonatomic, copy) NSString *mString;
@property (nonatomic, copy) NSString *sString;

@property (nonatomic, copy) NSTimer *timer;

@end

@implementation GroupStatusCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initCell];
    }
    return self;
}

- (void)initCell {
    
    CGFloat width = [Utillity getTextWidthWithText:@"开团成功" height:40 font:[UIFont systemFontOfSize:14]];
    _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth / 2 - width / 2, 20, width * 3, 40)];
    _statusLabel.font = [UIFont systemFontOfSize:14];
    _statusLabel.textColor = [UIColor colorWithHexString:@"0x404040"];
    _statusLabel.numberOfLines = 0;
    [self.contentView addSubview:_statusLabel];
    
    _statusImageView = [[UIImageView alloc] initWithImage:[IMAGE(@"待付款") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    _statusImageView.tintColor = [UIColor colorDomina];
    
    _statusImageView.frame = CGRectMake(_statusLabel.frame.origin.x - 40, 26, 28, 28);
    [self.contentView addSubview:_statusImageView];
    
    for (int i = 0; i < 2; i++) {
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, (CGRectGetHeight(_statusLabel.frame) + 40) * i, ScreenWidth, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"0xE2E2E2"];
        [self.contentView addSubview:line];
    }
}

- (void)setModel:(GroupDetailModel *)model {

    NSInteger status = [model.UStatus integerValue];
    if (status == 1) {
        
        CGRect frame = _statusLabel.frame;
        frame.size.height = 20;
        
        _statusLabel.frame = frame;
        _statusLabel.text = @"待处理";
        _statusImageView.image = [IMAGE(@"待付款") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        if (_timeLabel == nil) {
            
            // 时间
            _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_statusLabel.frame.origin.x, CGRectGetMaxY(_statusLabel.frame), ScreenWidth, 20)];
            _timeLabel.font = [UIFont systemFontOfSize:14];
            _timeLabel.textColor = [UIColor colorWithHexString:@"0x404040"];
            [self.contentView addSubview:_timeLabel];
            
            NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"剩余付款时间 %@",[self getTime:model.PayTime]]];
            [attributeString setAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"0x404040"], NSFontAttributeName : [UIFont systemFontOfSize:20]} range:NSMakeRange(7, 8)];
            _timeLabel.attributedText = attributeString;
            
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(calculateTime) userInfo:nil repeats:YES];
        }
    }
    else if (status == 2) {
        
        _statusLabel.text = @"开团成功\n快去邀请好友加入!";
        _statusImageView.image = IMAGE(@"FSPTdetail成功");
    }
    else if (status == 3) {
        
        _statusLabel.text = @"拼团成功\n请前往我的订单查看信息!";
        _statusImageView.image = IMAGE(@"FSPTdetail成功");
    }
    else if (status == 4) {
        
        _statusLabel.text = @"拼团失败\n下次多邀请几个小伙伴吧!";
        _statusImageView.image = IMAGE(@"FSPTdetail失败");
    }
}

- (NSString *)getTime:(NSString *)seconds {
    
    _hString = [NSString stringWithFormat:@"%02d", [seconds intValue] / 60 / 60];
    _mString = [NSString stringWithFormat:@"%02d",([seconds intValue] - [_hString intValue] *3600) / 60];
    _sString = [NSString stringWithFormat:@"%02d",[seconds intValue] % 60];;
    
    return [NSString stringWithFormat:@"%@:%@:%@",_hString,_mString,_sString];
}

- (void)calculateTime {
    
    if ([_hString integerValue] == 0 && [_mString integerValue] == 0 && [_sString integerValue] == 0) {
        [_timer invalidate];
        _refreshBlock();
    }
    else if ([_hString integerValue] == 0 && [_mString integerValue] == 0 && [_sString integerValue] == 1) {
        _sString = @"00";
        [_timer invalidate];
    }
    else if ([_sString integerValue] == 0) {
        _sString = @"59";
        _mString = [NSString stringWithFormat:@"%02d",[_mString intValue] - 1];
    }
    else {
        _sString = [NSString stringWithFormat:@"%02d",[_sString intValue] - 1];
    }
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"剩余付款时间 %@:%@:%@", _hString,_mString,_sString]];
    [attributeString setAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"0x404040"], NSFontAttributeName : [UIFont systemFontOfSize:20]} range:NSMakeRange(7, 8)];
    _timeLabel.attributedText = attributeString;
}

@end
