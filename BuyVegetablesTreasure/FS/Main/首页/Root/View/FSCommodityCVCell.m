//
//  FSCommodityCVCell.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/15.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSCommodityCVCell.h"
#import "RightGoodsModel.h"

@interface FSCommodityCVCell ()
/// 商品图片
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
/// 商品标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/// 商品价格
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
/// 商品简介
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
/// 购物车数量
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
/// 添加至购物车按钮
@property (weak, nonatomic) IBOutlet UIButton *plusButton;
/// 减少商品按钮
@property (weak, nonatomic) IBOutlet UIButton *minusButton;


@end

@implementation FSCommodityCVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.leftSeparatorLine.width = 0.5;
    self.leftSeparatorLine.backgroundColor = [UIColor colorViewBG];
    
    self.topSeparatorLine.height = 0.5;
    self.topSeparatorLine.backgroundColor = [UIColor colorViewBG];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 分割线
    self.leftSeparatorLine.height = self.height;
    self.topSeparatorLine.width = self.width;
    
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
    self.priceLabel.y = self.descLabel.bottom + 5;
    
    // plus button、minus button、count label
    self.plusButton.right = self.width - 8;
    self.plusButton.centerY = self.priceLabel.centerY;
    
    [self.countLabel sizeToFit];
    self.countLabel.right = self.plusButton.x - 8;
    self.countLabel.centerY = self.priceLabel.centerY;
    
    self.minusButton.right = self.countLabel.x - 8;
    self.minusButton.centerY = self.priceLabel.centerY;
    
}

- (void)setModel:(RightGoodsModel *)model {
    _model = model;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:_model.imgUrl]];
    
    self.titleLabel.text = _model.productName;
    self.descLabel.text = _model.shortDesc;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@", _model.salePrice];
    
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
    
    if (self.model.CartNum == 0) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(commodityCVCell:minusButtonTouchUpInside:)]) {
        [self.delegate commodityCVCell:self minusButtonTouchUpInside:sender];
    }
}
@end
