//
//  IntroduceCell.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/4/26.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "IntroduceCell.h"

@interface IntroduceCell ()

@property (nonatomic, copy) UILabel *nameLabel;
@property (nonatomic, copy) UILabel *palyCountLabel;
@property (nonatomic, copy) UILabel *introduceLabel;
@property (nonatomic, copy) UIImageView *cookingImageView;

@end

@implementation IntroduceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initCell];
    }
    
    return self;
}

- (void)initCell {
    
    // 节目图片
    _cookingImageView = [[UIImageView alloc] initWithImage:IMAGE(@"视频")];
    _cookingImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:_cookingImageView];
    
    _cookingImageView.sd_layout
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .topSpaceToView(self.contentView, 0)
    .heightIs(ScreenWidth / 2);
    
    for (int i = 0; i < 2; i++) {
        
        UILabel *line = [UILabel new];
        line.frame = CGRectMake(0, i * CGRectGetMaxY(_cookingImageView.frame), ScreenWidth, 0.5);
        line.backgroundColor = [UIColor colorWithHexString:@"0xd7d7d7"];
        [_cookingImageView addSubview:line];
        
        UIButton *otherBtn = [UIButton new];
        otherBtn.tag = i + 11;
        otherBtn.frame = CGRectMake(ScreenWidth - 40 * (i + 1), 10, 30, 30);
        [otherBtn setImage:i == 1 ? IMAGE(@"收藏灰色") : IMAGE(@"link") forState:UIControlStateNormal];
        [otherBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 1) {
            
            [otherBtn setImage:IMAGE(@"收藏") forState:UIControlStateSelected];
        }
        
        [_cookingImageView addSubview:otherBtn];
    }
    
    // 名称
    _nameLabel = [UILabel new];
    _nameLabel.text = @"培根土豆焗饭";
    _nameLabel.font = [UIFont systemFontOfSize:15];
    _nameLabel.textColor = Color;
    [self.contentView addSubview:_nameLabel];
    
    _nameLabel.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15)
    .topSpaceToView(_cookingImageView, 15)
    .heightIs(15);
    
    // 播放次数
    _palyCountLabel = [UILabel new];
    _palyCountLabel.text = @"播放次数：298次";
    _palyCountLabel.font = [UIFont systemFontOfSize:12];
    _palyCountLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
    [self.contentView addSubview:_palyCountLabel];
    
    _palyCountLabel.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15)
    .topSpaceToView(_nameLabel, 10)
    .heightIs(12);
    
    // 介绍
    _introduceLabel = [UILabel new];
    _introduceLabel.text = @"";
    _introduceLabel.font = [UIFont systemFontOfSize:13];
    _introduceLabel.textColor = [UIColor colorWithHexString:@"0x797878"];
    _introduceLabel.numberOfLines = 0;
    [self.contentView addSubview:_introduceLabel];

    _introduceLabel.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .topSpaceToView(_palyCountLabel, 15)
    .rightSpaceToView(self.contentView, 15)
    .autoHeightRatio(0);
    
    // 线
    UILabel *line = [UILabel new];
    line.backgroundColor = [UIColor colorWithHexString:@"0xd7d7d7"];
    [self.contentView addSubview:line];
    
    line.sd_layout
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .topSpaceToView(_introduceLabel, 15)
    .heightIs(1);
    
    [self setupAutoHeightWithBottomView:line bottomMargin:0];
}

- (void)btnClick:(UIButton *)btn {
    
    if (btn.tag == 12) {
        
        btn.selected = !btn.selected;
        _isCollect(_model.Id,_model.Title,btn.selected);
    }
    else {
        NSLog(@"Line");
    }
}

- (void)setModel:(CookingProgramListModel *)model {
    
    _model = model;
    
    _nameLabel.text = model.Title;
    _palyCountLabel.text = [NSString stringWithFormat:@"播放次数：%@次",model.Flow];
    _introduceLabel.text = model.CountText;
    [_cookingImageView sd_setImageWithURL:[NSURL URLWithString:LMMC(model.pic)] placeholderImage:IMAGE(@"ErrorBackImage")];
    
    NSLog(@"%@",LMMC(model.pic));
    
    [(UIButton *)[self viewWithTag:12] setSelected:[model.isVedio boolValue]];
}

@end
