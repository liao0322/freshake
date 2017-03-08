//
//  FSCardExplainViewController.m
//  BuyVegetablesTreasure
//
//  Created by 江玉元 on 2017/3/8.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import "FSCardExplainViewController.h"

#define LINE_SPACING 8.0f

@interface FSCardExplainViewController ()

@property (weak, nonatomic) IBOutlet UILabel *giftCardExplainLabel;

@property (nonatomic, copy) NSString *explainString;

@end

@implementation FSCardExplainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initialize {
    [super initialize];
    if (self.Status == 0) {
        self.title = @"什么是礼品卡";
    }else {
        self.title = @"什么是优惠券";
    }
    
    self.giftCardExplainLabel.text = self.explainString;
    
    [self setLabelSpace:self.giftCardExplainLabel withValue:self.giftCardExplainLabel.text withFont:[UIFont systemFontOfSize:14.0]];

}

#pragma mark - Custom

- (void)setLabelSpace:(UILabel *)label withValue:(NSString *)str withFont:(UIFont *)font {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = LINE_SPACING;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
                          };
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
    label.attributedText = attributeStr;
}

- (NSString *)explainString {
    if (self.Status == 0) {
        return @"鲜摇派礼品卡是鲜摇派独家发行的预付卡，目前仅限上海地区使用，可用于在鲜摇派快捷安全地支付各类产品订单。";
    }
    else return @"鲜摇派优惠券是鲜摇派独家发行的现金抵扣券，目前仅限上海地区使用。";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
