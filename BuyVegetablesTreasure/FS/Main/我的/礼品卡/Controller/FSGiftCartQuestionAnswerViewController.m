//
//  FSGiftCartQuestionAnswerViewController.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2017/3/1.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import "FSGiftCartQuestionAnswerViewController.h"

#define LINE_SPACING 8.0f

@interface FSGiftCartQuestionAnswerViewController ()
@property (weak, nonatomic) IBOutlet UILabel *useLabel;

@property (weak, nonatomic) IBOutlet UILabel *useStepLabel;

@property (weak, nonatomic) IBOutlet UILabel *remindLabel;

@property (weak, nonatomic) IBOutlet UILabel *useRemindLabel;

@property (nonatomic, copy) NSString *useString;

@property (nonatomic, copy) NSString *remindString;

@end

@implementation FSGiftCartQuestionAnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

#pragma mark - Override

- (void)initialize {
    [super initialize];
    
    if (self.Status == 0) {
        self.title = @"礼品卡常见问题";
        self.useLabel.text = @"如何领用";
        self.remindLabel.text = @"领用注意事项";
        
    } else {
        self.title = @"优惠券常见问题";
        self.useLabel.text = @"如何兑换";
        self.remindLabel.text = @"兑换注意事项";
    }
    self.useStepLabel.text = self.useString;
    self.useRemindLabel.text = self.remindString;
    [self setLabelSpace:self.useStepLabel withValue:self.useStepLabel.text withFont:[UIFont systemFontOfSize:14]];
    [self setLabelSpace:self.useRemindLabel withValue:self.useRemindLabel.text withFont:[UIFont systemFontOfSize:14]];
    
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


- (NSString *)useString {
    if (self.Status == 0) {
        return @"您可以在鲜摇派首页【我的】-【礼品卡】页面输入框里输入“券号”、“密码”领用。";
    }
    else return @"您可以在鲜摇派首页【我的】-【礼品卡】-【优惠券】页面输入框里输入“兑换码”，此兑换码是兑换优惠券的凭证，成功兑换后将保存至【我的】-【优惠券】中。";
}

- (NSString *)remindString {
    if (self.Status == 0) {
        return @"1） “领用”是指将鲜摇派礼品卡与鲜摇派账户建立关联的操作。\n2）用户必须先将礼品卡领用到自己的鲜摇派账户之后，才能使用该礼品卡在鲜摇派支付订单。\n3）礼品卡领用到鲜摇派账户后，仅可用于支付本鲜摇派账户的订单，不可支付其他鲜摇派账户的订单，也不可再转移至其他鲜摇派账户。\n温馨提示：通过鲜摇派首页【我的】-【礼品卡】、或参加活动获得赠送的礼品卡，鲜摇派将直接充入您的鲜摇派账户里，无需单独领用哦~ ";
    }
    else return @"1）一个兑换码只能兑换一次，不能重复兑换。\n2）优惠券适用购买鲜摇派商品所抵用。\n3）优惠券需在限期内使用有效，逾期作废。\n温馨提示：通过鲜摇派首页【我的】-【礼品卡】-【优惠券】、或参加活动获得赠送的优惠券，鲜摇派将直接下发至您的鲜摇派账户里，无需单独兑换哦~";
}

@end
