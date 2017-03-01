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

@property (weak, nonatomic) IBOutlet UILabel *useStepLabel;

@property (weak, nonatomic) IBOutlet UILabel *useRemindLabel;

@end

@implementation FSGiftCartQuestionAnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

#pragma mark - Override

- (void)initialize {
    [super initialize];
    self.title = @"礼品卡常见问题";
    [self setLabelSpace:self.useStepLabel withValue:self.useStepLabel.text withFont:[UIFont systemFontOfSize:14]];
    [self setLabelSpace:self.useRemindLabel withValue:self.useRemindLabel.text withFont:[UIFont systemFontOfSize:14]];
    
}


#pragma mark - Custom

-(void)setLabelSpace:(UILabel*)label withValue:(NSString*)str withFont:(UIFont*)font {
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

-(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = LINE_SPACING;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
                          };
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}

@end
