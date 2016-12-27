//
//  GroupGoodsCell.m
//  BuyVegetablesTreasure
//
//  Created by Kai on 16/4/6.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "GroupGoodsCell.h"

@implementation GroupGoodsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initCell];
    }
    return self;
}

- (void)initCell {
    
    UIView *goodsView = [[UIView alloc]initWithFrame:CGRectMake(20, 10, 80, 80)];
    [self.contentView addSubview:goodsView];
    
    _thumbnailsUrllImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    [goodsView addSubview:_thumbnailsUrllImageView];
    
    _goodsNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 10, SCREEN_WIDTH-130, 20)];
    _goodsNameLabel.textColor = [UIColor colorWithHexString:@"0x404040"];
    _goodsNameLabel.font = [UIFont systemFontOfSize:14];
    _goodsNameLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_goodsNameLabel];
    
    _goodsTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 30, SCREEN_WIDTH-130, 20)];
    _goodsTitleLabel.textColor = [UIColor colorWithHexString:@"0x404040"];
    _goodsTitleLabel.font = [UIFont systemFontOfSize:14];
    _goodsTitleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_goodsTitleLabel];

    _goodsNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 70, SCREEN_WIDTH - 130, 20)];
    _goodsNumLabel.textColor = [UIColor colorWithHexString:@"0x404040"];
    _goodsNumLabel.text = @"5人团  ¥9.9元／份";
    _goodsNumLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_goodsNumLabel];
    
    _isSuccessImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"FSPT拼团成功"]];
    _isSuccessImageView.frame = CGRectMake(ScreenWidth - 95, 22, 82, 54);
    [self.contentView addSubview:_isSuccessImageView];
    
    for (int i = 0; i < 2; i++) {
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, (CGRectGetHeight(goodsView.frame) + 19) * i, ScreenWidth, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"0xE2E2E2"];
        [self.contentView addSubview:line];
    }
}

- (void)setGroupModel:(MyGroupModel *)model {
    
    [_thumbnailsUrllImageView sd_setImageWithURL:[NSURL URLWithString:model.thumbnailsUrll] placeholderImage:IMAGE(@"下载图片为空2.jpg")];
    [_isSuccessImageView setImage:[model.IsPay boolValue] ? IMAGE(@"FSPT已支付") : IMAGE(@"FSPT未支付")];
    _goodsTitleLabel.text = model.productName;
    _goodsNumLabel.text = [NSString stringWithFormat:@"%@人团  ¥%.2f元／%@",model.ActivityUserNum, [model.ActivityPrice floatValue], model.Specifications];
}

@end
