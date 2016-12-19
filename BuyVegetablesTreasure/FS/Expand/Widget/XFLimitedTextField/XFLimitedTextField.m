//
//  XFLimitedTextField.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/12.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "XFLimitedTextField.h"

@implementation XFLimitedTextField

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:@"UITextFieldTextDidChangeNotification" object:nil];
}

- (void)textFieldDidChange {
    UITextRange *selectedRange = [self markedTextRange];
    // 获取高亮部分
    UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
    if (!position) { // 没有高亮
        [self checkWithTextField:self];
    }
}

- (void)checkWithTextField:(UITextField *)textField {
    if (textField.text.length > self.maxCount) {
        textField.text = [textField.text substringToIndex:self.maxCount];
    }
    NSInteger wordRemain = self.maxCount - textField.text.length;
    if (wordRemain < 0) {
        wordRemain = 0;
    }
    //    _mainView.lbWordLimit.text = [NSString stringWithFormat:@"%ld", (long)wordRemain];
}

@end
