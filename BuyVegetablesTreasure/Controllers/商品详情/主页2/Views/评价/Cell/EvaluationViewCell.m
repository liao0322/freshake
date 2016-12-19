//
//  EvaluationViewCell.m
//  BuyVegetablesTreasure
//
//  Created by Kai on 16/1/6.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "EvaluationViewCell.h"

@implementation EvaluationViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self initEvaluationViewCell];
    }
    
    return self;
}

- (void)initEvaluationViewCell {
    
    // 头像
    self.iconImageView = [UIImageView new];
    [self.iconImageView doCircleFrame];
    [self.contentView addSubview:self.iconImageView];
    
    self.iconImageView.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .topSpaceToView(self.contentView, 15)
    .heightIs(50)
    .widthEqualToHeight();
    
    // 用户昵称
    self.userNameLabel = [UILabel new];
    self.userNameLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
    self.userNameLabel.font = [UIFont systemFontOfSize:12];
    self.userNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.userNameLabel];
    
    self.userNameLabel.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .topSpaceToView(self.iconImageView, 2.5)
    .widthIs(50)
    .heightIs(15);
    
    // 评分
    UILabel *scoreLabel = [UILabel new];
    scoreLabel.text = @"评分:";
    scoreLabel.textColor = [UIColor blackColor];
    scoreLabel.font = [UIFont systemFontOfSize:14];
    [scoreLabel setSingleLineAutoResizeWithMaxWidth:100];
    [self.contentView addSubview:scoreLabel];
    
    scoreLabel.sd_layout
    .topSpaceToView(self.contentView, 15)
    .leftSpaceToView(self.iconImageView, 15)
    .heightIs(15);
    
    // 评价内容
    self.contentLabel = [UILabel new];
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    self.contentLabel.textColor = [UIColor colorWithHexString:@"0x2e2d2d"];
    self.contentLabel.numberOfLines = 0;
    [self.contentView addSubview:self.contentLabel];

    self.contentLabel.sd_layout
    .leftSpaceToView(self.iconImageView, 15)
    .rightSpaceToView(self.contentView, 15)
    .topSpaceToView(scoreLabel, 10)
    .autoHeightRatio(0);
    
    UIImageView *imgView;
    for (int i = 0; i < 5; i++) {
        
        UIImage *img = IMAGE(@"选择星形");
        UIButton *scoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        scoreBtn.tag = i + 200;
        [scoreBtn setImage:IMAGE(@"未选择星形") forState:UIControlStateNormal];
        [scoreBtn setImage:img forState:UIControlStateSelected];
        [self.contentView addSubview:scoreBtn];
        
        scoreBtn.sd_layout
        .leftSpaceToView(scoreLabel, 5 + i * (img.size.width + 1))
        .centerYEqualToView(scoreLabel)
        .widthIs(img.size.width)
        .heightIs(img.size.height);
        
        CGFloat imgWidth = (ScreenWidth - 115) / 5;
        imgView = [UIImageView new];
        imgView.tag = i + 300;
        imgView.hidden = YES;
        imgView.userInteractionEnabled = YES;
        [self.contentView addSubview:imgView];
        
        imgView.sd_layout
        .topSpaceToView(self.contentLabel, 10)
        .leftSpaceToView(self.iconImageView, 15 + (imgWidth + 5) * i)
        .widthIs(imgWidth)
        .heightEqualToWidth(0);
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgClick:)];
        [imgView addGestureRecognizer:tap];
    }
    
    // 时间
    self.timeLabel = [UILabel new];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"0x777667"];
    self.timeLabel.font = [UIFont systemFontOfSize:13];
    [self.timeLabel setSingleLineAutoResizeWithMaxWidth:200];
    [self.contentView addSubview:self.timeLabel];
    
    self.timeLabel.sd_layout
    .leftSpaceToView(self.iconImageView, 15)
    .topSpaceToView(imgView, 10)
    .heightIs(15);
    
    // 线
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor colorWithHexString:@"0xDAD9D9"];
    [self.contentView addSubview:lineView];
    
    lineView.sd_layout
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .bottomEqualToView(self.contentView)
    .heightIs(0.5);
    
    [self setupAutoHeightWithBottomView:self.timeLabel bottomMargin:15];
}

- (void)imgClick:(UITapGestureRecognizer *)tap {
    UIImageView *imgView = (UIImageView *)tap.view;
    self.imgClickBlock(self.model, imgView.tag - 300);
}

- (void)setModel:(EvaluationModel *)model {
    
    _model = model;
    
    // 判断是否有图片
    NSMutableArray *imgs = [NSMutableArray array];
    
    if (!isBlankString(model.image)) {
        [imgs addObject:model.image];
    }
    
    if (!isBlankString(model.image1)) {
        [imgs addObject:model.image1];
    }
    
    if (!isBlankString(model.image2)) {
        [imgs addObject:model.image2];
    }
    
    if (!isBlankString(model.image3)) {
        [imgs addObject:model.image3];
    }
    
    if (!isBlankString(model.image4)) {
        [imgs addObject:model.image4];
    }
    
    for (int i = 0; i < 5; i++) {
        
        UIImageView *imgView = [self viewWithTag:i + 300];
        imgView.hidden = YES;
        
        if (imgs.count > i) {
            
            imgView.hidden = NO;
            [imgView sd_setImageWithURL:[NSURL URLWithString:imgs[i]]
                       placeholderImage:IMAGE(@"列表页未成功图片")];
            
            self.timeLabel.sd_layout.topSpaceToView(imgView, 10);
        }
        
        if (imgs.count == 0) {
            self.timeLabel.sd_layout.topSpaceToView(self.contentLabel, 10);
        }
    }
    
    // 评分
    for (int i = 0; i < 5; i++) {
        
        UIButton *scoreBtn = (UIButton *)[self viewWithTag:i + 200];
        scoreBtn.selected = i < [model.level integerValue] ? YES : NO;
    }
    
    // 评价内容
    self.contentLabel.text = [NSString stringWithFormat:@"内容: %@",model.Context];
    
    // 用户名称
    self.userNameLabel.text = model.userName;
    // 评价时间
    self.timeLabel.text = model.addTime;
    // 用户头像
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar]
                          placeholderImage:IMAGE(@"列表页未成功图片")];
}

@end
