//
//  GoodsAdvertisingCell.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/12/8.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "GoodsAdvertisingCell.h"

@interface GoodsAdvertisingCell ()

@property (nonatomic, strong) UIScrollView *imgScrollView;

@end

@implementation GoodsAdvertisingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor colorWithHexString:@"0xf8f8f8"];
        
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    
    self.imgScrollView = [UIScrollView new];
    self.imgScrollView.showsHorizontalScrollIndicator = NO;
    [self.contentView addSubview:self.imgScrollView];
    
    self.imgScrollView.sd_layout
    .leftSpaceToView(self.contentView, HomePageSpacing)
    .rightSpaceToView(self.contentView, HomePageSpacing)
    .topEqualToView(self.contentView)
    .bottomEqualToView(self.contentView);
}

- (void)setDataSource:(NSArray *)dataSource {
    
    for (UIView *subView in self.imgScrollView.subviews) {
        
        if ([subView isKindOfClass:[UIImageView class]]) {
            [subView removeFromSuperview];
        }
    }
    
    for (int i = 0; i < dataSource.count; i++) {
        
        float width = (ScreenWidth - HomePageSpacing * 4) / 3;
        
        AdvertisingModel *model = dataSource[i];
        UIImageView *imgView = [UIImageView new];
        imgView.tag = i + 1;
        imgView.layer.borderWidth = 0.5;
        imgView.layer.borderColor = [LineColor CGColor];
        imgView.userInteractionEnabled = YES;
        [self.imgScrollView addSubview:imgView];
        
        imgView.sd_layout
        .leftSpaceToView(self.imgScrollView, (width + HomePageSpacing) * i)
        .widthIs(width)
        .topEqualToView(self.imgScrollView)
        .bottomEqualToView(self.imgScrollView);
        
        // 增加图片点击事件
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(imgClick:)];
        [imgView addGestureRecognizer:tap];
        
        UIImage *img = IMAGE(@"列表页未成功图片");
        img = [img reSize:CGSizeMake(width, width * 3 / 2)];
        [imgView sd_setImageWithURL:[NSURL URLWithString:model.ImgUrl] placeholderImage:img];
    }
    
    _dataSource = dataSource;
    [Single sharedInstance].isUpdateGoods = NO;
}

- (void)imgClick:(UITapGestureRecognizer *)tap {
    
    UIImageView *imgView = (UIImageView *)tap.view;
    self.imgClick(self.dataSource[imgView.tag - 1]);
}

@end
