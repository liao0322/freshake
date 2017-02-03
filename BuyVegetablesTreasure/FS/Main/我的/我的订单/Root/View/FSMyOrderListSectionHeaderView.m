//
//  FSMyOrderListSectionHeaderView.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2017/1/24.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import "FSMyOrderListSectionHeaderView.h"
#import "Order.h"

#define TOP_GAP 8.0f

@interface FSMyOrderListSectionHeaderView ()

@property (nonatomic) UIView *bgView;
@property (nonatomic) UIImageView *iconImageView;
@property (nonatomic) UILabel *orderNumberTitleLabel;
@property (nonatomic) UILabel *orderNumberLabel;
@property (nonatomic) UIButton *cancelOrderButton;

@property (nonatomic) UIView *separatorLine;

@end

@implementation FSMyOrderListSectionHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews {

    [self.contentView addSubview:self.bgView];
    [self.contentView addSubview:self.separatorLine];
    [self.bgView addSubview:self.iconImageView];
    [self.bgView addSubview:self.orderNumberTitleLabel];
    [self.bgView addSubview:self.orderNumberLabel];
    [self.bgView addSubview:self.cancelOrderButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = self.width;
    CGFloat height = self.height;
    
    self.separatorLine.width = width;
    self.separatorLine.height = 0.5;
    self.separatorLine.x = 0;
    self.separatorLine.y = TOP_GAP;
    
    self.bgView.width = width;
    self.bgView.height = height - TOP_GAP;
    self.bgView.x = 0;
    self.bgView.y = TOP_GAP;
    
    [self.iconImageView sizeToFit];
    self.iconImageView.x = 15;
    self.iconImageView.centerY = self.bgView.height * 0.5;
    
    [self.orderNumberTitleLabel sizeToFit];
    self.orderNumberTitleLabel.centerY = self.iconImageView.centerY;
    self.orderNumberTitleLabel.x = self.iconImageView.right + 10;
    
    [self.orderNumberLabel sizeToFit];
    self.orderNumberLabel.centerY = self.orderNumberTitleLabel.centerY;
    self.orderNumberLabel.x = self.orderNumberTitleLabel.right;
    
    [self.cancelOrderButton sizeToFit];
    self.cancelOrderButton.right = width - 15;
    self.cancelOrderButton.centerY = self.iconImageView.centerY;
}

- (void)setModel:(Order *)model {
    _model = model;
    self.orderNumberLabel.text = self.model.order_no;
    
    NSInteger status = [model.status integerValue];
    self.cancelOrderButton.enabled = NO;
    if (status == 1) { // 取消订单
        self.cancelOrderButton.enabled = YES;
        [_cancelOrderButton setTitle:@"取消订单" forState:UIControlStateNormal];
    } else if (status == 2) { // 待提货
        [_cancelOrderButton setTitle:@"待提货" forState:UIControlStateNormal];
    } else if (status == 3) { // 已提货
        [_cancelOrderButton setTitle:@"已提货" forState:UIControlStateNormal];
    } else { // 已取消
        [_cancelOrderButton setTitle:@"已取消" forState:UIControlStateNormal];
    }
    
    [self setNeedsLayout];
}

#pragma mark - Custom

- (void)cancelOrderButtonTouchUpInside:(UIButton *)sender {
    self.cancelOrderBlock();
}

#pragma mark - LazyLoad

- (UIView *)separatorLine {
    if (!_separatorLine) {
        _separatorLine = [UIView new];
        _separatorLine.backgroundColor = [UIColor colorSeparatorLine];
    }
    return _separatorLine;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
        [_iconImageView setImage:[UIImage imageNamed:@"FSMyOrder订单"]];
    }
    return _iconImageView;
}

- (UILabel *)orderNumberTitleLabel {
    if (!_orderNumberTitleLabel) {
        _orderNumberTitleLabel = [UILabel new];
        _orderNumberTitleLabel.text = @"订单号";
        _orderNumberTitleLabel.font = [UIFont systemFontOfSize:14];
        _orderNumberTitleLabel.textColor = [UIColor colorTextDomina];
    }
    return _orderNumberTitleLabel;
}

- (UILabel *)orderNumberLabel {
    if (!_orderNumberLabel) {
        _orderNumberLabel = [UILabel new];
        _orderNumberLabel.font = [UIFont systemFontOfSize:14];
        _orderNumberLabel.textColor = [UIColor colorTextDomina];
    }
    return _orderNumberLabel;
}

- (UIButton *)cancelOrderButton {
    if (!_cancelOrderButton) {
        _cancelOrderButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_cancelOrderButton setTitleColor:[UIColor colorDomina] forState:UIControlStateNormal];
        _cancelOrderButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _cancelOrderButton.enabled = NO;
        [_cancelOrderButton addTarget:self action:@selector(cancelOrderButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelOrderButton;
}


@end
