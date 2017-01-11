//
//  FSCommodityCVCell.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/15.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSCommodityCVCell.h"
#import "RightGoodsModel.h"
#import "UIButton+EnlargeEdge.h"

@interface FSCommodityCVCell ()



@end

@implementation FSCommodityCVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor whiteColor];
    self.topSeparatorLine.height = 0.5;
    self.topSeparatorLine.backgroundColor = [UIColor colorViewBG];
    
    self.bottomSeparatorLine.height = 0.5;
    self.bottomSeparatorLine.backgroundColor = [UIColor colorViewBG];
    
    self.rightSeparatorLine.width = 0.5;
    self.rightSeparatorLine.backgroundColor = [UIColor colorViewBG];
    
    [self.plusButton setEnlargeEdgeWithTop:10 right:5 bottom:10 left:5];
    [self.minusButton setEnlargeEdgeWithTop:10 right:5 bottom:10 left:5];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 分割线
    self.topSeparatorLine.width = self.width;
    
    self.bottomSeparatorLine.width = self.width;
    self.rightSeparatorLine.height = self.height;
    
    self.bottomSeparatorLine.x = 0;
    self.bottomSeparatorLine.bottom = self.height;
    
    self.rightSeparatorLine.y = 0;
    self.rightSeparatorLine.right = self.right;
    
    // image
    self.imageView.width = self.width - 16;
    self.imageView.height = self.width - 16;
    self.imageView.x = 8;
    self.imageView.y = 8;
    
    // title
    [self.titleLabel sizeToFit];
    self.titleLabel.width = self.imageView.width;
    self.titleLabel.x = self.imageView.x;
    self.titleLabel.y = self.imageView.bottom + 5;
    
    // desc
    [self.descLabel sizeToFit];
    self.descLabel.width = self.titleLabel.width;
    self.descLabel.x = self.titleLabel.x;
    self.descLabel.y = self.titleLabel.bottom + 5;
    
    // price
    [self.priceLabel sizeToFit];
    self.priceLabel.x = self.descLabel.x;
    self.priceLabel.bottom = self.height - 8;
    
    // plus button、minus button、count label
    self.plusButton.right = self.width - 8;
    self.plusButton.centerY = self.priceLabel.centerY;
    
    self.countLabel.width = 18;
    self.countLabel.right = self.plusButton.x - 5;
    self.countLabel.centerY = self.priceLabel.centerY;
    
    self.minusButton.right = self.countLabel.x - 5;
    self.minusButton.centerY = self.priceLabel.centerY;
}

- (void)setModel:(RightGoodsModel *)model {
    _model = model;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:_model.imgUrl] placeholderImage:[UIImage imageNamed:@"placeholderimage"]];
    
    self.titleLabel.text = _model.productName;
    self.descLabel.text = _model.shortDesc;
    
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", [_model.salePrice floatValue]];
    
    self.countLabel.text = _model.CartNum;
    
}

+ (CGFloat)height {
    CGFloat height = 0;
    if (ScreenWidth == 320) {
        height = 221.5f + 8;
    } else if (ScreenWidth == 375) {
        height = 249.0f + 8;
    } else if (ScreenWidth == 414) {
        height = 268.3f + 8;
    }
    
    return height;
    
}

- (IBAction)plusButtonTouchUpInside:(UIButton *)sender {
    
    // 当前购物车数量
    NSInteger cartNum = [self.model.CartNum integerValue];
    
    // 当前库存
    NSInteger stock = [self.model.stock integerValue];
    
    // 如果当前的购物车数量 + 1 大于 库存 就不让请求
    if ((cartNum + 1) > stock) {
        [SVProgressHUD showInfoWithStatus:@"库存不足!"];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(commodityCVCell:plusButtonTouchUpInside:)]) {
        [self.delegate commodityCVCell:self plusButtonTouchUpInside:sender];
    }
}


- (IBAction)minusButtonTouchUpInside:(UIButton *)sender {
    
    if ([self.model.CartNum integerValue] == 0) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(commodityCVCell:minusButtonTouchUpInside:)]) {
        [self.delegate commodityCVCell:self minusButtonTouchUpInside:sender];
    }
}
@end
