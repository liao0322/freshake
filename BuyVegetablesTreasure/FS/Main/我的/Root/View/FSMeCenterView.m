//
//  FSMeCenterView.m
//  BuyVegetablesTreasure
//
//  Created by 江玉元 on 2016/12/13.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSMeCenterView.h"

@interface FSMeCenterView ()

@property (nonatomic, strong) NSArray *imgArray;
@property (nonatomic, strong) NSArray *selectImgArray;
@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation FSMeCenterView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initCenterView];
    }
    return self;
}

- (void)initCenterView {
    
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *myOrderLabel = [[UILabel alloc] initWithFrame:CGRectMake(23, 10, ScreenWidth / 3, 30)];
    myOrderLabel.textAlignment = NSTextAlignmentLeft;
    myOrderLabel.text = @"我的订单";
    myOrderLabel.textColor = [UIColor colorWithHexString:@"0x404040"];
    myOrderLabel.font = [UIFont systemFontOfSize:15.0];
    [self addSubview:myOrderLabel];
    
    UILabel *allOrderLabel = [[UILabel alloc] init];
    allOrderLabel.text = @"查看全部订单";
    allOrderLabel.textColor = [UIColor colorWithHexString:@"0xb2b2b2"];
    allOrderLabel.font = [UIFont systemFontOfSize:14.0];
    [allOrderLabel sizeToFit];
    allOrderLabel.frame = CGRectMake(ScreenWidth - CGRectGetWidth(allOrderLabel.frame) - 20, 10, CGRectGetWidth(allOrderLabel.frame), 30);
    [self addSubview:allOrderLabel];
    
//    UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 30, 10, 10, 20)];
    UIImageView *iconImage = [UIImageView new];
    iconImage.image = IMAGE(@"FS进入gray");
    [self addSubview:iconImage];
    
    iconImage.sd_layout
    .rightSpaceToView(self, 10)
    .topSpaceToView(self, 20)
    .widthIs(5)
    .heightIs(10);
    
    UIButton *allOrderBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    allOrderBtn.frame = CGRectMake(0, 0, ScreenWidth, 45);
    [allOrderBtn addTarget:self action:@selector(allOrderClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:allOrderBtn];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(allOrderBtn.frame), ScreenWidth, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"0xd9d9d9"];
    [self addSubview:line];
    
    _imgArray = @[@"FS待付款",@"FS待提货",@"FS已提货",@"FS待评价"];
//    _selectImgArray = @[@"Myorder_所有订单",@"Myorder_待付款",@"Myorder_待提货",@"Myorder_已提货",@"Myorder_待评价"];
    _titleArray = @[@"待付款",@"待提货",@"已提货",@"待评价"];

    for (int i = 0; i < _titleArray.count; i++) {
        
        int btnWidth = SCREEN_WIDTH / _titleArray.count;
        
        UIButton *bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        bgBtn.tag = i + 100;
        bgBtn.frame = CGRectMake(btnWidth * i, CGRectGetMaxY(line.frame), btnWidth, self.frame.size.height - CGRectGetMaxY(line.frame));
        [bgBtn addTarget:self action:@selector(centerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bgBtn];
        
        float bgBtnWidth = bgBtn.frame.size.width;
        float bgBtnHeight = bgBtn.frame.size.height;
        
        UIImage *img = IMAGE(_imgArray[i]);
//        UIImage *selectImg = IMAGE(_selectImgArray[i]);
        UIImageView *iconImageView = [[UIImageView alloc] initWithImage:img];
        iconImageView.frame = CGRectMake(bgBtnWidth / 2 - img.size.width / 2, bgBtnHeight / 2 - img.size.height / 2 - 10, img.size.width, img.size.height);
        iconImageView.tag = i + 50;
        [bgBtn addSubview:iconImageView];
        
        UILabel *orderStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, bgBtnHeight - 25, bgBtnWidth, 15)];
        orderStateLabel.tag = i + 60;
        orderStateLabel.text = _titleArray[i];
        orderStateLabel.font = [UIFont systemFontOfSize:14.0];
        orderStateLabel.textColor = [UIColor blackColor];
        orderStateLabel.textAlignment = NSTextAlignmentCenter;
        [bgBtn addSubview:orderStateLabel];
        
        UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImageView.frame) - 5, 6, 15, 15)];
        countLabel.tag = i + 70;
        countLabel.font = [UIFont systemFontOfSize:7];
        countLabel.backgroundColor = [UIColor colorWithHexString:@"0xf18316"];
        countLabel.textAlignment = NSTextAlignmentCenter;
        countLabel.textColor = [UIColor orangeColor];
        countLabel.layer.borderColor = [UIColor orangeColor].CGColor;
        countLabel.layer.borderWidth = 1;
        countLabel.layer.masksToBounds = YES;
        countLabel.layer.cornerRadius = countLabel.frame.size.width / 2;
        [bgBtn addSubview:countLabel];
        
}
    
}

- (void)centerBtnClick:(UIButton *)sender {
    NSLog(@"订单状态");
}

- (void)allOrderClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(fsCenterView:allOrderButtonClick:)]) {
        [self.delegate fsCenterView:self allOrderButtonClick:sender];
    }
}



@end
