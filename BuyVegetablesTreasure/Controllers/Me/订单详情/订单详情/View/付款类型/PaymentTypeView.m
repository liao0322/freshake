//
//  PaymentTypeView.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/9/7.
//
//

#import "PaymentTypeView.h"

@implementation PaymentTypeView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.600];
        
        UIWindow *window = [[UIApplication sharedApplication].delegate window];
        [window addSubview:self];
        
        self.sd_layout
        .leftEqualToView(window)
        .rightEqualToView(window)
        .topEqualToView(window)
        .bottomEqualToView(window);
        
        [self initPayView];
    }
    
    return self;
}

- (void)initPayView {
    
    UIView *paymentTypeBgView = [UIView new];
    paymentTypeBgView.backgroundColor = [UIColor whiteColor];
    paymentTypeBgView.layer.borderColor = LineColor.CGColor;
    paymentTypeBgView.layer.borderWidth = 0.5;
    paymentTypeBgView.layer.cornerRadius = 5;
    paymentTypeBgView.layer.masksToBounds = YES;
    [self addSubview:paymentTypeBgView];
    
    paymentTypeBgView.sd_layout
    .centerXEqualToView(self)
    .centerYEqualToView(self)
    .leftSpaceToView(self, 15)
    .rightSpaceToView(self, 15)
    .heightIs(150);
    
    NSArray *payTextArray = @[@"余额支付",@"微信支付",@"支付宝支付"];
    NSArray *payImageArray = @[@"余额付款",@"微信支付图标",@"支付宝图标"];
    for (int i = 0; i < payTextArray.count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 5 + i;
        [btn addTarget:self action:@selector(selectPayType:) forControlEvents:UIControlEventTouchUpInside];
        [paymentTypeBgView addSubview:btn];
        
        btn.sd_layout
        .leftEqualToView(paymentTypeBgView)
        .rightEqualToView(paymentTypeBgView)
        .topSpaceToView(paymentTypeBgView, 50 * i)
        .heightIs(50);
        
        UILabel *payTextLabel = [UILabel new];
        payTextLabel.text = payTextArray[i];
        payTextLabel.font = [UIFont systemFontOfSize:13];
        payTextLabel.textColor = [UIColor blackColor];
        [payTextLabel setSingleLineAutoResizeWithMaxWidth:100];
        [btn addSubview:payTextLabel];
        
        payTextLabel.sd_layout
        .centerXEqualToView(btn)
        .centerYEqualToView(btn)
        .heightIs(15);
        
        UIImageView *imgView = [UIImageView new];
        imgView.image = IMAGE(payImageArray[i]);
        [btn addSubview:imgView];
        
        imgView.sd_layout
        .rightSpaceToView(payTextLabel, 30)
        .centerYEqualToView(payTextLabel)
        .widthIs(20)
        .heightEqualToWidth();
        
        if (i == 1) {
            
            btn.layer.borderWidth = 0.5;
            btn.layer.borderColor = LineColor.CGColor;
        }
    }
}

// 支付方式
- (void)selectPayType:(UIButton *)btn {
    
    NSString *paymentIdString = @"2";
    if (btn.tag == 7) {
        paymentIdString = @"3";
    }
    else if (btn.tag == 6) {
        paymentIdString = @"4";
    }
    
    _paymentId(paymentIdString);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.hidden = YES;
}

@end
