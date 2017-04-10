//
//  FSAlertView.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2017/4/5.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import "FSAlertView.h"

@interface FSAlertView ()

@property (weak, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation FSAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


static FSAlertView *alertView;
+ (void)showSuccessWithString:(NSString *)string {
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    alertView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
    alertView.frame = keyWindow.bounds;
    alertView.view.layer.cornerRadius = 5.0f;
    alertView.view.layer.masksToBounds = YES;
    
    alertView.label.text = string;
    
    alertView.button.layer.borderWidth = 0.5f;
    alertView.button.layer.cornerRadius = 3.0f;
    alertView.button.layer.masksToBounds = YES;
    alertView.button.layer.borderColor = [UIColor colorDomina].CGColor;
    
    [keyWindow addSubview:alertView];
}

+ (void)showErrorWithString:(NSString *)string {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    alertView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
    alertView.frame = keyWindow.bounds;
    alertView.view.layer.cornerRadius = 5.0f;
    alertView.view.layer.masksToBounds = YES;
    
    alertView.label.text = string;
    
    alertView.button.layer.borderWidth = 0.5f;
    alertView.button.layer.cornerRadius = 3.0f;
    alertView.button.layer.masksToBounds = YES;
    alertView.button.layer.borderColor = [UIColor colorDomina].CGColor;
    
    alertView.imageView.image = [UIImage imageNamed:@"card失败"];
    
    [keyWindow addSubview:alertView];
}


- (IBAction)closeButtonAction:(id)sender {
    [self removeFromSuperview];
}

@end
