//
//  OtherDetailsCell.m
//  VegetablesApp
//
//  Created by M on 16/5/31.
//  Copyright © 2016年 M. All rights reserved.
//

#import "OtherDetailsCell.h"

@implementation OtherDetailsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initCell];
    }
    
    return self;
}

- (void)initCell {
    
    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    _nameLabel.textColor = [UIColor colorWithHexString:@"0x606060"];
    _nameLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_nameLabel];
    
    _nameLabel.sd_layout
    .leftEqualToView(self.contentView)
    .topEqualToView(self.contentView)
    .widthIs(80)
    .heightIs(40);
    
    _valueLabel = [UILabel new];
    _valueLabel.font = [UIFont systemFontOfSize:14];
    _valueLabel.textColor = [UIColor colorWithHexString:@"0x606060"];
    _valueLabel.numberOfLines = 0;
    [self.contentView addSubview:_valueLabel];
    
    _valueLabel.sd_layout
    .topSpaceToView(self.contentView, 0)
    .leftSpaceToView(_nameLabel, 15)
    .rightSpaceToView(self.contentView, 15)
    .heightIs(40);
    
    UILabel *line = [UILabel new];
    line.backgroundColor = [UIColor colorWithHexString:@"0xd7d7d7"];
    [self.contentView addSubview:line];
    
    line.sd_layout
    .topSpaceToView(_valueLabel, 0)
    .rightSpaceToView(self.contentView, 0)
    .leftSpaceToView(self.contentView, 0)
    .heightIs(0.5);
    
    [self setupAutoHeightWithBottomView:line bottomMargin:0];
}

@end
