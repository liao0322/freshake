//
//  GroupDateilTableViewCell.m
//  BuyVegetablesTreasure
//
//  Created by XiaoBeiMAC on 15/11/26.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import "GroupDateilTableViewCell.h"

@implementation GroupDateilTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ScreenWidth / 2)];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.clipsToBounds = YES;
        [self.contentView addSubview:_imgView];
        
        UIView *_line=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_imgView.frame), SCREEN_WIDTH, 1)];
        _line.backgroundColor=[UIColor colorWithHexString:@"0xd7d7d7"];
        [self.contentView addSubview:_line];

        _nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_imgView.frame)+10, SCREEN_WIDTH-40, 30)];
        _nameLabel.textColor=Color;
        _nameLabel.font=[UIFont systemFontOfSize:18];
        [self.contentView addSubview:_nameLabel];
        
        _titleLabel=[[UILabel alloc]init];
        _titleLabel.textColor=[UIColor colorWithHexString:@"0x999999"];
        _titleLabel.font=[UIFont systemFontOfSize:15];
        _titleLabel.numberOfLines=0;
        [self.contentView addSubview:_titleLabel];
        
        _footView = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_footView];
        
        for (int i=0; i<2; i++) {
            
            UILabel *_footLable=[[UILabel alloc]initWithFrame:CGRectMake(20+(SCREEN_WIDTH/2-20)*i, 10, SCREEN_WIDTH/2-20, 30)];
            _footLable.tag = i + 100;
            _footLable.textColor=Color;
            _footLable.font=[UIFont systemFontOfSize:17];
            [_footView addSubview:_footLable];
            
            UIView *_bottomView=[[UIView alloc]initWithFrame:CGRectMake(20+((SCREEN_WIDTH-70)/2+30)*i, 50, (SCREEN_WIDTH-70)/2, 60)];
            _bottomView.layer.borderWidth=1;
            [_footView addSubview:_bottomView];
            
            UILabel *_BULabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, _bottomView.frame.size.width, 30)];
            _BULabel.tag = i + 200;
            _BULabel.font=[UIFont systemFontOfSize:15];
            _BULabel.textColor=[UIColor colorWithHexString:@"0xffffff"];
            _BULabel.textAlignment=NSTextAlignmentCenter;
            [_bottomView addSubview:_BULabel];
            
            UILabel *_BDLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 30, _bottomView.frame.size.width, 30)];
            _BDLabel.tag = i + 300;
            _BDLabel.font=[UIFont systemFontOfSize:15];
            _BDLabel.textAlignment=NSTextAlignmentCenter;
            _BDLabel.backgroundColor=[UIColor colorWithHexString:@"0xffffff"];
            [_bottomView addSubview:_BDLabel];
            
            switch (i) {
                case 0:
                    _footLable.textAlignment = NSTextAlignmentLeft;
                    _bottomView.layer.borderColor = [Color CGColor];
                    _BULabel.backgroundColor = Color;
                    _BDLabel.textColor = Color;
                    break;
                    
                default:
                    _footLable.textAlignment = NSTextAlignmentRight;
                    _bottomView.layer.borderColor = [[UIColor colorWithHexString:@"0x6cc159"] CGColor];
                    _BULabel.backgroundColor = [UIColor colorWithHexString:@"0x6cc159"];
                    _BDLabel.textColor = [UIColor colorWithHexString:@"0x6cc159"];
                    _BDLabel.text = @"单独购买 >";
                    break;
            }
            UIButton *_button=[UIButton buttonWithType:UIButtonTypeCustom];
            _button.frame=CGRectMake(0 , 0, _bottomView.frame.size.width, _bottomView.frame.size.height);
            [_button addTarget:self action:@selector(clickBut:) forControlEvents:UIControlEventTouchUpInside];
            _button.tag=100+i;
            [_bottomView addSubview:_button];
        }
        UIView *_lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 120, SCREEN_WIDTH, 1)];
        _lineView.backgroundColor=[UIColor colorWithHexString:@"0xd7d7d7"];
        [_footView addSubview:_lineView];
        UIView *_lineViewTwo=[[UIView alloc]initWithFrame:CGRectMake(0, 121, SCREEN_WIDTH, 9)];
        _lineViewTwo.backgroundColor=[UIColor colorWithHexString:@"0xf8f8f8"];
        [_footView addSubview:_lineViewTwo];
    }
    return self;
}

-(void)setGroupModel:(GroupModel *)model{
    
    [_imgView sd_setImageWithURL:[NSURL URLWithString:model.thumbnailsUrll] placeholderImage:IMAGE(@"ErrorBackImage")];
    _nameLabel.text = model.ProductName;
    _titleLabel.text = model.Remark;
    _titleLabel.frame = CGRectMake(20, CGRectGetMaxY(_nameLabel.frame)+10, SCREEN_WIDTH-40, model.titleHight);
    _footView.frame = CGRectMake(0, CGRectGetMaxY(_titleLabel.frame), SCREEN_WIDTH, 130);
    
    [(UILabel *)[self viewWithTag:300] setText:[NSString stringWithFormat:@"%@人团",model.ActivityUserNum]];
    
    for (int i = 0; i < 2; i++) {
        
        NSString *salePriceOrSoldStock = i == 0 ? [NSString stringWithFormat:@"市场价: %@",model.salePrice] : [NSString stringWithFormat:@"已售: %@",model.SoldStock];
        
        NSString *priceString = i == 0 ? [NSString stringWithFormat:@"%@元/%@",model.ActivityPrice,model.Specifications] : [NSString stringWithFormat:@"%@元/%@",model.salePrice,model.Specifications];
        
        [(UILabel *)[self viewWithTag:100 + i] setText:salePriceOrSoldStock];
        [(UILabel *)[self viewWithTag:200 + i] setText:priceString];
    }
}

- (void)clickBut:(UIButton *)sender{
    
    switch (sender.tag) {
        case 100:
            _payGroup();
            break;
            
        default:
            _payOwn();
            break;
    }
}

@end
