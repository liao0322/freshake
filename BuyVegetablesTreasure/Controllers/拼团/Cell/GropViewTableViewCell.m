//
//  GropViewTableViewCell.m
//  BuyVegetablesTreasure
//
//  Created by XiaoBeiMAC on 15/11/25.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import "GropViewTableViewCell.h"

@implementation GropViewTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150*(SCREEN_WIDTH/320))];
        [self.contentView addSubview:_imgView];
        
        UIView *_roundView=[[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-70, 10, 60, 60)];
        _roundView.backgroundColor=[UIColor colorWithHexString:@"0xfc9d15"];
        _roundView.layer.cornerRadius=30;
        [self.contentView addSubview: _roundView];
        
        UIView *_line=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_imgView.frame), SCREEN_WIDTH, 1)];
        _line.backgroundColor=[UIColor colorWithHexString:@"0xd7d7d7"];
        [self.contentView addSubview:_line];
        
        for (int i=0; i<2; i++) {
            //圆内视图
            UILabel *_roundLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 10+20*i, 60, 20)];
            switch (i) {
                case 0:
                    _roundLabel.text=@"5.0折";
                    break;
                    
                default:
                    _roundLabel.text=@"5人团";
                    break;
            }
            _roundLabel.font=[UIFont systemFontOfSize:14];
            _roundLabel.textAlignment=NSTextAlignmentCenter;
            _roundLabel.textColor=[UIColor colorWithHexString:@"0xffffff"];
            [_roundView addSubview:_roundLabel];
        }
        _nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_imgView.frame)+10, SCREEN_WIDTH-40, 30)];
        _nameLabel.textColor=[UIColor colorWithHexString:@"0xff6600"];
        _nameLabel.font=[UIFont systemFontOfSize:18];
        [self.contentView addSubview:_nameLabel];
        
        _titleLabel=[[UILabel alloc]init];
        _titleLabel.textColor=[UIColor colorWithHexString:@"0x999999"];
        _titleLabel.font=[UIFont systemFontOfSize:15];
        _titleLabel.numberOfLines=0;
        [self.contentView addSubview:_titleLabel];
        
        _footView=[[UIView alloc]init];
        [self.contentView addSubview:_footView];
        
        //左边视图
        UIView *_bottomView=[[UIView alloc]initWithFrame:CGRectMake(20, 10, 160, 40)];
        _bottomView.layer.cornerRadius=20;
        _bottomView.backgroundColor=[UIColor colorWithHexString:@"0xfc9d15"];
        [_footView addSubview:_bottomView];
        
        UIImageView *_peopleImageView=[[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 20, 20)];
        _peopleImageView.image=IMAGE(@"拼团-图标");
        [_bottomView addSubview:_peopleImageView];
        
        _peopleLabel=[[UILabel alloc]initWithFrame:CGRectMake(40, 10, 110, 20)];
        _peopleLabel.font=[UIFont systemFontOfSize:14];
        _peopleLabel.textColor=[UIColor colorWithHexString:@"0xffffff"];
        [_bottomView addSubview: _peopleLabel];
        
        
        //右边视图
        UIButton *_button=[UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame=CGRectMake(SCREEN_WIDTH-120, 10, 100, 40);
        _button.layer.cornerRadius=20;
        _button.layer.borderColor=[[UIColor colorWithHexString:@"0xfc9d15"] CGColor];
        _button.layer.borderWidth=1;
        [_button setTitleColor:[UIColor colorWithHexString:@"0xfc9d15"] forState:UIControlStateNormal];
        _button.titleLabel.font=[UIFont systemFontOfSize:14];
        [_button setTitle:@"去开团" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(clickBut:) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:_button];
        
        UIView *_lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 59, SCREEN_WIDTH, 1)];
        _lineView.backgroundColor=[UIColor colorWithHexString:@"0xd7d7d7"];
        [_footView addSubview:_lineView];
    }
    return self;
}

- (void)setGroupModel:(GroupModel *)model{

    [_imgView sd_setImageWithURL:[NSURL URLWithString:model.thumbnailsUrll] placeholderImage:IMAGE(@"图片显示错误.jpg")];
    _nameLabel.text = model.ProductName;
    _titleLabel.text = model.Remark;
    _titleLabel.frame = CGRectMake(20, CGRectGetMaxY(_nameLabel.frame) + 10, SCREEN_WIDTH - 40, model.titleHight);
    _footView.frame = CGRectMake(0, CGRectGetMaxY(_titleLabel.frame), SCREEN_WIDTH, 60);
    _peopleLabel.text = [NSString stringWithFormat:@"%@人团   ￥%@元",model.ActivityUserNum,model.ActivityPrice];
}

-(void)clickBut:(UIButton *)sender{
    _goGroup();
}

@end
