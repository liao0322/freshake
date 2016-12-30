//
//  FSNetErrorView.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/30.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSNetErrorView.h"

@interface FSNetErrorView ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@end

@implementation FSNetErrorView


- (void)layoutSubviews {
    [super layoutSubviews];
    [self.imageView sizeToFit];
    self.imageView.center = self.center;
}

@end
