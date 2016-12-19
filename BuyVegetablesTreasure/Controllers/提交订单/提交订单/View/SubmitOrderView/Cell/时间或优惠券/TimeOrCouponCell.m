//
//  TimeOrCouponCell.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/9/13.
//
//

#import "TimeOrCouponCell.h"

@interface TimeOrCouponCell ()

@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UILabel *line;

@end

@implementation TimeOrCouponCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.textLabel.font = [UIFont systemFontOfSize:14];
        self.textLabel.textColor = Color;
        
        [self initCell];
    }
    
    return self;
}

- (void)initCell {
    
    self.rightLabel = [UILabel new];
    self.rightLabel.font = TextFontSize;
    self.rightLabel.textColor = Color;
    self.rightLabel.textAlignment = NSTextAlignmentRight;
    [self.rightLabel setSingleLineAutoResizeWithMaxWidth:200];
    [self.contentView addSubview:self.rightLabel];
    
    self.rightLabel.sd_layout
    .rightSpaceToView(self.contentView, 0)
    .topEqualToView(self.contentView)
    .heightIs(45);
    
    self.line = [UILabel new];
    self.line.backgroundColor = LineColor;
    [self.contentView addSubview:self.line];
    
    self.line.sd_layout
    .leftEqualToView(self.contentView)
    .bottomEqualToView(self.contentView)
    .widthIs(ScreenWidth)
    .heightIs(0.5);
}

- (void)setTimeString:(NSString *)timeString {

    self.textLabel.text = @"请选择配送时间";
    self.rightLabel.text = timeString;
}

- (void)setCouponString:(NSString *)couponString {
    
    self.textLabel.text = @"请选择优惠券";
    self.rightLabel.text = couponString;
}

@end
