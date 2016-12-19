//
//  MyGroupTableViewCell.m
//  BuyVegetablesTreasure
//
//  Created by ky on 15/11/27.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import "MyGroupTableViewCell.h"

@implementation MyGroupTableViewCell
{
    UIView  *backView1;
    UIView  *backView2;
    UIView  *backView3;
    
    UIImageView *imageView;
    UILabel *orderLabel;
    UILabel *_total;
    
    
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
-(void)setupUI
{
    
    backView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55)];
    backView1.backgroundColor = [UIColor whiteColor];
    [self addSubview:backView1];
    
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 17, 20, 20)];
    imageView.image = IMAGE(@"拼团图标");
    [backView1 addSubview:imageView];
    
    orderLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) +10, 12.5, SCREEN_WIDTH - 14.0f, 30)];
    orderLabel.font = [UIFont systemFontOfSize:17.0f];
    orderLabel.textColor = [UIColor colorWithHexString:@"0x606060"];
    [backView1 addSubview:orderLabel];

    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 54, SCREEN_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"0xD5D5D5"];
    line.alpha = 0.5;
    [backView1 addSubview:line];
    
}
-(void)setData:(Order *)model
{
    orderLabel.text = [NSString stringWithFormat:@"%@",model.order_no];
    
    for (int i = 0; i < model.List.count; i++)
    {
        backView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 55 +110*i, SCREEN_WIDTH, 110)];
        backView2.backgroundColor = [UIColor whiteColor];
        [self addSubview:backView2];
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15.0f, 9.0f, 90.0f, 90.0f)];
        [iconImageView sd_setImageWithURL:[NSURL URLWithString:model.List[i][@"thumbnailsUrll"]] placeholderImage:IMAGE(@"列表页未成功图片")];
        [backView2 addSubview:iconImageView];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImageView.frame) + 10, 9.0f, SCREEN_WIDTH - 82.0f, 30.0f)];
        nameLabel.text = model.List[i][@"goods_title"];
        nameLabel.font = [UIFont systemFontOfSize:16.0f];
        nameLabel.numberOfLines = 2;
        nameLabel.textColor = [UIColor colorWithHexString:@"0x696969"];
        [backView2 addSubview:nameLabel];
        
        UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImageView.frame) + 10, CGRectGetMaxY(nameLabel.frame) + 22, SCREEN_WIDTH - 80.0f, 30.0f)];
        numLabel.text = [NSString stringWithFormat:@"数量%@份",@"2"];
        numLabel.font = [UIFont systemFontOfSize:16.0f];
        numLabel.textAlignment = NSTextAlignmentLeft;
        numLabel.textColor = [UIColor colorWithHexString:@"0x606060"];
        [backView2 addSubview:numLabel];
        
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 150,CGRectGetMinY(numLabel.frame), 138, 30.0f)];
        priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[model.List[i][@"goods_price"] floatValue]];
        priceLabel.font = [UIFont systemFontOfSize:16.0f];
        priceLabel.textAlignment = NSTextAlignmentRight;
        priceLabel.textColor = [UIColor colorWithHexString:@"0xfc9d15"];
        [backView2 addSubview:priceLabel];
        

        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 109, SCREEN_WIDTH, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"0xD5D5D5"];
        line.alpha = 0.5;
        [backView2 addSubview:line];
    }
    
    backView3 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(backView2.frame), SCREEN_WIDTH, 80)];
    backView3.backgroundColor = [UIColor whiteColor];
    [self addSubview:backView3];
    
    UILabel *numlabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH-180, 30)];
    numlabel.text = [NSString stringWithFormat:@"共%@份",model.order_amount];
    numlabel.font = [UIFont systemFontOfSize:15];
    numlabel.textColor = [UIColor colorWithHexString:@"0x999999"];
    [backView3 addSubview:numlabel];
    
    _total = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(numlabel.frame), SCREEN_WIDTH-180, 30)];
    _total.text = [NSString stringWithFormat:@"实付:%@元/份",model.order_amount];
    _total.textColor = [UIColor colorWithHexString:@"0xfc9d15"];
    _total.font = [UIFont systemFontOfSize:15];
    [backView3 addSubview:_total];
    
    
    //开团按钮
    _typeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _typeBtn.frame = CGRectMake(SCREEN_WIDTH -80, 20, 70, 35);
    _typeBtn.tag = [model.Id integerValue];
    
    [_typeBtn setBackgroundImage:IMAGE(@"拼团背景") forState:UIControlStateNormal];
    
    _typeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_typeBtn setTitleColor:[UIColor colorWithHexString:@"0xff6600"] forState:UIControlStateNormal];
    [backView3 addSubview:_typeBtn];
    [_typeBtn setTitle:@"拼团成功" forState:UIControlStateNormal];
    [_typeBtn addTarget:self action:@selector(pushBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0.0f,79, SCREEN_WIDTH, 1)];
    line2.backgroundColor = [UIColor colorWithHexString:@"0xD5D5D5"];
    line2.alpha = 0.5;
    [backView3 addSubview:line2];
    
    
}
-(void)pushBtn:(UIButton *)btn
{
    _pushDetail(btn.tag);
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
