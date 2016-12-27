//
//  MemberInfoCell.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/4/6.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "MemberInfoCell.h"

@interface MemberInfoCell ()

@property (nonatomic, copy) UIImageView *headImageView;
@property (nonatomic, copy) UILabel *nameLabel;
@property (nonatomic, copy) UILabel *timeLabel;
@property (nonatomic, copy) UILabel *statusLabel;

@end

@implementation MemberInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initCell];
    }
    
    return self;
}

- (void)initCell {
    
    // 头像
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    bgImageView.image = [UIImage imageNamed:@"小椭圆"];
    bgImageView.clipsToBounds = YES;
    [self.contentView addSubview:bgImageView];
    
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(1, 1, 38, 38)];
    _headImageView.layer.cornerRadius = 20;
    _headImageView.layer.masksToBounds = YES;
    _headImageView.image = IMAGE(@"头像三");
    [bgImageView addSubview:_headImageView];
    
    // 昵称
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(bgImageView.frame) + 10, 0, ScreenWidth / 2 - 80, 60)];
//    _nameLabel.text = @"小清新的流氓";
    _nameLabel.font = [UIFont systemFontOfSize:13];
    _nameLabel.textColor = [UIColor colorWithHexString:@"0x606060"];
    [self.contentView addSubview:_nameLabel];
    
    // 时间
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_nameLabel.frame) + 10, 0, ScreenWidth / 2 - 30, 60)];
    _timeLabel.text = @"2015.12.11 15:09:12";
    _timeLabel.font = [UIFont systemFontOfSize:13];
    _timeLabel.textColor = [UIColor colorWithHexString:@"0x606060"];
    [self.contentView addSubview:_timeLabel];
    
    // 状态
    _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 50, 0, 50, 60)];
    _statusLabel.text = @"开团";
    _statusLabel.font = [UIFont systemFontOfSize:13];
    _statusLabel.textColor = [UIColor colorWithHexString:@"0x606060"];
    _statusLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_statusLabel];
    
    for (int i = 0; i < 2; i++) {
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 60 * i, ScreenWidth, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"0xE2E2E2"];
        [self.contentView addSubview:line];
    }
}

- (void)setModel:(GroupDetailListModel *)model {
    NSString *name = [NSString stringWithFormat:@"%@", model.mobile];
    
    if (name.length >= 11) {
        _nameLabel.text = [name stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    } else {
        _nameLabel.text = model.mobile;
    }
    
    _timeLabel.text = model.AddTime;
    _statusLabel.text = [model.IsAdd boolValue] ? @"开团" : @"跟团";
    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:IMAGE(@"头像三")];
}

@end
