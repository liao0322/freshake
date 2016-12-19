//
//  HomeAddressCell.m
//  BuyVegetablesTreasure
//
//  Created by Song on 16/3/31.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "HomeAddressCell.h"

@implementation HomeAddressCell
{
    UIView *line;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initCell];
    }
    
    return self;
}

- (void)initCell
{
    NSArray *titleArry = @[@"收货人:",@"电 话:",@"收货地址:"];
    for (int i = 0; i<3; i++)
    {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15 + 25 * i, 80, 25)];
        titleLabel.text = titleArry[i];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textColor = [UIColor colorWithHexString:@"0xff6600"];
        titleLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:titleLabel];
        
        UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame) + 10, 15 + 25 * i, SCREEN_WIDTH - CGRectGetMaxX(titleLabel.frame)-15, 25)];
        addressLabel.font = [UIFont systemFontOfSize:15];
        addressLabel.textColor = [UIColor colorWithHexString:@"0x464D60"];
        addressLabel.tag = 44 + i;
        [self.contentView addSubview:addressLabel];
    }
    
    if (line == nil) {
        line = [[UIView alloc]initWithFrame:CGRectMake(0, 99, ScreenWidth, 1)];
    }
    line.backgroundColor=[UIColor colorWithHexString:@"0xd7d7d7"];
    [self addSubview:line];

    
    
    
}
-(void)setData:(SiteModel *)siteModel
{
    UILabel *nameLabel = (UILabel *)[self viewWithTag:44];
    UILabel *phoneLabel = (UILabel *)[self viewWithTag:45];
    UILabel *addressLabel = (UILabel *)[self viewWithTag:46];
    
    nameLabel.text = [NSString stringWithFormat:@"%@ %@",siteModel.userName,[siteModel.sex boolValue] ? @"先生" : @"女士"];
    phoneLabel.text = siteModel.Phone;
    addressLabel.text = [NSString stringWithFormat:@"%@%@%@",siteModel.City,siteModel.Area,siteModel.Address];
    
}

@end
