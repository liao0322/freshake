//
//  adTop_HeadView.m
//  BuyVegetablesTreasure
//
//  Created by sc on 16/3/17.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "adTop_HeadView.h"

@interface adTop_HeadView ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) HomePageModel *homePageModel;

@end

@implementation adTop_HeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initTopHeadView];
    }
    return self;
}

- (void)initTopHeadView {
    
    _bgView = [[UIView alloc] init];
    _bgView.frame = CGRectMake(0, 0, ScreenWidth, 50);
    _bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bgView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 10, 20)];
    label.backgroundColor = Color;
    [_bgView addSubview:label];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(CGRectGetMaxX(label.frame) + 10, 0, 100, CGRectGetHeight(_bgView.frame));
    titleLabel.text = @"人气推荐";
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = Color;
    [_bgView addSubview:titleLabel];
    
    for (int i = 0; i < 2; i++) {
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_bgView.frame) * i, ScreenWidth, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"0xE2E2E2"];
        [_bgView addSubview:line];
    }
}

- (void)setTopImageWithArray:(NSArray *)arr {
    
    if (arr.count > 0) {
        
        HomePageModel *model = arr[0];
        _homePageModel = arr[0];
        if (_topImageView == nil) {
            
            _topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_bgView.frame) + 10, ScreenWidth - 20, ScreenWidth - ScreenWidth / 5 * 3)];
            [_topImageView sd_setImageWithURL:[NSURL URLWithString:model.ImgUrl] placeholderImage:[UIImage imageNamed:@"ErrorBackImage"]];
            _topImageView.userInteractionEnabled = YES;
            _topImageView.contentMode = UIViewContentModeScaleAspectFill;
            _topImageView.clipsToBounds = YES;
            [self addSubview:_topImageView];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgClick)];
            [_topImageView addGestureRecognizer:tap];
        }
        
        [_topImageView sd_setImageWithURL:[NSURL URLWithString:model.ImgUrl] placeholderImage:[UIImage imageNamed:@"ErrorBackImage"]];
    }
}

- (void)imgClick {
    
    _topModel(_homePageModel);
}

@end
