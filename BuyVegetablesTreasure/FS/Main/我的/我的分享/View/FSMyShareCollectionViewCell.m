//
//  FSMyShareCollectionViewCell.m
//  BuyVegetablesTreasure
//
//  Created by 江玉元 on 2017/4/11.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import "FSMyShareCollectionViewCell.h"
#import "FSMyShareModel.h"

@implementation FSMyShareCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.layer.cornerRadius = 5;
}

- (void)setModel:(FSMyShareModel *)model {
    _model = model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:_model.productImg_url] placeholderImage:[UIImage imageNamed:@"listPlaceHolder-"]];

}
@end
