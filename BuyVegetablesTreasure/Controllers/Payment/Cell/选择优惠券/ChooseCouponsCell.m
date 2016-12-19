//
//  ChooseCouponsCell.m
//  VegetablesApp
//
//  Created by M on 16/6/14.
//  Copyright © 2016年 M. All rights reserved.
//

#import "ChooseCouponsCell.h"

@implementation ChooseCouponsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initCell];
    }
    
    return self;
}

- (void)initCell {
    
    UIView *bgView = [UIView new];
    [self.contentView addSubview:bgView];
    
    bgView.sd_layout
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .topEqualToView(self.contentView)
    .heightIs(45);
    
    _titleLabel = [UILabel new];
    _titleLabel.text = @"请选择优惠券";
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textColor = Color;
    [_titleLabel setSingleLineAutoResizeWithMaxWidth:200];
    [bgView addSubview:_titleLabel];
    
    _titleLabel.sd_layout
    .leftSpaceToView(bgView, 15)
    .centerYEqualToView(bgView)
    .heightIs(45);
    
    _couponsNumberLabel = [UILabel new];
    _couponsNumberLabel.text = @"当前没有可用优惠券";
    _couponsNumberLabel.font = [UIFont systemFontOfSize:14];
    _couponsNumberLabel.textColor = Color;
    [_couponsNumberLabel setSingleLineAutoResizeWithMaxWidth:200];
    [bgView addSubview:_couponsNumberLabel];
    
    _couponsNumberLabel.sd_layout
    .rightSpaceToView(bgView, 0)
    .centerYEqualToView(bgView)
    .heightIs(45);
    
    UILabel *line = [UILabel new];
    line.backgroundColor = [UIColor colorWithHexString:@"0xd7d7d7"];
    [bgView addSubview:line];
    
    line.sd_layout
    .leftEqualToView(bgView)
    .bottomEqualToView(bgView)
    .widthIs(ScreenWidth)
    .heightIs(1);
}

- (void)setCouponsNumber:(NSInteger)couponsNumber {
    
    _couponsNumber = couponsNumber;
    
    if (couponsNumber == 0) {
        _couponsNumberLabel.text = @"当前没有可用优惠券";
    }
    else {
        _couponsNumberLabel.text = [NSString stringWithFormat:@"您有%zd张优惠券可用",couponsNumber];
    }
}

- (void)setTitleString:(NSString *)titleString {
    _titleLabel.text = titleString;
}

@end
