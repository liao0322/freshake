//
//  MyCollectTableViewCell.m
//  BuyVegetablesTreasure
//
//  Created by XiaoBeiMAC on 15/12/10.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import "MyCollectTableViewCell.h"

@implementation MyCollectTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        UIView *_goodsView=[[UIView alloc]initWithFrame:CGRectMake(10, 10, 80, 80)];
//        _goodsView.layer.borderWidth=1;
//        _goodsView.layer.borderColor=[[UIColor colorWithHexString:@"0xD7D7D7"] CGColor];
        
        _ImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
        [_goodsView addSubview:_ImageView];
        
        _goodsNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(110, 0, SCREEN_WIDTH-150, 50)];
        _goodsNameLabel.textColor=[UIColor colorWithHexString:@"0x696969"];
        _goodsNameLabel.font=[UIFont systemFontOfSize:16];
        _goodsNameLabel.numberOfLines = 2;
        _goodsNameLabel.textAlignment=NSTextAlignmentLeft;
        
        _goodsPriceLabel=[[UILabel alloc]initWithFrame:CGRectMake(110, 50, SCREEN_WIDTH-150, 30)];
        _goodsPriceLabel.textColor=[UIColor colorWithHexString:@"0xff6600"];
        _goodsPriceLabel.font=[UIFont systemFontOfSize:16];
        _goodsPriceLabel.textAlignment=NSTextAlignmentLeft;
        
        
        UIButton *_Cbutton=[UIButton buttonWithType:UIButtonTypeCustom];
        _Cbutton.frame=CGRectMake(SCREEN_WIDTH-80, 60, 60, 30);
        [_Cbutton setTitle:@"立即购买" forState:UIControlStateNormal];
        _Cbutton.titleLabel.font=[UIFont systemFontOfSize:12];
        [_Cbutton setTitleColor:[UIColor colorWithHexString:@"0xff6600"] forState:UIControlStateNormal];
        [_Cbutton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        _Cbutton.layer.borderWidth=1.0;
        _Cbutton.layer.borderColor=[[UIColor colorWithHexString:@"0xff6600"] CGColor];
        _Cbutton.layer.cornerRadius=7;
        
        
        UIView *_lineView1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        _lineView1.backgroundColor=[UIColor colorWithHexString:@"0xD7D7D7"];
        _lineView1.alpha = 0.7;
        
        UIView *_lineView2=[[UIView alloc]initWithFrame:CGRectMake(0, 99, SCREEN_WIDTH, 1)];
        _lineView2.backgroundColor=[UIColor colorWithHexString:@"0xD7D7D7"];
        _lineView2.alpha = 0.7;
        
        [self.contentView addSubview:_goodsView];
        [self.contentView addSubview:_goodsNameLabel];
        [self.contentView addSubview:_goodsPriceLabel];
        [self.contentView addSubview:_Cbutton];
        [self.contentView addSubview:_lineView1];
        [self.contentView addSubview:_lineView2];
        
        //覆盖系统的delete视图
        _deleteView=[[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, 100)];
        _deleteView.backgroundColor=[UIColor colorWithHexString:@"0xff6600"];
        [self.contentView addSubview:_deleteView];
        
        UIImageView *_img=[[UIImageView alloc]initWithFrame:CGRectMake(25, 37, 20, 26)];
        _img.image=IMAGE(@"收藏删除");
        [_deleteView addSubview:_img];
        
        
        //[_deleteView addSubview:deleteBtn];
    }
    return self;
    
}
-(void)setMyCollectModel:(MyCollectModel *)model{
    [_ImageView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:IMAGE(@"列表页未成功图片")];
    _goodsNameLabel.text=model.productName;
    _goodsPriceLabel.text=[NSString stringWithFormat:@"￥ %.2f",[model.price floatValue]];
}
-(void)clickButton:(UIButton *)sender{
    _payNow();
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
