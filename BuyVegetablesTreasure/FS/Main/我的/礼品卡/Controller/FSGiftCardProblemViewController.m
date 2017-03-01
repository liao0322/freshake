//
//  FSGiftCardProblemViewController.m
//  BuyVegetablesTreasure
//
//  Created by 江玉元 on 2017/2/22.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import "FSGiftCardProblemViewController.h"

@interface FSGiftCardProblemViewController ()

@property (weak, nonatomic) IBOutlet UILabel *useAttentionTitle;
@property (weak, nonatomic) IBOutlet UIView *useAttentionLine;

@property (weak, nonatomic) IBOutlet UIView *useGreenView;
@property (weak, nonatomic) IBOutlet UILabel *useTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *useContentLabel;

@property (weak, nonatomic) IBOutlet UIView *attentionGreenView;
@property (weak, nonatomic) IBOutlet UILabel *attentionTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *attentionContentLabel;


@end

@implementation FSGiftCardProblemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initialization {
    [super initialization];
    self.title = @"礼品卡常见问题";
    
    NSString *useLabelStr = @"您可以在鲜摇派首页【我的】-【礼品卡】页面输入框里输入“券号”、“密码”领用。";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:useLabelStr];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:8.0];
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [useLabelStr length])];
    self.useContentLabel.attributedText = attributedString;
    
    NSString *attentionStr = @"1） “领用”是指将鲜摇派礼品卡与鲜摇派账户建立关联的操作。\n2）用户必须先将礼品卡领用到自己的鲜摇派账户之后，才能使用该礼品卡在鲜摇派支付订单。\n3）礼品卡领用到鲜摇派账户后，仅可用于支付本鲜摇派账户的订单，不可支付其他鲜摇派账户的订单，也不可再转移至其他鲜摇派账户。\n温馨提示：通过鲜摇派首页【我的】-【礼品卡】、或参加活动获得赠送的礼品卡，鲜摇派将直接充入您的鲜摇派账户里，无需单独领用哦~ ";
    NSMutableAttributedString *secondAttributedStr = [[NSMutableAttributedString alloc] initWithString:attentionStr];
    [secondAttributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attentionStr length])];
    self.attentionContentLabel.attributedText = secondAttributedStr;
    
    
    [self.useContentLabel sizeToFit];
    [self.attentionContentLabel sizeToFit];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat width = self.view.width;
    CGFloat margin = 15.0f;
    
    self.useAttentionTitle.x = margin;
    self.useAttentionTitle.y = 64 + 12;
    self.useAttentionTitle.width = width - margin * 2;
    
    self.useAttentionLine.x = margin;
    self.useAttentionLine.y = self.useAttentionTitle.bottom + 12;
    self.useAttentionLine.width = width - margin * 4;
    
    self.useGreenView.x = margin;
    self.useGreenView.y = self.useAttentionLine.bottom + 12;
    
    self.useTitleLabel.x = self.useGreenView.right + 10;
    self.useTitleLabel.centerY = self.useGreenView.centerY;
    self.useTitleLabel.width = width / 2;
    
    self.useContentLabel.x = self.useTitleLabel.x;
    self.useContentLabel.y = self.useTitleLabel.bottom + 12;
    self.useContentLabel.width = width - margin * 4;
    self.useContentLabel.sd_layout
    .autoHeightRatio(0);
    
    self.attentionGreenView.x = margin;
    self.attentionGreenView.y = self.useContentLabel.bottom + 12;
    
    self.attentionTitleLabel.x = self.attentionGreenView.right + 10;
    self.attentionTitleLabel.centerY = self.attentionGreenView.centerY;
    self.attentionTitleLabel.width = width / 2;
    
    self.attentionContentLabel.x = self.attentionTitleLabel.x;
    self.attentionContentLabel.y = self.attentionTitleLabel.bottom + 12;
    self.attentionContentLabel.width = width - margin * 4;
    self.attentionContentLabel.sd_layout
    .autoHeightRatio(0);
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
