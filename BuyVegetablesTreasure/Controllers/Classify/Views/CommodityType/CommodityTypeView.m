//
//  CommodityTypeView.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/4/20.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "CommodityTypeView.h"

#define CommodityTypeViewWidth _commodityTypeView.frame.size.width
#define TypeButtonHeight 40

@interface CommodityTypeView ()<UIScrollViewDelegate>

@property (nonatomic, copy) UIScrollView *commodityTypeView;
@property (nonatomic, copy) NSArray *dataScoure;

@end

@implementation CommodityTypeView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initCommodityTypeView];
    }
    return self;
}

#pragma mark - 初始化
- (void)initCommodityTypeView {
    
    _commodityTypeView = [[UIScrollView alloc] initWithFrame:self.frame];
    _commodityTypeView.delegate = self;
    _commodityTypeView.showsVerticalScrollIndicator = NO;
    [self addSubview:_commodityTypeView];
}

- (void)createCommodityType:(NSArray *)dataScoure {

    _dataScoure = dataScoure;
    
    for (UIView *view in _commodityTypeView.subviews) {
        [view removeFromSuperview];
    }
    
    for (int i = 0; i < dataScoure.count; i++) {
        
        LeftClassModel *model = dataScoure[i];
        
        UIButton *typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        typeBtn.frame = CGRectMake(0, TypeButtonHeight * i, CommodityTypeViewWidth, TypeButtonHeight);
        typeBtn.tag = 100 + i;
        typeBtn.backgroundColor = i == 0 ? [UIColor whiteColor] : [UIColor colorWithHexString:@"0xFEE2D9"];
        [typeBtn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_commodityTypeView addSubview:typeBtn];
        
        UILabel *typeLabel  = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CommodityTypeViewWidth, TypeButtonHeight)];
        typeLabel.tag  = 200 + i;
        typeLabel.text = model.CategoryName;
        typeLabel.font = [UIFont systemFontOfSize:15];
        typeLabel.textColor = i == 0 ? Color : [UIColor blackColor];
        typeLabel.textAlignment = NSTextAlignmentCenter;
        [typeBtn addSubview:typeLabel];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, TypeButtonHeight - 0.5, SYSTEM_WIDTH, 0.5)];
        line.tag = 300 + i;
        line.backgroundColor = i == 0 ? Color : [UIColor colorWithHexString:@"0xDADADA"];
        [typeBtn addSubview:line];
    }
    
    _commodityTypeView.contentSize = CGSizeMake(0, TypeButtonHeight * dataScoure.count);
}

- (void)typeBtnClick:(UIButton *)btn {
    
    _moveTableView(btn.tag - 100);
    [self moveType:btn.tag - 100];
}

- (void)moveType:(NSInteger)index {

    for (int i = 0; i < _dataScoure.count; i++) {
        
        UIButton *typeBtn = (UIButton *)[self viewWithTag:100 + i];
        typeBtn.backgroundColor = [UIColor colorWithHexString:@"0xFEE2D9"];
        
        UILabel *typeLabel = (UILabel *)[self viewWithTag:200 + i];
        typeLabel.textColor = [UIColor blackColor];
        
        UILabel *line = (UILabel *)[self viewWithTag:300 + i];
        line.backgroundColor = [UIColor colorWithHexString:@"0xDADADA"];
    }

    UIButton *typeBtn = (UIButton *)[self viewWithTag:100 + index];
    typeBtn.backgroundColor = [UIColor whiteColor];
    
    UILabel *typeLabel = (UILabel *)[self viewWithTag:200 + index];
    typeLabel.textColor = Color;
    
    UILabel *line = (UILabel *)[self viewWithTag:300 + index];
    line.backgroundColor = Color;
}

@end