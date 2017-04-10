//
//  FSShowCouponTVCell.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2017/4/5.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import "FSShowCouponTVCell.h"
#import "FSHomeCouponModel.h"

@interface FSShowCouponTVCell ()
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@end

@implementation FSShowCouponTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(FSHomeCouponModel *)model {
    _model = model;
    self.priceLabel.text = _model.Price;
    self.titleLabel.text = _model.TickName;
    self.endDateLabel.text = [NSString stringWithFormat:@"有效期至%@", _model.endDate];
    self.descLabel.text = [NSString stringWithFormat:@"满%@元使用", _model.consumeMoney];
}

@end
