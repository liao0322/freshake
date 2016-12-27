//
//  FSMyCollectTableViewCell.m
//  BuyVegetablesTreasure
//
//  Created by 江玉元 on 2016/12/23.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSMyCollectTableViewCell.h"

@implementation FSMyCollectTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creteView];
    }
    return self;
}

- (void)creteView {
    
    int margin = 15;
    
    // 商品图片
    _goodsImageView = [UIImageView new];
    [self.contentView addSubview:_goodsImageView];
    
    _goodsImageView.sd_layout
    .leftSpaceToView(self.contentView, margin)
    .topSpaceToView(self.contentView, 20)
    .widthIs(105)
    .heightIs(100);
    
    // 商品名称
    _goodsNameLabel = [UILabel new];
    _goodsNameLabel.font = [UIFont systemFontOfSize:16.0];
    _goodsNameLabel.textColor = [UIColor colorWithHexString:@"0x404040"];
    [self.contentView addSubview:_goodsNameLabel];
    
    _goodsNameLabel.sd_layout
    .leftSpaceToView(_goodsImageView, margin*3)
    .rightSpaceToView(self.contentView, margin)
    .topSpaceToView(self.contentView, margin)
    .heightIs(18);
    
    // 立即购买按钮
    _goBuyBtn = [UIButton new];
    _goBuyBtn.layer.cornerRadius = 5;
    _goBuyBtn.backgroundColor = [UIColor colorWithHexString:@"0x88bb35"];
    _goBuyBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [_goBuyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [_goBuyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_goBuyBtn addTarget:self action:@selector(goBuy:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_goBuyBtn];
    
    _goBuyBtn.sd_layout
    .bottomSpaceToView(self.contentView, margin)
    .rightSpaceToView(self.contentView, margin)
    .widthIs(85)
    .heightIs(27);
    
    // 商品价格
    _goodsPriceLabel = [UILabel new];
    _goodsPriceLabel.font = [UIFont systemFontOfSize:18.0];
    _goodsPriceLabel.textColor = [UIColor colorOrange];
    [self.contentView addSubview:_goodsPriceLabel];
    
    _goodsPriceLabel.sd_layout
    .leftSpaceToView(_goodsImageView, margin*2)
    .rightSpaceToView(_goBuyBtn, margin)
    .bottomSpaceToView(self.contentView, 25)
    .heightIs(20);
    
    _deleteView = [UIView new];
    _deleteView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_deleteView];
    
    _deleteView.sd_layout
    .leftSpaceToView(self.contentView, ScreenWidth)
    .topSpaceToView(self.contentView, 0)
    .widthIs(ScreenWidth)
    .heightIs(CGRectGetHeight(_goodsImageView.frame) + 40);
    
    _deleteImg = [UIImageView new];
    _deleteImg.image = IMAGE(@"收藏删除");
    [_deleteView addSubview:_deleteImg];
    
    _deleteImg.sd_layout
    .leftSpaceToView(_deleteView, 25)
    .centerYIs(CGRectGetHeight(_deleteView.frame) / 2)
    .widthIs(20)
    .heightIs(26);
    
    [self setupAutoHeightWithBottomView:_goodsImageView bottomMargin:margin];
    
}

- (void)setModel:(FSMyCollectModel *)model
{
    NSString *groupId = [[NSUserDefaults standardUserDefaults] objectForKey:@"group_id"];
    NSString *priceString;
    
    if ([groupId intValue] > 1) {
        priceString = [NSString stringWithFormat:@"会员价:￥%.2f", [model.UserPrice floatValue]];
    }
    else {
        priceString = [NSString stringWithFormat:@"￥%2.f", [model.price floatValue]];
    }
    
    _goodsNameLabel.text = model.productName;
    _goodsPriceLabel.hidden = NO;
    _goodsPriceLabel.text = priceString;
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:IMAGE(@"列表页未成功图片")];
}

- (void)goBuy:(UIButton *)sender {
    NSLog(@"立即购买");
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
