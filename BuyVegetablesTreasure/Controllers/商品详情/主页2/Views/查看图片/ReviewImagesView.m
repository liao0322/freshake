//
//  ReviewImagesView.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/11/28.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "ReviewImagesView.h"

@implementation ReviewImagesView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self initImgView];
    }
    
    return self;
}

- (void)initImgView {
    
    self.imgScrollView = [UIScrollView new];
    self.imgScrollView.pagingEnabled = YES;
    self.imgScrollView.delegate = self;
    [self addSubview:self.imgScrollView];
    
    self.imgScrollView.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .topEqualToView(self)
    .bottomEqualToView(self);
}

- (void)setIndex:(NSInteger)index {
    
    self.imgScrollView.contentOffset = CGPointMake(ScreenWidth * index, 0);
}

- (void)setModel:(EvaluationModel *)model {
    
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
    
    self.imgScrollView.contentSize = CGSizeMake(ScreenWidth * imgs.count, 0);
    
    for (int i = 0; i < imgs.count; i++) {
        
        UIImageView *imgView = [UIImageView new];
        imgView.userInteractionEnabled = YES;
        imgView.hidden = NO;
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [imgView sd_setImageWithURL:[NSURL URLWithString:imgs[i]]
                   placeholderImage:IMAGE(@"列表页未成功图片")];
        [self.imgScrollView addSubview:imgView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgClick)];
        [imgView addGestureRecognizer:tap];
        
        imgView.sd_layout
        .leftSpaceToView(self.imgScrollView, i * ScreenWidth)
        .topEqualToView(self.imgScrollView)
        .bottomEqualToView(self.imgScrollView)
        .widthIs(ScreenWidth);
    }
}

- (void)imgClick {
    
    self.hidden = YES;
    
    for (UIView *subView in self.imgScrollView.subviews) {
        if ([subView isKindOfClass:[UIImageView class]]) {
            [subView removeFromSuperview];
        }
    }
}

@end
