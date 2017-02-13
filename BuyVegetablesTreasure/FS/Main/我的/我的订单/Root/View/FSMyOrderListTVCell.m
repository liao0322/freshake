//
//  FSMyOrderListTVCell.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2017/1/24.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import "FSMyOrderListTVCell.h"
#import "Order.h"

@interface FSMyOrderListTVCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation FSMyOrderListTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"thumbnailsUrll"]] placeholderImage:IMAGE(@"列表页未成功图片")];
    
    self.titleLabel.text = dict[@"goods_title"];
    
    self.unitLabel.text = dict[@"unit"];
    
    self.countLabel.text = [NSString stringWithFormat:@" x %@", dict[@"quantity"]];
    
    NSString *priceString = [NSString stringWithFormat:@"￥%.2f",[dict[@"goods_price"] floatValue]];
    self.priceLabel.text = priceString;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
