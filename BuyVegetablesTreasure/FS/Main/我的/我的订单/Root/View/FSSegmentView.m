//
//  FSSegmentView.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2017/1/18.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import "FSSegmentView.h"
#import "XFNoHighlightButton.h"

#define INDICATOR_VIEW_HEIGHT 3.0f

@interface FSSegmentView ()

@property (copy, nonatomic) NSArray *titles;

@property (copy, nonatomic) NSMutableArray *titleButtons;
@property (nonatomic) XFNoHighlightButton *selectedButton;

@property (nonatomic) UIView *indicatorView;
@property (nonatomic) UIView *separatorLine;


@end

@implementation FSSegmentView

- (instancetype)initWithTitles:(NSArray *)titles {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _titles = titles;
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews {
    
    [self.titles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *title = obj;
        
        XFNoHighlightButton *button = [XFNoHighlightButton buttonWithType:UIButtonTypeCustom];
        button.tag = idx;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorDomina] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor colorTextDomina] forState:UIControlStateNormal];

        [button addTarget:self action:@selector(itemTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.titleButtons addObject:button];
        [self addSubview:button];
    }];
    
    [self addSubview:self.indicatorView];
    [self addSubview:self.separatorLine];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = self.width;
    CGFloat height = self.height;
    
    CGFloat buttonWidth = width / self.titles.count;
    CGFloat buttonHeight = height - INDICATOR_VIEW_HEIGHT;
    
    // button
    [self.titleButtons enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XFNoHighlightButton *button = obj;
        button.frame = CGRectMake(buttonWidth * idx, 0, buttonWidth, buttonHeight);
    }];
    
    self.indicatorView.width = [self indicatorViewWidth];
    self.indicatorView.height = INDICATOR_VIEW_HEIGHT;
    self.indicatorView.y = self.selectedButton.bottom;
    self.indicatorView.centerX = self.selectedButton.centerX;
    
    self.separatorLine.width = width;
    self.separatorLine.height = 0.5;
    self.separatorLine.x = 0;
    self.separatorLine.bottom = height;
    
}

- (void)itemTouchUpInside:(XFNoHighlightButton *)sender {
    
    sender.selected = YES;
    if (self.selectedButton) {
        self.selectedButton.selected = NO;
    }
    self.selectedButton = sender;
    
    [UIView animateWithDuration:0.2f animations:^{
        self.indicatorView.width = [self indicatorViewWidth];
        self.indicatorView.centerX = self.selectedButton.centerX;
    }];
    
    if ([self.delegate respondsToSelector:@selector(segmentView:didSelectedIndex:)]) {
        [self.delegate segmentView:self didSelectedIndex:sender.tag];
    }
}

- (void)selectIndex:(NSInteger)index {
    [self itemTouchUpInside:self.titleButtons[index]];
}

- (CGFloat)indicatorViewWidth {
    CGFloat width = 0.0f;
    NSString *title = self.titles[self.selectedButton.tag];
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:14]};
    CGSize titleSize = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, self.selectedButton.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    width = titleSize.width;
    return width;

}
#pragma mark - LazyLoad

- (NSMutableArray *)titleButtons {
    if (!_titleButtons) {
        _titleButtons = [NSMutableArray arrayWithCapacity:self.titles.count];
    }
    return _titleButtons;
}

- (UIView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [UIView new];
        _indicatorView.backgroundColor = [UIColor colorDomina];
    }
    return _indicatorView;
}

- (UIView *)separatorLine {
    if (!_separatorLine) {
        _separatorLine = [UIView new];
        _separatorLine.backgroundColor = [UIColor colorSeparatorLine];
    }
    return _separatorLine;
}

@end
