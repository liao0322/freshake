//
//  UIImageView+category.m
//  eatToLiveAround
//
//  Created by sc on 15-5-20.
//  Copyright (c) 2015年 ZG. All rights reserved.
//

#import "UIImageView+category.h"

@implementation UIImageView (category)

- (void)doCircleFrame {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.frame.size.width/2;
}
@end
