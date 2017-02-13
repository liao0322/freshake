//
//  XFExpressDetailsTimeLineTVCell.m
//  InnerForCourier
//
//  Created by DamonLiao on 2017/2/7.
//  Copyright © 2017年 DamonLiao. All rights reserved.
//

#import "XFExpressDetailsTimeLineTVCell.h"
#import "TTTAttributedLabel.h"
#import "UIColor+Extension.h"
#import "XFExpressList.h"

#import <Masonry.h>

@interface XFExpressDetailsTimeLineTVCell ()<TTTAttributedLabelDelegate>

@property (nonatomic) UIView *timeLineView;
@property (nonatomic) UIButton *locatingPointButton;
@property (nonatomic) TTTAttributedLabel *contentLabel;
@property (nonatomic) UILabel *dateLabel;

@end

@implementation XFExpressDetailsTimeLineTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
}

- (void)addSubviews {
    [super addSubviews];
    [self.contentView addSubview:self.timeLineView];
    [self.contentView addSubview:self.locatingPointButton];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.dateLabel];
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)setModel:(XFExpressList *)model {
    _model = model;
    self.dateLabel.text = _model.operTime;
    if (_model.isFirst) {
        self.locatingPointButton.selected = YES;
        self.contentLabel.textColor = [UIColor colorDomina];
        self.dateLabel.textColor = [UIColor colorDomina];
    } else {
        self.locatingPointButton.selected = NO;
        self.contentLabel.textColor = [UIColor grayColor];
        self.dateLabel.textColor = [UIColor grayColor];
    }
    self.contentLabel.text = _model.remark;
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    [self.timeLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@1);
        make.left.equalTo(@35);
    }];
    
    if (self.model.isFirst) {
        [self.timeLineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.contentView).offset(-19);
            make.top.equalTo(@20);
        }];
    } else {
        [self.timeLineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.contentView).offset(1);
            make.top.equalTo(@0);
        }];
    }
    
    [self.locatingPointButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@18);
        make.top.equalTo(@15);
        make.centerX.equalTo(self.timeLineView);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.locatingPointButton);
        make.left.equalTo(@70);
        make.right.equalTo(self.contentView).offset(-15);
        
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentLabel);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(10);
        make.bottomMargin.equalTo(@-2);
    }];
    [super updateConstraints];
}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {}

#pragma mark - LazyLoad

- (UIView *)timeLineView {
    if (!_timeLineView) {
        _timeLineView = [UIView new];
        _timeLineView.backgroundColor = [UIColor colorWithHex:0xd0d0d0];
    }
    return _timeLineView;
}

- (UIButton *)locatingPointButton {
    if (!_locatingPointButton) {
        _locatingPointButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_locatingPointButton setImage:[UIImage imageNamed:@"express_before"] forState:UIControlStateNormal];
        [_locatingPointButton setImage:[UIImage imageNamed:@"express_current"] forState:UIControlStateSelected];
    }
    return _locatingPointButton;
}

- (TTTAttributedLabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        _contentLabel.numberOfLines = 0;
//        _contentLabel.textColor = [UIColor grayColor];
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.lineBreakMode = NSLineBreakByCharWrapping; //设置文字过长时的显示格式
        _contentLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
        _contentLabel.activeLinkAttributes = nil; // 取消链接文字高亮时的格式
        
        // 设置链接样式
        NSDictionary *linkAttributes = @{(NSString *)kCTUnderlineStyleAttributeName: @NO, // 去掉下划线
                                         (NSString *)kCTForegroundColorAttributeName: [UIColor orangeColor]}; // 设置颜色
        
        _contentLabel.linkAttributes = linkAttributes;
        _contentLabel.delegate = self;
    }
    return _contentLabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        [_dateLabel setFont:[UIFont systemFontOfSize:11]];
        _dateLabel.textColor = [UIColor grayColor];
        
    }
    return _dateLabel;
}

@end
