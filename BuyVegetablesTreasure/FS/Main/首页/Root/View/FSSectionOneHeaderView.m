//
//  FSSectionOneHeaderView.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/14.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSSectionOneHeaderView.h"

@implementation FSSectionOneHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorViewBG];
    
    [self.recommendButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.recommendButton.width = self.width;
}
@end
