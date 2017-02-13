//
//  XFMeBottomTVCell.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2017/2/11.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import "XFMeBottomTVCell.h"
#import <Masonry.h>
#import "XFMeBottomVerticalButton.h"

@interface XFMeBottomTVCell ()

@property (weak, nonatomic) IBOutlet XFMeBottomVerticalButton *myGroupBuyButton;
@property (weak, nonatomic) IBOutlet XFMeBottomVerticalButton *myCouponsButton;

@property (weak, nonatomic) IBOutlet XFMeBottomVerticalButton *myFavouriteButton;
@property (weak, nonatomic) IBOutlet XFMeBottomVerticalButton *myAddressButton;
@property (weak, nonatomic) IBOutlet XFMeBottomVerticalButton *helpCenterButton;
@property (weak, nonatomic) IBOutlet XFMeBottomVerticalButton *customerServiceButton;

@end

@implementation XFMeBottomTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.myGroupBuyButton layoutIfNeeded];
    
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    
    [super updateConstraints];
}

- (IBAction)myGroupBuy:(id)sender {
    if (self.myGroupBuyBlock) {
        self.myGroupBuyBlock();
    }
}

- (IBAction)myCoupons:(id)sender {
    if (self.myCouponsBlock) {
        self.myCouponsBlock();
    }
}

- (IBAction)myFavourite:(id)sender {
    if (self.myFavouriteBlock) {
        self.myFavouriteBlock();
    }
}

- (IBAction)myAddress:(id)sender {
    if (self.myAddressBlock) {
        self.myAddressBlock();
    }
}

- (IBAction)helpCenter:(id)sender {
    if (self.helpCenterBlock) {
        self.helpCenterBlock();
    }
}

- (IBAction)customerService:(id)sender {
    if (self.customerServiceBlock) {
        self.customerServiceBlock();
    }
}
@end
