//
//  PointDeliveryCell.m
//  VegetablesApp
//
//  Created by M on 16/6/6.
//  Copyright © 2016年 M. All rights reserved.
//

#import "PointDeliveryCell.h"

#define TextFontSize [UIFont systemFontOfSize:14]
#define TextColor [UIColor colorWithHexString:@"0x606060"]

@interface PointDeliveryCell ()

// 提货点名称
@property (nonatomic, strong) UILabel *nameLabel;
// 时间
@property (nonatomic, strong) UILabel *timeLabel;
// 地址
@property (nonatomic, strong) UILabel *addressLabel;
// 距离
@property (nonatomic, strong) UILabel *distanceLabel;

@end

@implementation PointDeliveryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle  = UITableViewCellSelectionStyleNone;
        
        [self initCell];
    }
    
    return self;
}

- (void)initCell {
    
    UIImage *distancaImg = [IMAGE(@"地标") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    
    // 定位View
    UIView *distancaView = [UIView new];
    [self.contentView addSubview:distancaView];
    
    distancaView.sd_layout
    .rightSpaceToView(self.contentView, 5)
//    .centerYEqualToView(self.contentView)
    .topSpaceToView(self.contentView, 20)
    .widthIs(100)
    .heightIs(distancaImg.size.height + 20);
    
    // 定位图
    UIImageView *distancaImgView = [UIImageView new];
    distancaImgView.tintColor = [UIColor colorDomina];
    distancaImgView.image = distancaImg;
    [distancaView addSubview:distancaImgView];
    
    distancaImgView.sd_layout
    .widthIs(distancaImg.size.width)
    .heightIs(distancaImg.size.height)
    .centerXEqualToView(distancaView)
    .topSpaceToView(distancaView, 0);
    
    // 定位距离
    _distanceLabel = [UILabel new];
    _distanceLabel.font = TextFontSize;
    _distanceLabel.textColor = [UIColor colorWithHexString:@"0x3c3c3c"];
    _distanceLabel.textAlignment = NSTextAlignmentCenter;
    [distancaView addSubview:_distanceLabel];
    
    _distanceLabel.sd_layout
    .topSpaceToView(distancaImgView, 5)
    .leftEqualToView(distancaView)
    .rightEqualToView(distancaView)
    .heightIs(15);
    
    // 提货点名
    _nameLabel = [UILabel new];
    _nameLabel.font = TextFontSize;
    _nameLabel.textColor = [UIColor colorWithHexString:@"0x3c3c3c"];
    [self.contentView addSubview:_nameLabel];
    
    _nameLabel.sd_layout
    .topSpaceToView(self.contentView, 15)
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(distancaView, 5)
    .heightIs(15);
    
    // 提货时间标题
    UILabel *timeTitleLabel = [UILabel new];
    timeTitleLabel.text = @"提货时间: ";
    timeTitleLabel.font = TextFontSize;
    timeTitleLabel.textColor = TextColor;
    [timeTitleLabel setSingleLineAutoResizeWithMaxWidth:100];
    [self.contentView addSubview:timeTitleLabel];
    
    timeTitleLabel.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .topSpaceToView(_nameLabel, 5)
    .autoHeightRatio(0);
    
    // 提货时间
    _timeLabel = [UILabel new];
    _timeLabel.font = TextFontSize;
    _timeLabel.textColor = TextColor;
    _timeLabel.numberOfLines = 0;
    [self.contentView addSubview:_timeLabel];

    _timeLabel.sd_layout
    .leftSpaceToView(timeTitleLabel, 0)
    .rightSpaceToView(distancaView, 5)
    .topSpaceToView(_nameLabel, 5)
    .autoHeightRatio(0);
    
    // 地址标题
    UILabel *addressTitleLabel = [UILabel new];
    addressTitleLabel.text = @"提货地址: ";
    addressTitleLabel.font = TextFontSize;
    addressTitleLabel.textColor = TextColor;
    [addressTitleLabel setSingleLineAutoResizeWithMaxWidth:100];
    [self.contentView addSubview:addressTitleLabel];
    
    addressTitleLabel.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .topSpaceToView(_timeLabel, 5)
    .autoHeightRatio(0);
    
    // 地址
    _addressLabel = [UILabel new];
    _addressLabel.font = TextFontSize;
    _addressLabel.textColor = TextColor;
    _addressLabel.numberOfLines = 0;
    [self.contentView addSubview:_addressLabel];
    
    _addressLabel.sd_layout
    .leftSpaceToView(addressTitleLabel, 0)
    .rightSpaceToView(distancaView, 5)
    .topSpaceToView(_timeLabel, 5)
    .autoHeightRatio(0);
    
    [self setupAutoHeightWithBottomView:_addressLabel bottomMargin:15];
}

- (void)setModel:(Map *)model {
    
    _distanceLabel.text = [NSString stringWithFormat:@"%.2f km",[model.pickJuli floatValue] / 1000];
    _nameLabel.text = [NSString stringWithFormat:@"%@",model.Fendianname];
    _addressLabel.text = [NSString stringWithFormat:@"%@",model.addr];
    _timeLabel.text = [model.picktime stringByReplacingOccurrencesOfString:@"；" withString:@"\n"];
}

@end
