//
//  CookingDetailsCell.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/4/29.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "CookingDetailsCell.h"
#import "XSMediaPlayer.h"

@interface CookingDetailsCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *materialLabel;
@property (nonatomic, strong) UILabel *stepsLabel;

@end

@implementation CookingDetailsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initCell];
    }
    
    return self;
}

- (void)initCell {
    
    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont systemFontOfSize:17];
    _nameLabel.textColor = Color;
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_nameLabel];
    
    _nameLabel.sd_layout
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .topSpaceToView(self.contentView, 0)
    .heightIs(45);
    
    UILabel *line = [UILabel new];
    line.backgroundColor = Color;
    [self.contentView addSubview:line];
    
    line.sd_layout
    .leftSpaceToView(self.contentView, 5)
    .rightSpaceToView(self.contentView, 5)
    .topSpaceToView(_nameLabel, 0)
    .heightIs(1);
    
    UILabel *materialTitleLabel = [UILabel new];
    materialTitleLabel.text = @"材料准备";
    materialTitleLabel.font = [UIFont systemFontOfSize:15];
    materialTitleLabel.textColor = Color;
    [self.contentView addSubview:materialTitleLabel];
    
    materialTitleLabel.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15)
    .topSpaceToView(line, 25)
    .heightIs(15);
    
    _materialLabel = [UILabel new];
    _materialLabel.font = [UIFont systemFontOfSize:13];
    _materialLabel.textColor = [UIColor colorWithHexString:@"0x797878"];
    [self.contentView addSubview:_materialLabel];
    
    _materialLabel.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15)
    .topSpaceToView(materialTitleLabel, 10)
    .autoHeightRatio(0);
    
    UILabel *stepsTitleLabel = [UILabel new];
    stepsTitleLabel.text = @"详细步骤";
    stepsTitleLabel.font = [UIFont systemFontOfSize:15];
    stepsTitleLabel.textColor = Color;
    [self.contentView addSubview:stepsTitleLabel];
    
    stepsTitleLabel.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15)
    .topSpaceToView(_materialLabel, 40)
    .heightIs(15);
    
    _stepsLabel = [UILabel new];
    _stepsLabel.font = [UIFont systemFontOfSize:13];
    _stepsLabel.textColor = [UIColor colorWithHexString:@"0x797878"];
    [self.contentView addSubview:_stepsLabel];
    
    _stepsLabel.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15)
    .topSpaceToView(stepsTitleLabel, 10)
    .autoHeightRatio(0);
    
    [self setupAutoHeightWithBottomView:_stepsLabel bottomMargin:25];
}

- (void)setModel:(CookingProgramListModel *)model {
    
    _nameLabel.text = model.Title;
    _materialLabel.text = [self filterHTML:model.Material];
    _stepsLabel.text = [self filterHTML:model.Practice];
}

- (NSString *)filterHTML:(NSString *)html {
    
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    
    while ([scanner isAtEnd] == NO) {
        
        [scanner scanUpToString:@"<" intoString:nil];
        [scanner scanUpToString:@">" intoString:&text];
        
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    
    scanner = [NSScanner scannerWithString:html];
    text = nil;
    
    while ([scanner isAtEnd] == NO) {
        
        [scanner scanUpToString:@"&" intoString:nil];
        [scanner scanUpToString:@";" intoString:&text];
        
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@;",text] withString:@" "];
    }
    
    // 过滤所有以<开头以>结尾的标签
//    NSString *regxpForHtml = @"<([^>]*)>";
    // 找出IMG标签
//    NSString *regxpForImgTag = @"<\\s*img\\s+([^>]*)\\s*>";
    // 找出IMG标签的SRC属性
//    NSString *regxpForImaTagSrcAttrib = @"src=\"([^\"]+)\"";
    
    // html = [html stringByReplacingOccurrencesOfString:regxpForHtml withString:@""];
    
    return html;
}

@end
