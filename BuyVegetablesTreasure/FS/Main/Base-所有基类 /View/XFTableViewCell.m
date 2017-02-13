//
//  XFTableViewCell.m
//  InnerForCourier
//
//  Created by DamonLiao on 2017/2/10.
//  Copyright © 2017年 DamonLiao. All rights reserved.
//

#import "XFTableViewCell.h"

@implementation XFTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews {
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
