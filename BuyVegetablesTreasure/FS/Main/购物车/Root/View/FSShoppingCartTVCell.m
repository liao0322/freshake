//
//  FSShoppingCartTVCell.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/20.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSShoppingCartTVCell.h"
#import "ShopCart.h"

@interface FSShoppingCartTVCell ()

@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *minusButton;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIButton *plusButton;

@end

@implementation FSShoppingCartTVCell

#pragma mark - LifeCycle

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
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
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



#pragma mark - Override

- (void)setModel:(ShopCart *)model {
    _model = model;
    
    self.selectButton.selected = YES;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:_model.thumbnailsUrll] placeholderImage:[UIImage imageWithColor:[UIColor colorViewBG]]];
    
    [self.titleLabel setText:_model.productName];
    [self.descLabel setText:_model.Specifications];
    [self.priceLabel setText:[NSString stringWithFormat:@"￥%@", _model.salePrice]];
    [self.countLabel setText:[NSString stringWithFormat:@"%ld", [_model.productNum integerValue]]];
    
    
    
}

#pragma mark - Custom

- (IBAction)plusButtonTouchUpInside:(UIButton *)sender {
    NSLog(@"加");
}

- (IBAction)minusButtonTouchUpInside:(UIButton *)sender {
    NSLog(@"减");

}

- (IBAction)selectButtonTouchUpInside:(UIButton *)sender {
    NSLog(@"选择");

}
@end
