//
//  FSShowImageCVCell.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2017/4/17.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import "FSShowImageCVCell.h"
#import "FSMyShareModel.h"
#import <Masonry.h>

@interface FSShowImageCVCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@end

@implementation FSShowImageCVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}

- (void)setModel:(FSMyShareModel *)model {
    _model = model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:_model.productImg_url] placeholderImage:[UIImage imageNamed:@"logoPlaceHolder"]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.heightConstraint.constant = 1920 / (1080.0f / self.iconImageView.width);
    self.iconImageView.layer.cornerRadius = 20;

}

- (IBAction)shareButtonAction:(id)sender {
    if (self.ToShareBlock) {
        self.ToShareBlock();
    }
}




@end
