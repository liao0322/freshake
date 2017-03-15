//
//  FSMyCouponsViewCell.m
//  BuyVegetablesTreasure
//
//  Created by 江玉元 on 2017/3/14.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import "FSMyCouponsViewCell.h"

@interface FSMyCouponsViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;
@property (weak, nonatomic) IBOutlet UIImageView *selectImgView;
@property (weak, nonatomic) IBOutlet UIImageView *shiXiaoImgView;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *guiZeLabel;

@end

@implementation FSMyCouponsViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

}
- (void)setModel:(CouponModel *)model {
    _model = model;
    if (![_model.hasLingQu boolValue] && ([_model.IsExpileDate boolValue] || [_model.IsExpileDate intValue] == 2)) {
        UIImage *bgImage = IMAGE(@"FS优惠券");
        self.bgImgView.image = bgImage;
        self.shiXiaoImgView.hidden = YES;
        self.priceLabel.textColor = [UIColor colorOrange];
        self.guiZeLabel.textColor = [UIColor colorOrange];
        self.couponNameLabel.textColor = [UIColor colorWithHexString:@"0x404040"];
    } else {
        UIImage *bgImage = IMAGE(@"FS优惠券-已失效");
        self.bgImgView.image = bgImage;
        self.priceLabel.textColor = [UIColor colorWithHexString:@"0xb2b2b2"];
        self.couponNameLabel.textColor = [UIColor colorWithHexString:@"0xb2b2b2"];
        self.guiZeLabel.hidden = YES;
    }
    
    self.selectImgView.hidden = _model.isSelect ? NO : YES;
    self.priceLabel.hidden = [_model.typeId intValue] == 1 ? YES : NO;
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@\n%@", _model.beginDate,_model.ExpileDate];
    self.couponNameLabel.text = [NSString stringWithFormat:@"%@",_model.TickName];
    self.guiZeLabel.text = [NSString stringWithFormat:@"满%@元使用", _model.consumeMoney];
    
    [self setAttributtedStringWithString:model.Price textColor:self.priceLabel.textColor];
    
}

- (void)setAttributtedStringWithString:(NSString *)string textColor:(UIColor *)color {
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@元",string]];
    [attributeString setAttributes:@{NSForegroundColorAttributeName : color, NSFontAttributeName : [UIFont boldSystemFontOfSize:(SCREEN_WIDTH == 320 ? 24 : 26)]} range:NSMakeRange(1, string.length)];
    self.priceLabel.attributedText = attributeString;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
