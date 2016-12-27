//
//  AmountTextField.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/11/28.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "AmountTextField.h"

@interface AmountTextField ()

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *amountBtn;

@end

@implementation AmountTextField

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self initAmountTextField];
    }
    return self;
}

- (void)initAmountTextField {
    
    self.backgroundColor = [UIColor whiteColor];
    // 充值按钮
    self.amountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.amountBtn.backgroundColor = [UIColor colorDomina];
    self.amountBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.amountBtn setTitle:@"立即充值" forState:UIControlStateNormal];
    [self.amountBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.amountBtn addTarget:self
                       action:@selector(btnClick)
             forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.amountBtn];
    
    self.amountBtn.sd_layout
    .rightEqualToView(self)
    .bottomEqualToView(self)
    .topEqualToView(self)
    .widthIs(ScreenWidth / 3);
    
    // 文本框背景
    UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor colorWithHexString:@"0xececec"];
    bgView.layer.cornerRadius = 5;
    [self addSubview:bgView];
    
    bgView.sd_layout
    .leftSpaceToView(self, 10)
    .rightSpaceToView(self.amountBtn, 10)
    .topSpaceToView(self, 5)
    .bottomSpaceToView(self, 5);
    
    self.textField = [UITextField new];
    self.textField.placeholder = @"请输入充值金额";
    self.textField.font = [UIFont systemFontOfSize:14];
    self.textField.keyboardType = UIKeyboardTypeDecimalPad;
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.textField addTarget:self
                       action:@selector(textFieldEditChanged:)
             forControlEvents:UIControlEventEditingChanged];
    [bgView addSubview:self.textField];
    
    self.textField.sd_layout
    .leftSpaceToView(bgView, 10)
    .rightSpaceToView(bgView, 10)
    .topEqualToView(bgView)
    .bottomEqualToView(bgView);
}

- (void)textFieldEditChanged:(UITextField *)textField {
    
    NSArray *countArray = [textField.text componentsSeparatedByString:@"."];
    
    if (countArray.count > 1) {
        
        int a = 0;
        for (int i = 0; i < textField.text.length; i++) {
            
            NSString *string = [textField.text substringWithRange:NSMakeRange(i, 1)];
            if ([string isEqualToString:@"."]) {
                a++;
                if (a > 1) {
                    textField.text = [textField.text substringToIndex:textField.text.length - 1];
                }
            }
        }
        
        if ([countArray[1] lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] / 2 > 2) {
            
            textField.text = [textField.text substringToIndex:[countArray[0] lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] / 2 + 3];
        }
    }
}

- (void)btnClick {
    self.amountBlock(self.textField.text, @"0");
}

@end
