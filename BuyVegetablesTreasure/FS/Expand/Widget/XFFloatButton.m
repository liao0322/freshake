//
//  XFFloatButton.m
//  temp
//
//  Created by DamonLiao on 2017/3/29.
//  Copyright © 2017年 DamonLiao. All rights reserved.
//

#import "XFFloatButton.h"

static CGFloat const ButtonWH = 67.0f;

@implementation XFFloatButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - ButtonWH - 11.0f, [UIScreen mainScreen].bounds.size.height - 49.0f - ButtonWH - 3.0f, ButtonWH, ButtonWH)];
    
    if (self) {
        self.adjustsImageWhenHighlighted = NO;
        [self setImage:[UIImage imageNamed:@"icon_binding_phone"] forState:UIControlStateNormal];
    }
    return self;
}

+ (instancetype)floatButton {
    return [self buttonWithType:UIButtonTypeCustom];
}

- (void)show {
    [UIView animateWithDuration:.3f animations:^{
        self.transform = CGAffineTransformIdentity;
    }];
}

- (void)hidden {
    
    [UIView animateWithDuration:.3f animations:^{
        self.transform = CGAffineTransformTranslate(self.transform, self.frame.size.width, 0);
    }];
}

- (BOOL)isHidden {
    return self.transform.tx != CGAffineTransformIdentity.tx;
}


@end
