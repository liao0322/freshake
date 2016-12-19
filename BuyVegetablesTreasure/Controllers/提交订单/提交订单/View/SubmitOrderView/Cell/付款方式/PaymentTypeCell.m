//
//  PaymentTypeCell.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/9/9.
//
//

#import "PaymentTypeCell.h"

@implementation PaymentTypeCell

- (void)setCurrentIndex:(NSInteger)currentIndex {
    
    if (self.paymentBtn == nil) {
        
        UIImage *img = IMAGE(@"Cancel_Payment");
        self.paymentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.paymentBtn.tag = currentIndex + 70;
        [self.paymentBtn setImage:img forState:UIControlStateNormal];
        [self.paymentBtn setImage:IMAGE(@"Select_Payment") forState:UIControlStateSelected];
        
        self.paymentBtn.sd_layout
        .leftEqualToView(self.accessoryView)
        .topEqualToView(self.accessoryView)
        .widthIs(img.size.width)
        .heightIs(img.size.height);
        
        if (currentIndex == 1) {
            self.paymentBtn.selected = YES;
        }
        
        UILabel *line = [UILabel new];
        line.backgroundColor = LineColor;
        [self addSubview:line];
        
        line.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .bottomEqualToView(self)
        .heightIs(0.5);
    }
    
    NSArray *payTextArray = @[@"余额支付",@"微信支付",@"支付宝支付"];
    NSArray *payImageArray = @[@"余额付款",@"微信支付图标",@"支付宝图标"];

    self.accessoryView   = self.paymentBtn;
    self.imageView.image = IMAGE(payImageArray[currentIndex]);
    self.textLabel.text  = payTextArray[currentIndex];
    self.textLabel.font  = [UIFont systemFontOfSize:14];
    self.selectionStyle  = UITableViewCellSelectionStyleNone;
}

- (void)setPayId:(NSInteger)payId {
    
    if (payId == 1) {
        [Single sharedInstance].payMent = 2;
    }
    else if (payId == 2) {
        [Single sharedInstance].payMent = 4;
    }
    else {
        [Single sharedInstance].payMent = 3;
    }
    
    for (int i = 0; i < 3; i++) {
        
        [(UIButton *)[self viewWithTag:i + 70] setSelected:NO];
    }
    
    [(UIButton *)[self viewWithTag:payId + 69] setSelected:YES];
}

@end
