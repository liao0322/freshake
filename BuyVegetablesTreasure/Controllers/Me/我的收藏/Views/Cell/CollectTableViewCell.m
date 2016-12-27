//
//  CollectTableViewCell.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/5/4.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "CollectTableViewCell.h"

@implementation CollectTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        int spacing = 15;
        
        // 商品图片
        _goodsImageView = [UIImageView new];
        [self.contentView addSubview:_goodsImageView];
        
        _goodsImageView.sd_layout
        .leftSpaceToView(self.contentView, spacing)
        .topSpaceToView(self.contentView, spacing)
        .widthIs(80)
        .heightIs(80);
        
        // 商品名称
        _goodsNameLabel = [UILabel new];
        _goodsNameLabel.font = [UIFont systemFontOfSize:16.0];
        _goodsNameLabel.textColor = [UIColor colorWithHexString:@"0x404040"];
        [self.contentView addSubview:_goodsNameLabel];
        
        _goodsNameLabel.sd_layout
        .leftSpaceToView(_goodsImageView, spacing)
        .rightSpaceToView(self.contentView , spacing)
        .topSpaceToView(self.contentView, 20)
        .heightIs(17);
        
        // 立即购买按钮
        _goPlayBtn = [UIButton new];
        _goPlayBtn.layer.cornerRadius = 5;
//        _goPlayBtn.layer.borderWidth = 1;
//        _goPlayBtn.layer.borderColor = [Color CGColor];
        _goPlayBtn.backgroundColor = [UIColor colorDomina];
        _goPlayBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [_goPlayBtn setTitle:@"立即购买" forState:UIControlStateNormal];
        [_goPlayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_goPlayBtn addTarget:self action:@selector(goPay) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_goPlayBtn];
        
        _goPlayBtn.sd_layout
        .bottomSpaceToView(self.contentView, spacing)
        .rightSpaceToView(self.contentView, spacing)
        .widthIs(85)
        .heightIs(27);
        
        // 商品价格
        _goodsPriceLabel = [UILabel new];
        _goodsPriceLabel.font = [UIFont systemFontOfSize:18.0];
        _goodsPriceLabel.textColor = [UIColor colorOrange];
        [self.contentView addSubview:_goodsPriceLabel];
        
        _goodsPriceLabel.sd_layout
        .leftSpaceToView(_goodsImageView, spacing)
        .rightSpaceToView(_goPlayBtn, spacing)
        .bottomSpaceToView(self.contentView, 20)
        .heightIs(19);
        
        _deleteView = [UIView new];
        _deleteView.backgroundColor = [UIColor colorOrange];
        [self.contentView addSubview:_deleteView];
        
        _deleteView.sd_layout
        .leftSpaceToView(self.contentView, ScreenWidth)
        .topSpaceToView(self.contentView, 0)
        .widthIs(ScreenWidth)
        .heightIs(CGRectGetHeight(_goodsImageView.frame) + spacing * 2);
        
        _deleteImg = [UIImageView new];
        _deleteImg.image = IMAGE(@"收藏删除");
        [_deleteView addSubview:_deleteImg];
        
        _deleteImg.sd_layout
        .leftSpaceToView(_deleteView, 25)
        .centerYIs(CGRectGetHeight(_deleteView.frame) / 2)
        .widthIs(20)
        .heightIs(26);

        [self setupAutoHeightWithBottomView:_goodsImageView bottomMargin:spacing];
    }
    
    return self;
}

- (void)setModel:(MyCollectModel *)model {
    
    NSString *groupId = [[NSUserDefaults standardUserDefaults] objectForKey:@"group_id"];
    NSString *priceString;
    
    if ([groupId intValue] > 1) {
        priceString = [NSString stringWithFormat:@"会员价:¥%.2f",[model.UserPrice floatValue]];
    }
    else {
        priceString = [NSString stringWithFormat:@"￥%.2f",[model.price floatValue]];
    }
    
    
    _goodsNameLabel.text = model.productName;
    _goodsPriceLabel.hidden = NO;
    _goodsPriceLabel.text = priceString;
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:IMAGE(@"列表页未成功图片")];
}

- (void)goPay {
    _goPayViewController();
}

- (void)setVedioModel:(CookingProgramListModel *)model {
    
    _goPlayBtn.hidden = YES;
    _goodsPriceLabel.hidden = YES;
    _goodsNameLabel.text = model.Title;
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:LMMC(model.pic)] placeholderImage:IMAGE(@"列表页未成功图片")];
}

@end
