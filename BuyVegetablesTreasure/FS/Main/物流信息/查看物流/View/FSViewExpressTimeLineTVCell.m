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
@property (nonatomic) UIView *locatingPointView;

@property (nonatomic) TTTAttributedLabel *contentLabel;


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
    [self.contentView addSubview:self.contentLabel];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.timeLineView.width = 1;
    self.timeLineView.height = self.height;
    self.timeLineView.x = 10;
    self.timeLineView.y = 0;
    
    
}

#pragma mark - LazyLoad

- (UIView *)timeLineView {
    if (!_timeLineView) {
        _timeLineView = [UIView new];
        _timeLineView.backgroundColor = [UIColor grayColor];
    }
    return _timeLineView;
}

- (TTTAttributedLabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
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

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    
}
@end
