//
//  XFExpressDetailsFirstLineTVCell.m
//  InnerForCourier
//
//  Created by DamonLiao on 2017/2/7.
//  Copyright © 2017年 DamonLiao. All rights reserved.
//

#import "XFExpressDetailsFirstLineTVCell.h"


@interface XFExpressDetailsFirstLineTVCell ()

@property (weak, nonatomic) IBOutlet UIView *iconBGView;

@end

@implementation XFExpressDetailsFirstLineTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.iconBGView.layer.borderColor = [UIColor grayColor].CGColor;
    self.iconBGView.layer.borderWidth = 0.3;
}

- (IBAction)phoneNumberButtonTouchUpInside:(UIButton *)sender {
    NSLog(@"打电话");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4001725757"] options:@{} completionHandler:^(BOOL success) {
        
    }];
}
@end
