//
//  FSNoDataView.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/29.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSNoDataView.h"

@interface FSNoDataView ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation FSNoDataView

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.imageView sizeToFit];
    
    
    self.imageView.centerX = self.width * 0.5;
    self.imageView.centerY = self.height * 0.5;
}

@end
