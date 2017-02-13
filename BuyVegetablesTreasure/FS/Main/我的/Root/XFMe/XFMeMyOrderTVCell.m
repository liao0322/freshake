//
//  XFMeMyOrderTVCell.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2017/2/10.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import "XFMeMyOrderTVCell.h"
#import <Masonry.h>
#import "XFMeVerticalButton.h"

@interface XFMeMyOrderTVCell ()

@property (weak, nonatomic) IBOutlet UIView *separatorLineView;



@end

@implementation XFMeMyOrderTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self setupViews];
    [self.waitForPayButton layoutIfNeeded];

}

- (void)setupViews {
    
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    
    [self.waitForPayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(self.separatorLineView.mas_bottom);
        make.height.equalTo(@(self.waitForPayButton.xf_height));
        make.bottomMargin.equalTo(@0);
    }];
    [self.waitForPickUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.waitForPayButton);
        make.top.equalTo(self.waitForPayButton);
        make.left.equalTo(self.waitForPayButton.mas_right);
    }];
    [self.pickedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.waitForPickUpButton);
        make.top.equalTo(self.waitForPayButton);
        make.left.equalTo(self.waitForPickUpButton.mas_right);
    }];
    [self.waitForCommentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.pickedButton);
        make.top.equalTo(self.waitForPayButton);
        make.left.equalTo(self.pickedButton.mas_right);
        make.rightMargin.equalTo(@0);
    }];
    
    [super updateConstraints];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)viewAllOrders:(id)sender {
    if (self.viewAllOrdersBlock) {
        self.viewAllOrdersBlock();
    }
}

- (IBAction)waitForPay:(id)sender {
    if (self.waitForPayBlock) {
        self.waitForPayBlock();
    }
}

- (IBAction)waitForPickUp:(id)sender {
    if (self.waitForPickUpBlock) {
        self.waitForPickUpBlock();
    }
}

- (IBAction)picked:(id)sender {
    if (self.pickedBlock) {
        self.pickedBlock();
    }
}
- (IBAction)waitForComment:(id)sender {
    if (self.waitForCommentBlock) {
        self.waitForCommentBlock();
    }
}


@end
