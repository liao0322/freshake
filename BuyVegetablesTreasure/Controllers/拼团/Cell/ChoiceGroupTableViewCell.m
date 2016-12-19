//
//  ChoiceGroupTableViewCell.m
//  BuyVegetablesTreasure
//
//  Created by XiaoBeiMAC on 15/11/27.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import "ChoiceGroupTableViewCell.h"

@implementation ChoiceGroupTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        UIView *_goodsView=[[UIView alloc]initWithFrame:CGRectMake(20, 10, 80, 80)];
        _goodsView.layer.borderWidth=1;
        _goodsView.layer.borderColor=[[UIColor colorWithHexString:@"0xD7D7D7"] CGColor];
        
        _thumbnailsUrllImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
        _thumbnailsUrllImageView.image=IMAGE(@"下载图片为空2.jpg");
        [_goodsView addSubview:_thumbnailsUrllImageView];
        
        _goodsNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(110, 10, SCREEN_WIDTH-130, 20)];
        _goodsNameLabel.textColor=[UIColor colorWithHexString:@"0x5a5a5a"];
        _goodsNameLabel.font=[UIFont systemFontOfSize:14];
        _goodsNameLabel.text=@"番茄 无公害新鲜蔬菜 西红柿";
        _goodsNameLabel.textAlignment=NSTextAlignmentLeft;
        
        _goodsTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(110, 30, SCREEN_WIDTH-130, 20)];
        _goodsTitleLabel.textColor=[UIColor colorWithHexString:@"0x5a5a5a"];
        _goodsTitleLabel.font=[UIFont systemFontOfSize:14];
        _goodsTitleLabel.text=@"洋柿子 500g";
        _goodsTitleLabel.textAlignment=NSTextAlignmentLeft;
        
        _real_priceLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-100, 70, 80, 20)];
        _real_priceLabel.textColor=[UIColor colorWithHexString:@"0xfc9d15"];
        _real_priceLabel.font=[UIFont systemFontOfSize:14];
        _real_priceLabel.text=@"￥9.90";
        _real_priceLabel.textAlignment=NSTextAlignmentRight;
        
        _goodsNumLabel=[[UILabel alloc]initWithFrame:CGRectMake(110, 70, SCREEN_WIDTH-220, 20)];
        _goodsNumLabel.textColor=[UIColor colorWithHexString:@"0x989898"];
        _goodsNumLabel.text=@"数量1份";
        _goodsNumLabel.font=[UIFont systemFontOfSize:14];
        
        UIView *_lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 99, SCREEN_WIDTH, 1)];
        _lineView.backgroundColor=[UIColor colorWithHexString:@"0xD7D7D7"];
        
        [self.contentView addSubview:_goodsView];
        [self.contentView addSubview:_goodsNameLabel];
        [self.contentView addSubview:_goodsTitleLabel];
        [self.contentView addSubview:_real_priceLabel];
        [self.contentView addSubview:_goodsNumLabel];
        [self.contentView addSubview:_lineView];
    }
    return self;
    
}

- (void)awakeFromNib {
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}

@end
