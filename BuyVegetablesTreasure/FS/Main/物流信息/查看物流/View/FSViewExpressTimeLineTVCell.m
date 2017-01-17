//
//  FSViewExpressTimeLineTVCell.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2017/1/16.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import "FSViewExpressTimeLineTVCell.h"
#import "TTTAttributedLabel.h"

@interface FSViewExpressTimeLineTVCell ()<TTTAttributedLabelDelegate>

@property (nonatomic) UIView *timeLineView;
@property (nonatomic) UIButton *locatingPointButton;

@property (nonatomic) TTTAttributedLabel *contentLabel;

@property (nonatomic) UILabel *dateLabel;



@end

@implementation FSViewExpressTimeLineTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews {
    [self.contentView addSubview:self.timeLineView];
    [self.contentView addSubview:self.locatingPointButton];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.dateLabel];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.timeLineView.width = 1;
    self.timeLineView.height = self.height;
    self.timeLineView.x = 35;
    self.timeLineView.y = 0;
    
    self.locatingPointButton.width = 18;
    self.locatingPointButton.height = 18;
    self.locatingPointButton.y = 10;
    self.locatingPointButton.centerX = self.timeLineView.centerX;
    
    self.contentLabel.width = 100;
    self.contentLabel.height = 50;
    self.contentLabel.x = 70;
    self.contentLabel.y = 10;
    
    
    [self.dateLabel sizeToFit];
    self.dateLabel.x = 70;
    self.dateLabel.bottom = self.height;
    
}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    
}



#pragma mark - LazyLoad

- (UIView *)timeLineView {
    if (!_timeLineView) {
        _timeLineView = [UIView new];
        _timeLineView.backgroundColor = [UIColor colorWithRGBHex:0xd0d0d0];
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
        [_contentLabel setText:@"aa"];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = [UIColor orangeColor];
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
        [_dateLabel setText:@"2016-12-18 14:12:19"];
        [_dateLabel setFont:[UIFont systemFontOfSize:14]];
        
    }
    return _dateLabel;
}
@end
