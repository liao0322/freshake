//
//  FSGiftCardViewController.m
//  BuyVegetablesTreasure
//
//  Created by 江玉元 on 2017/2/21.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import "FSGiftCardViewController.h"
#import "FSGetGiftCardViewController.h"
#import "FSGiftCardProblemViewController.h"
#import "FSGiftCardExplainViewController.h"

@interface FSGiftCardViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (weak, nonatomic) IBOutlet UIView *firstBgView;
@property (weak, nonatomic) IBOutlet UIImageView *getCardImageView;
@property (weak, nonatomic) IBOutlet UILabel *getCardLabel;
@property (weak, nonatomic) IBOutlet UIButton *getCardButton;


@property (weak, nonatomic) IBOutlet UIView *secondBgView;
@property (weak, nonatomic) IBOutlet UIImageView *cardExplainImageView;
@property (weak, nonatomic) IBOutlet UILabel *cardExplainLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cardExplainRowImage;
@property (weak, nonatomic) IBOutlet UIButton *cardExplainButton;

@property (weak, nonatomic) IBOutlet UIImageView *getExplainImageView;
@property (weak, nonatomic) IBOutlet UILabel *getExplainLabel;
@property (weak, nonatomic) IBOutlet UIImageView *getExplainRowImage;
@property (weak, nonatomic) IBOutlet UIButton *getExplainButton;

@property (weak, nonatomic) IBOutlet UIView *secondBgViewLine;

@property (weak, nonatomic) IBOutlet UIView *lineOne;
@property (weak, nonatomic) IBOutlet UIView *lineTwo;
@property (weak, nonatomic) IBOutlet UIView *lineThree;

@end

@implementation FSGiftCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initialization {
    [super initialization];
    
    self.title = @"礼品卡";
    
//    self.firstBgView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    
    self.getCardLabel.textColor = [UIColor colorTextDomina];
    self.cardExplainLabel.textColor = [UIColor colorTextDomina];
    self.getExplainLabel.textColor = [UIColor colorTextDomina];
    
    self.secondBgViewLine.backgroundColor = [UIColor colorSeparatorLine];
    
    self.lineOne.backgroundColor = [UIColor colorSeparatorLine];
    self.lineTwo.backgroundColor = [UIColor colorSeparatorLine];
    self.lineThree.backgroundColor = [UIColor colorSeparatorLine];

}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat width = self.view.width;
    CGFloat margin = 15.0f;
    
    self.firstBgView.x = 0;
    self.firstBgView.y = 64;
    self.firstBgView.width = width;
    
    self.getCardImageView.x = margin * 2;
    self.getCardImageView.y = margin + 8;
    
    self.getCardLabel.x = margin;
    self.getCardLabel.y = self.getCardImageView.bottom + 10;
    
    self.getCardButton.width = width / 4;
    self.getCardButton.height = self.firstBgView.height;
    
    self.lineOne.width = width;
    self.lineTwo.width = width;
    self.lineThree.width = width;
    
    self.secondBgView.x = 0;
    self.secondBgView.y = self.firstBgView.bottom + 10;
    self.secondBgView.width = width;
    
    self.cardExplainImageView.x = margin;
    self.cardExplainImageView.centerY = self.secondBgView.height / 4;
    
    self.cardExplainLabel.x = self.cardExplainImageView.right + 10;
    self.cardExplainLabel.centerY = self.secondBgView.height / 4;
    
    self.cardExplainRowImage.x = width - margin - self.cardExplainRowImage.width;
    self.cardExplainRowImage.centerY = self.secondBgView.height / 4;
    
    self.cardExplainButton.width = width - margin * 2;
    self.cardExplainButton.height = self.secondBgView.height / 2;
    
    self.secondBgViewLine.x = 0;
    self.secondBgViewLine.centerY = self.secondBgView.height / 2;
    self.secondBgViewLine.width = width;
    
    self.getExplainImageView.x = margin;
    self.getExplainImageView.centerY = self.secondBgView.height * 0.75;
    
    self.getExplainLabel.x = self.getExplainImageView.right + 10;
    self.getExplainLabel.centerY = self.secondBgView.height * 0.75;
    
    self.getExplainRowImage.x = width - margin - self.getExplainRowImage.width;
    self.getExplainRowImage.centerY = self.secondBgView.height * 0.75;
    
    self.getExplainButton.y = self.secondBgViewLine.bottom;
    self.getExplainButton.width = width - margin * 2;
    self.getExplainButton.height = self.secondBgView.height / 2;
    
    self.bgImageView.x = 0;
    self.bgImageView.y = 64;
    self.bgImageView.width = width;
    self.bgImageView.height = width / (375 / 398.0f);
    
}

// 领用礼品卡事件
- (IBAction)getCardButtonAction:(id)sender {
    [self.navigationController pushViewController:[FSGetGiftCardViewController new] animated:YES];
    
}

// 礼品卡说明事件
- (IBAction)cardExplainButtonAction:(id)sender {
    [self.navigationController pushViewController:[FSGiftCardExplainViewController new] animated:YES];
}

// 领用礼品卡说明事件
- (IBAction)getExplainButtonAction:(id)sender {
    [self.navigationController pushViewController:[FSGiftCardProblemViewController new] animated:YES];
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
