//
//  AdvertisingCell.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/12/8.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "AdvertisingCell.h"

@implementation AdvertisingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor colorWithHexString:@"0xf8f8f8"];
        
        [self initAdvertisingCell];
    }
    
    return self;
}

- (void)initAdvertisingCell {
    
    self.advertisingImgView = [[UIImageView alloc] init];
    self.advertisingImgView.backgroundColor = [UIColor whiteColor];
    self.advertisingImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.advertisingImgView.clipsToBounds = YES;
    self.advertisingImgView.layer.borderWidth = 0.5;
    self.advertisingImgView.layer.borderColor = LineColor.CGColor;
    [self.contentView addSubview:self.advertisingImgView];
    
    self.advertisingImgView.sd_layout
    .leftSpaceToView(self.contentView, HomePageSpacing)
    .rightSpaceToView(self.contentView, HomePageSpacing)
    .topSpaceToView(self.contentView, HomePageSpacing)
    .heightIs((ScreenWidth - HomePageSpacing * 2) / 5 * 2);
}

- (void)setModel:(AdvertisingModel *)model {
    
    self.advertisingImgView.image = model.img != nil ? model.img : model.defaultImg;
}

@end
