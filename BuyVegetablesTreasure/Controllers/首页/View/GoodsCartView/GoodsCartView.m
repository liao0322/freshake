//
//  GoodsCartView.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/12/12.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "GoodsCartView.h"

@interface GoodsCartView ()

@property (nonatomic, strong) UILabel *numberLabel;

@end


@implementation GoodsCartView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setImage:IMAGE(@"购物车背景") forState:UIControlStateNormal];
        [self initGoodsCartView];
    }
    return self;
}

- (void)initGoodsCartView {
    
    [self addTarget:self
             action:@selector(wasDragged:withEvent:)
   forControlEvents:UIControlEventTouchDragInside];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(goShoppingCart)];
    [self addGestureRecognizer:tap];
    
    UIImage *img = IMAGE(@"数字圈");
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    [self addSubview:imgView];
    
    imgView.sd_layout
    .centerXEqualToView(self)
    .topSpaceToView(self, 5)
    .widthIs(15)
    .heightIs(10);
    
    self.numberLabel = [UILabel new];
    self.numberLabel.text = @"0";
    self.numberLabel.font = [UIFont systemFontOfSize:8];
    self.numberLabel.textColor = [UIColor blackColor];
    self.numberLabel.textAlignment = NSTextAlignmentCenter;
    [imgView addSubview:self.numberLabel];
    
    self.numberLabel.sd_layout
    .centerXEqualToView(imgView)
    .centerYEqualToView(imgView)
    .widthIs(15)
    .heightIs(10);
}

// 前往购物车
- (void)goShoppingCart {
    self.goViewController([NSClassFromString(@"GoodsCartViewController") new]);
}

// 移动button
- (void)wasDragged:(UIButton *)button withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event touchesForView:button] anyObject];
    
    CGPoint previousLocation = [touch previousLocationInView:button];
    CGPoint location = [touch locationInView:button];
    CGFloat delta_y = location.y - previousLocation.y;
    
    CGRect frame = button.frame;
    if (frame.origin.y < 60) {
        frame.origin.y = 60;
    }
    else if (frame.origin.y > ScreenHeight - 165) {
        frame.origin.y = ScreenHeight - 165;
    }
    
    button.frame = frame;
    button.center = CGPointMake(button.center.x, button.center.y + delta_y);
}

- (void)setNumberString:(NSString *)numberString {
    _numberLabel.text = numberString;
}


@end
