//
//  FSShoppingCartTVCell.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/20.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSShoppingCartTVCell.h"
#import "ShopCart.h"
#import "UIButton+EnlargeEdge.h"

@interface FSShoppingCartTVCell ()

@property (nonatomic) UIView *maskView;

@end

@implementation FSShoppingCartTVCell

#pragma mark - LifeCycle

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.plusButton setEnlargeEdgeWithTop:10 right:5 bottom:10 left:5];
    [self.minusButton setEnlargeEdgeWithTop:10 right:5 bottom:10 left:5];
    
    [self.selectButton setImage:[UIImage imageNamed:@"shoppingcart_disabled"] forState:UIControlStateDisabled];
    
    [self.contentView addSubview:self.maskView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = self.width;
    CGFloat height = self.height;
    CGFloat spacing = 8.0f;

    
    // 选择按钮
    self.selectButton.width = 44;
    self.selectButton.height = height - spacing * 2;
    self.selectButton.x = 0;
    self.selectButton.y = spacing;
    
    // icon
    self.iconImageView.height = self.selectButton.height;
    self.iconImageView.width = self.selectButton.height;
    self.iconImageView.centerY = self.selectButton.centerY;
    self.iconImageView.x = self.selectButton.right;
    
    // title
    self.titleLabel.width = width - CGRectGetMaxX(self.iconImageView.frame) - spacing * 2;
    self.titleLabel.x = self.iconImageView.right + spacing;
    self.titleLabel.y = self.iconImageView.y;
    
    // price
    [self.priceLabel sizeToFit];
    self.priceLabel.x = self.titleLabel.x;
    self.priceLabel.bottom = self.iconImageView.bottom;
    
    // desc
    self.descLabel.width = self.titleLabel.width;
    self.descLabel.x = self.titleLabel.x;
    self.descLabel.bottom = self.priceLabel.y - 5;
    
    // plus
    self.plusButton.right = width - spacing;
    self.plusButton.centerY = self.priceLabel.centerY - 10;
    
    self.countLabel.centerY = self.plusButton.centerY;
    self.countLabel.right = self.plusButton.x;
    
    self.minusButton.centerY = self.plusButton.centerY;
    self.minusButton.right = self.countLabel.x;
    
    self.maskView.frame = self.bounds;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



#pragma mark - Override

- (void)setModel:(ShopCart *)model {
    _model = model;
    
    if (![model.upselling isEqualToString:@"1"]) { // 已下架
        [self.selectButton setImage:[UIImage imageNamed:@"已下架"] forState:UIControlStateDisabled];
    } else if ([model.stock integerValue] == 0) { // 已售罄
        [self.selectButton setImage:[UIImage imageNamed:@"已售罄"] forState:UIControlStateDisabled];
    } else {
        [self.selectButton setImage:nil forState:UIControlStateDisabled];
    }
    
    if (_model.isInvalid) { // 无效
        self.selectButton.enabled = NO;
        self.selectButton.selected = NO;
        self.plusButton.enabled = NO;
        self.minusButton.enabled = NO;
        
        self.maskView.hidden = NO;
        
        self.plusButton.hidden = YES;
        self.minusButton.hidden = YES;
        self.countLabel.hidden = YES;
        
        [self.priceLabel setTextColor:[UIColor lightGrayColor]];
        
        [self.titleLabel setTextColor:[UIColor lightGrayColor]];
        
    } else {
        self.selectButton.enabled = YES;
        self.selectButton.selected = _model.isSelect;
        
        self.plusButton.enabled = YES;
        self.minusButton.enabled = YES;
        
        self.maskView.hidden = YES;
        
        self.plusButton.hidden = NO;
        self.minusButton.hidden = NO;
        self.countLabel.hidden = NO;
        
        [self.priceLabel setTextColor:[UIColor orangeColor]];
        [self.titleLabel setTextColor:[UIColor colorWithRed:40/255.0f green:40/255.0f blue:40/255.0f alpha:1.0f]];

    }
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:_model.thumbnailsUrll] placeholderImage:[UIImage imageNamed:@"placeholderimage"]];
    
    [self.titleLabel setText:_model.productName];
    [self.descLabel setText:_model.Specifications];
    [self.priceLabel setText:[NSString stringWithFormat:@"￥%.1f", [_model.salePrice floatValue]]];
    [self.countLabel setText:[NSString stringWithFormat:@"%ld", [_model.productNum integerValue]]];
    
}

#pragma mark - Custom

- (IBAction)plusButtonTouchUpInside:(UIButton *)sender {
    // 当前购物车数量
    NSInteger cartNum = [self.model.productNum integerValue];
    
    // 当前库存
    NSInteger stock = [self.model.stock integerValue];
    
    // 如果当前的购物车数量 + 1 大于 库存 就不让请求
    if ((cartNum + 1) > stock) {
        [SVProgressHUD showInfoWithStatus:@"库存不足!"];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(shoppingCartTVCell:plusButtonTouchUpInside:)]) {
        [self.delegate shoppingCartTVCell:self plusButtonTouchUpInside:sender];
    }
}

- (IBAction)minusButtonTouchUpInside:(UIButton *)sender {
    if ([self.model.productNum integerValue] == 0) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(shoppingCartTVCell:minusButtonTouchUpInside:)]) {
        [self.delegate shoppingCartTVCell:self minusButtonTouchUpInside:sender];
    }

}

- (IBAction)selectButtonTouchUpInside:(UIButton *)sender {
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(shoppingCartTVCell:selectButtonTouchUpInside:)]) {
        [self.delegate shoppingCartTVCell:self selectButtonTouchUpInside:sender];
    }

}

#pragma mark - LazyLoad

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [UIView new];
        _maskView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:.05f];
        _maskView.hidden = YES;
    }
    return _maskView;
}
@end
