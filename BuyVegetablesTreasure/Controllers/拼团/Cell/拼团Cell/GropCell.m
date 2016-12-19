//
//  GropCell.m
//  BuyVegetablesTreasure
//
//  Created by sc on 16/4/5.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "GropCell.h"

@interface GropCell ()

@property (nonatomic, copy) UIButton *goGroupBtn;
@property (nonatomic, copy) UIButton *bgView;
@property (nonatomic, copy) UILabel *line;

@end

@implementation GropCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initCell];
    }
    return self;
}

- (void)initCell {
    
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH / 2)];
    _imgView.contentMode = UIViewContentModeScaleAspectFill;
    _imgView.clipsToBounds = YES;
    [self.contentView addSubview:_imgView];
    
    UIView *roundView = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth - 70, 10, 60, 60)];
    roundView.backgroundColor = [UIColor colorWithHexString:@"0xff6600"];
    roundView.layer.cornerRadius = 30;
    [self.contentView addSubview:roundView];
    
    for (int i = 0; i < 2; i++) {
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, i * (CGRectGetHeight(_imgView.frame) - 1), ScreenWidth, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"0xE2E2E2"];
        [self.contentView addSubview:line];
        
        UILabel *roundLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10 + 20 * i, 60, 20)];
        roundLabel.tag = i + 100;
        roundLabel.font = [UIFont systemFontOfSize:14];
        roundLabel.textAlignment = NSTextAlignmentCenter;
        roundLabel.textColor = [UIColor colorWithHexString:@"0xffffff"];
        [roundView addSubview:roundLabel];
    }
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_imgView.frame) + 15, ScreenWidth - 40, 15)];
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:_nameLabel];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.numberOfLines = 0;
    [self.contentView addSubview:_titleLabel];

    _bgView = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, 280, 40)];
    _bgView.layer.borderColor = [UIColor colorWithHexString:@"0xff6600"].CGColor;
    _bgView.layer.borderWidth = 1;
    [_bgView addTarget:self action:@selector(goGroupBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_bgView];
    
    UIImageView *peopleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 12, 19, 16)];
    peopleImageView.image = IMAGE(@"拼团-图标");
    [_bgView addSubview:peopleImageView];
    
    _peopleLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 10, 150, 20)];
    _peopleLabel.font = [UIFont systemFontOfSize:14];
    _peopleLabel.textColor = [UIColor colorWithHexString:@"0xff6600"];
    [_bgView addSubview:_peopleLabel];
    
    _goGroupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _goGroupBtn.frame = CGRectMake(180, 0, 100, CGRectGetHeight(_bgView.frame));
    _goGroupBtn.backgroundColor = [UIColor colorWithHexString:@"0xff6600"];
    _goGroupBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_goGroupBtn setTitle:@"去开团" forState:UIControlStateNormal];
    [_goGroupBtn addTarget:self action:@selector(goGroupBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_goGroupBtn];
    
    _line = [[UILabel alloc] init];
    _line.backgroundColor = [UIColor colorWithHexString:@"0xE2E2E2"];
    [self.contentView addSubview:_line];
}

- (void)setGroupModel:(GroupModel *)model {

    _nameLabel.text = model.ProductName;
    _titleLabel.text = model.Remark;
    _peopleLabel.text = [NSString stringWithFormat:@"%@人团   ￥%@元",model.ActivityUserNum,model.ActivityPrice];
    _titleLabel.frame = CGRectMake(20, CGRectGetMaxY(_nameLabel.frame) + 5, ScreenWidth - 40, model.titleHight);
    _line.frame = CGRectMake(0, model.titleHight + 95 + CGRectGetHeight(_imgView.frame), ScreenWidth, 1);
    [_imgView sd_setImageWithURL:[NSURL URLWithString:model.thumbnailsUrll] placeholderImage:IMAGE(@"ErrorBackImage")];
    
    CGRect frame = _bgView.frame;
    frame.origin.y = CGRectGetMaxY(_titleLabel.frame) + 10;
    _bgView.frame = frame;
    
    for (int i = 0; i < 2; i++) {
        
        UILabel *roundLabel = (UILabel *)[self viewWithTag:i + 100];
        NSString *discountString = [NSString stringWithFormat:@"%.1f折",[model.ActivityPrice floatValue] / [model.salePrice floatValue] * 10];
        NSString *numberString = [NSString stringWithFormat:@"%@人团",model.ActivityUserNum];
        roundLabel.text = i == 0 ? discountString : numberString;
    }
}

- (void)goGroupBtnClick {
    
    _goGroup();
}

@end
