//
//  AboutView.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/5/13.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "AboutView.h"

@implementation AboutView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth / 3, ScreenWidth / 3, ScreenWidth / 3, ScreenWidth / 3)];
    imageView.image = IMAGE(@"logo.jpg");
    [self addSubview:imageView];
    
    // 当前版本号
    NSString *appCurVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    _versionLabel = [UILabel new];
    _versionLabel.text = [NSString stringWithFormat:@"鲜摇派\n当前版本V%@",appCurVersion];
    _versionLabel.font = [UIFont systemFontOfSize:17];
    _versionLabel.textColor = [UIColor colorWithHexString:@"0x606060"];
    _versionLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_versionLabel];
    
    _versionLabel.sd_layout.leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .topSpaceToView(imageView, 30)
    .autoHeightRatio(0);
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor colorWithHexString:@"0x606060"];
    titleLabel.numberOfLines = 0;
    titleLabel.text = @"上海宜生源文化传播有限公司，作为一家新崛起的，以物联网技术为基础，以平台型智能硬件为载体，以云计算为处理平台，以大数据应用为目标，以用户群体为核心竞争力，以互联网为经营模式，以“有趣、选秀、造星、巨奖、智慧”的新媒体文化为灵魂，整合传统产业资源，打造互动、智能、场景化的全营销平台。";
    [self addSubview:titleLabel];
    
    titleLabel.sd_layout
    .leftSpaceToView(self, 15)
    .rightSpaceToView(self, 15)
    .topSpaceToView(_versionLabel, 15)
    .autoHeightRatio(0);
    
    UILabel *label = [UILabel new];
    label.text = @"Copyright（c）2014-2016 上海宜生源文化传播有限公司 allrights reserved";
    label.font = [UIFont systemFontOfSize:11];
    label.textColor = [UIColor colorWithHexString:@"0x999999"];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    
    label.sd_layout.leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .bottomSpaceToView(self, 25)
    .autoHeightRatio(0);
}

@end
