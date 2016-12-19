//
//  CouponsDetailCell.m
//  VegetablesApp
//
//  Created by M on 16/6/3.
//  Copyright © 2016年 M. All rights reserved.
//

#import "CouponsDetailCell.h"

@interface CouponsDetailCell ()

// 价格
@property (nonatomic, strong) UILabel *priceLabel;
// 使用条件
@property (nonatomic, strong) UILabel *conditionsLabel;
// 使用说明
@property (nonatomic, strong) UILabel *remarkLabel;
// 左边图片
@property (nonatomic, strong) UIImageView *leftImgView;
// 右边图片
@property (nonatomic, strong) UIImageView *rightImgView;

@end

@implementation CouponsDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initCell];
    }
    
    return self;
}

- (void)initCell {
    
    UIImage *imgSize = IMAGE(@"优惠券-左");
    
    // 左边背景
    _leftImgView = [UIImageView new];
    _leftImgView.image = IMAGE(@"CouponsDetails_Left");
    [self.contentView addSubview:_leftImgView];
    
    _leftImgView.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .topEqualToView(self.contentView)
    .heightIs(imgSize.size.height)
    .widthIs(imgSize.size.width);
    
    // 价格
    _priceLabel = [UILabel new];
    _priceLabel.font = [UIFont systemFontOfSize:14];
    _priceLabel.textColor = [UIColor whiteColor];
    _priceLabel.textAlignment = NSTextAlignmentCenter;
    [_leftImgView addSubview:_priceLabel];
    
    _priceLabel.sd_layout
    .heightIs(_leftImgView.frame.size.height)
    .widthIs(_leftImgView.frame.size.width)
    .centerXEqualToView(_leftImgView)
    .centerYEqualToView(_leftImgView);
    
    // 右边背景
    _rightImgView = [UIImageView new];
    _rightImgView.image = IMAGE(@"CouponsDetails_Right");
    [self.contentView addSubview:_rightImgView];
    
    _rightImgView.sd_layout
    .leftSpaceToView(_leftImgView, 0)
    .rightSpaceToView(self.contentView, 15)
    .topEqualToView(self.contentView)
    .heightIs(imgSize.size.height);

    for (int i = 0; i < 2; i++) {
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.tag = i + 5;
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.numberOfLines = 0;
        [_rightImgView addSubview:titleLabel];
        
        titleLabel.sd_layout
        .autoHeightRatio(0)
        .leftSpaceToView(_rightImgView, 10)
        .rightSpaceToView(_rightImgView, 10)
        .centerXEqualToView(_rightImgView);
        
        if (i == 0) {
            titleLabel.sd_layout.centerYIs(CGRectGetHeight(_rightImgView.frame) / 2 - 15);
        }
        else {
            titleLabel.sd_layout.centerYIs(CGRectGetHeight(_rightImgView.frame) / 2 + 15);
        }
    }
    
    // 使用说明标题
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"使用说明:";
    titleLabel.font = [UIFont boldSystemFontOfSize:14];
    titleLabel.textColor = [UIColor colorWithHexString:@"0xe83c01"];
    [self.contentView addSubview:titleLabel];
    
    titleLabel.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15)
    .topSpaceToView(_rightImgView, 20)
    .autoHeightRatio(0);
    
    // 使用条件
    _conditionsLabel = [UILabel new];
    _conditionsLabel.font = [UIFont systemFontOfSize:14];
    _conditionsLabel.textColor = [UIColor colorWithHexString:@"0xe83c01"];
    [self.contentView addSubview:_conditionsLabel];
    
    _conditionsLabel.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15)
    .topSpaceToView(titleLabel, 10)
    .autoHeightRatio(0);
    
    // 使用条件标题
    UILabel *remarkTitleLabel = [UILabel new];
    remarkTitleLabel.text = @"使用条件:";
    remarkTitleLabel.font = [UIFont boldSystemFontOfSize:14];
    remarkTitleLabel.textColor = [UIColor colorWithHexString:@"0xe83c01"];
    [self.contentView addSubview:remarkTitleLabel];
    
    remarkTitleLabel.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15)
    .topSpaceToView(_conditionsLabel, 20)
    .autoHeightRatio(0);
    
    // 使用说明
    _remarkLabel  = [UILabel new];
    _remarkLabel.font = [UIFont systemFontOfSize:14];
    _remarkLabel.textColor = [UIColor colorWithHexString:@"0xe83c01"];
    [self.contentView addSubview:_remarkLabel];
    
    _remarkLabel.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15)
    .topSpaceToView(remarkTitleLabel, 10)
    .autoHeightRatio(0);
    
    [self setupAutoHeightWithBottomView:_conditionsLabel bottomMargin:10];
}

- (void)setCouponsModel:(CouponModel *)couponsModel {

    NSString *string;
    if ([couponsModel.typeId integerValue] == 1) {
        string = [NSString stringWithFormat:@" %@件",couponsModel.Price];
    }
    else {
        string = [NSString stringWithFormat:@"￥%@元",couponsModel.Price];
    }
    
    // 价格
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributeString setAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont boldSystemFontOfSize:25]} range:NSMakeRange(1, couponsModel.Price.length)];
    _priceLabel.attributedText = attributeString;
    
    // 使用条件
    _conditionsLabel.text = couponsModel.Remark;
    // 使用说明
    _remarkLabel.text = couponsModel.XZContent;
    
    NSArray *titles = @[[NSString stringWithFormat:@"满%@元可以使用",couponsModel.consumeMoney],
                        [NSString stringWithFormat:@"有效时间:%@\n                %@", couponsModel.beginDate, couponsModel.ExpileDate]];
    for (int i = 0; i < 2; i++) {
        [(UILabel *)[self viewWithTag:i + 5] setText:titles[i]];
    }
}

@end
