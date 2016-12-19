//
//  New&HotTableViewCell.m
//  BuyVegetablesTreasure
//
//  Created by Song on 16/1/12.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "New&HotTableViewCell.h"

@implementation New_HotTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _ImageView=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 110, 110)];
        _ImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:_ImageView];
        
        _goodsNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(130, 0, SCREEN_WIDTH-170, 50)];
        _goodsNameLabel.textColor=[UIColor colorWithHexString:@"0x696969"];
        _goodsNameLabel.font=[UIFont systemFontOfSize:16];
        _goodsNameLabel.numberOfLines = 2;
        _goodsNameLabel.textAlignment=NSTextAlignmentLeft;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [_ImageView addGestureRecognizer:tap];
        
        _image=[[UIImageView alloc]initWithFrame:CGRectMake(130, CGRectGetMaxY(_goodsNameLabel.frame)-3,15, 15)];
        
        _originalPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, CGRectGetMaxY(_goodsNameLabel.frame)-5, SCREEN_WIDTH-190, 20)];
        _originalPriceLabel.textColor = [UIColor colorWithHexString:@"0x989898"];
        _originalPriceLabel.font=[UIFont systemFontOfSize:13];
        _originalPriceLabel.textAlignment=NSTextAlignmentLeft;
        _originalPriceLabel.backgroundColor = [UIColor clearColor];
        
        
        _goodsPriceLabel=[[UILabel alloc]initWithFrame:CGRectMake(130, CGRectGetMaxY(_originalPriceLabel.frame)+10, SCREEN_WIDTH-210, 30)];
        _goodsPriceLabel.textColor=[UIColor colorWithHexString:@"0xff6600"];
        _goodsPriceLabel.font=[UIFont systemFontOfSize:16];
        _goodsPriceLabel.textAlignment=NSTextAlignmentLeft;
        
        UIButton *_button=[UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame=CGRectMake(SCREEN_WIDTH-90, CGRectGetMaxY(_originalPriceLabel.frame), 90, 120-CGRectGetMaxY(_originalPriceLabel.frame));
        [_button setImage:IMAGE(@"购物车") forState:UIControlStateNormal];
        _button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 15, 0);
        [_button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *_lineView1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        _lineView1.backgroundColor=[UIColor colorWithHexString:@"0xD7D7D7"];
        _lineView1.alpha = 0.3;
        
        UIView *_lineView2=[[UIView alloc]initWithFrame:CGRectMake(0, 119, SCREEN_WIDTH, 1)];
        _lineView2.backgroundColor=[UIColor colorWithHexString:@"0xD7D7D7"];
        _lineView2.alpha = 0.3;
        
        [self.contentView addSubview:_goodsNameLabel];
        [self.contentView addSubview:_image];
        [self.contentView addSubview:_goodsPriceLabel];
        [self.contentView addSubview:_originalPriceLabel];
        [self.contentView addSubview:_button];
        [self.contentView addSubview:_lineView1];
        [self.contentView addSubview:_lineView2];
    }
    return self;
}

- (void)tap:(UITapGestureRecognizer *)tap {
    
    _imageClick(_model);
}


-(void)setData:(NewPruduct *)model isNewPruduct:(NSString *)isNewPruduct
{
    
    _model = model;
    
    [_ImageView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:IMAGE(@"列表页未成功图片")];
    _goodsNameLabel.text=model.productName;
    if ([isNewPruduct isEqualToString:@"1"])
    {
        _originalPriceLabel.text = model.categoryName;
        
        _image.image = IMAGE(@"Home_hot_goods_re");
    }
    else
    {
        _originalPriceLabel.text = model.specialOfferContext;
        _image.image = IMAGE(@"lmbec_special_hot_goods_cu");
    }
    _goodsPriceLabel.text=[NSString stringWithFormat:@"￥ %.2f",[model.salePrice floatValue]];
}
-(void)clickButton:(UIButton *)sender
{
    _addCart();
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
