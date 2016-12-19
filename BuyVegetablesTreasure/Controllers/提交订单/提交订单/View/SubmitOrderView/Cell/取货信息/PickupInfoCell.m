//
//  PickupInfoCell.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/9/12.
//
//

#import "PickupInfoCell.h"

@implementation PickupInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self initCell];
    }
    
    return self;
}

- (void)initCell {

    NSArray *titles = @[@"收货人:", @"电 话:", @"收货地址:"];
    UILabel *pickUpInfoLabel;
    for (int i = 0; i < 3; i++) {
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.text = titles[i];
        titleLabel.font = TextFontSize;
        titleLabel.textColor = Color;
        titleLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:titleLabel];
        
        titleLabel.sd_layout
        .leftSpaceToView(self.contentView, 15)
        .topSpaceToView(self.contentView, 15 + 25 * i)
        .heightIs(15)
        .widthIs(65);
        
        pickUpInfoLabel = [UILabel new];
        pickUpInfoLabel.tag = i + 50;
        pickUpInfoLabel.font = TextFontSize;
        pickUpInfoLabel.textColor = TextColor;
        [self.contentView addSubview:pickUpInfoLabel];
        
        pickUpInfoLabel.sd_layout
        .leftSpaceToView(titleLabel, 10)
        .rightSpaceToView(self.contentView, 15);
        
        if (i == 2) {
            
            pickUpInfoLabel.sd_layout
            .autoHeightRatio(0)
            .topSpaceToView([self viewWithTag:51], 10);
        }
        else {
            
            pickUpInfoLabel.sd_layout
            .heightIs(15)
            .centerYEqualToView(titleLabel);;
        }
    }
    
    UILabel *line = [UILabel new];
    line.backgroundColor = LineColor;
    [self addSubview:line];
    
    line.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .bottomEqualToView(self)
    .heightIs(0.5);
    
    [self setupAutoHeightWithBottomView:pickUpInfoLabel bottomMargin:15];
}

- (void)setModel:(SiteModel *)model {
    
    NSString *nameString = [NSString stringWithFormat:@"%@ %@",model.userName, [model.sex boolValue] ? @"先生" : @"女士"];
    NSString *addressString = [NSString stringWithFormat:@"%@ %@ %@",model.City, model.Area, model.Address];
    
    NSArray *arr = @[nameString, model.Phone, addressString];
    for (int i = 0; i < 3; i++) {
        [(UILabel *)[self viewWithTag:i + 50] setText:arr[i]];
    }
}

@end
