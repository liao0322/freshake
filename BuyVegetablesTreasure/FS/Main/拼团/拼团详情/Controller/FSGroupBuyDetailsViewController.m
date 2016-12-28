//
//  FSGroupBuyDetailsViewController.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/27.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSGroupBuyDetailsViewController.h"
#import "GroupModel.h"
#import "SubmitOrderViewController.h"
#import "SubmitGroupViewController.h"
#import "ShopCart.h"
#import "FSLoginViewController.h"
#import "FSNavigationController.h"

#import "FSGroupBuyHelperViewController.h"

@interface FSGroupBuyDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupPriceTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *salePriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *helpButton;
@property (weak, nonatomic) IBOutlet UIView *singleBuyBGView;
@property (weak, nonatomic) IBOutlet UILabel *singleBuyPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *singleBuyButton;

@property (weak, nonatomic) IBOutlet UIView *groupBuyBGView;
@property (weak, nonatomic) IBOutlet UILabel *groupBuyPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *groupBuyButton;


@end

@implementation FSGroupBuyDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)initialization {
    [super initialization];
    
    self.title = @"拼团详情";
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:_model.thumbnailsUrll] placeholderImage:[UIImage imageWithColor:[UIColor colorViewBG]]];
    
    [self.titleLabel setText:_model.ProductName];
    [self.descLabel setText:_model.shortDesc];
    [self.groupPriceLabel setText:_model.ActivityPrice];
    [self.groupPriceTitleLabel setText:@"团购价￥"];
//    [self.salePriceLabel setText:[NSString stringWithFormat:@"原价￥%@", _model.salePrice]];
    [self.salePriceLabel sizeToFit];
    
    [self.helpButton setTitle:[NSString stringWithFormat:@"需%@人成团，详见拼团玩法 >", _model.ActivityUserNum] forState:UIControlStateNormal];
    
    self.singleBuyBGView.layer.cornerRadius = 10;
    self.singleBuyBGView.layer.masksToBounds = YES;

    
    self.groupBuyBGView.layer.cornerRadius = 10;
    self.groupBuyBGView.layer.masksToBounds = YES;
    
    
    NSString *salePriceStr = [NSString stringWithFormat:@"原价￥%@", _model.salePrice];
    
    /*
    NSDictionary *attributes = @{
                                 NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#5bcec0"],
                                 
                                 NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
                                 
                                 NSStrikethroughColorAttributeName:[UIColor colorWithHexString:@"#5bcec0"]
                                 };
     */
    NSDictionary *attributes = @{
                                 NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle)
                                 };
    
    NSAttributedString *attrStr =
    [[NSAttributedString alloc] initWithString:salePriceStr
                                  attributes:attributes
     ];
    
    self.salePriceLabel.attributedText = attrStr;
    
    [self.singleBuyPriceLabel setText:[NSString stringWithFormat:@"%@元", self.model.salePrice]];
    [self.groupBuyPriceLabel setText:[NSString stringWithFormat:@"%@元", self.model.ActivityPrice]];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat width = self.view.width;
    CGFloat height = self.view.height;
    
    self.bgView.width = width;
    self.bgView.height = 400;
    self.bgView.x = 0;
    self.bgView.y = 64;
    
    self.imageView.width = width;
    self.imageView.height = width / 2;
    self.imageView.x = 0;
    self.imageView.y = 0;
    
    [self.titleLabel sizeToFit];
    self.titleLabel.centerX = width * 0.5;
    self.titleLabel.y = self.imageView.bottom + 10;
    
    [self.descLabel sizeToFit];
    self.descLabel.centerX = self.titleLabel.centerX;
    self.descLabel.y = self.titleLabel.bottom + 5;
    
    [self.groupPriceTitleLabel sizeToFit];
    self.groupPriceTitleLabel.right = self.titleLabel.centerX;
    self.groupPriceTitleLabel.y = self.descLabel.bottom + 15;
    
    [self.groupPriceLabel sizeToFit];
    self.groupPriceLabel.x = self.titleLabel.centerX;
//    self.groupPriceLabel.y = self.groupPriceTitleLabel.y;
    self.groupPriceLabel.bottom = self.groupPriceTitleLabel.bottom;
    
    [self.salePriceLabel sizeToFit];
    self.salePriceLabel.centerX = self.titleLabel.centerX;
    self.salePriceLabel.y = self.groupPriceLabel.bottom + 5;
    
    self.helpButton.width = width;
    self.helpButton.height = 44;
    self.helpButton.x = 0;
    self.helpButton.bottom = self.bgView.height - 10;
    
    self.singleBuyBGView.width = 131;
    self.singleBuyBGView.height = 63;
    self.singleBuyBGView.centerY = (height - 64 - self.bgView.height) * 0.5 + self.bgView.bottom;
    self.singleBuyBGView.right = width * 0.5 - 15;
    
    self.groupBuyBGView.width = self.singleBuyBGView.width;
    self.groupBuyBGView.height = self.singleBuyBGView.height;
    self.groupBuyBGView.centerY = self.singleBuyBGView.centerY;
    self.groupBuyBGView.x = width * 0.5 + 15;
    
    [self.singleBuyPriceLabel sizeToFit];
    self.singleBuyPriceLabel.y = 8;
    self.singleBuyPriceLabel.centerX = self.singleBuyBGView.width * 0.5;
    
    self.singleBuyButton.width = self.singleBuyBGView.width - 4;
    self.singleBuyButton.height = self.singleBuyBGView.height * 0.5 - 2;
    self.singleBuyButton.centerX = self.singleBuyBGView.width * 0.5;
    self.singleBuyButton.y = self.singleBuyBGView.height * 0.5;
    
    // 设置下面两个角圆角效果
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.singleBuyButton.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(9, 9)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.singleBuyButton.bounds;
    maskLayer.path = maskPath.CGPath;
    self.singleBuyButton.layer.mask = maskLayer;
    
    
    [self.groupBuyPriceLabel sizeToFit];
    self.groupBuyPriceLabel.y = 8;
    self.groupBuyPriceLabel.centerX = self.groupBuyBGView.width * 0.5;
    
    self.groupBuyButton.width = self.groupBuyBGView.width - 4;
    self.groupBuyButton.height = self.groupBuyBGView.height * 0.5 - 2;
    self.groupBuyButton.centerX = self.groupBuyBGView.width * 0.5;
    self.groupBuyButton.y = self.groupBuyBGView.height * 0.5;
    
    // 设置下面两个角圆角效果
    UIBezierPath *maskPath2 = [UIBezierPath bezierPathWithRoundedRect:self.groupBuyButton.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(9, 9)];
    CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc] init];
    maskLayer2.frame = self.groupBuyButton.bounds;
    maskLayer2.path = maskPath2.CGPath;
    self.groupBuyButton.layer.mask = maskLayer2;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)singleBuyButtonTouchUpInside:(UIButton *)sender {
    ShopCart *model = [ShopCart new];
    model.productNum = [NSNumber numberWithInt:1];
    model.productId = _model.ProductId;
    model.productName = _model.ProductName;
    model.ID = _model.ProductId;
    model.salePrice = _model.salePrice;
    
    SubmitOrderViewController *submitOrderVC = [SubmitOrderViewController new];
    submitOrderVC.buySoon = YES;
    submitOrderVC.goodsArray = @[model];
    [self.navigationController pushViewController:submitOrderVC animated:YES];
}

- (IBAction)groupBuyButtonTouchUpInside:(UIButton *)sender {
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"UID"];
    
    // 检查用户是否登录，如果未登录，跳转到登录页
    // 如果 uid 为空
    if ([Tools isBlankString:uid]) {
        
        FSLoginViewController *loginVC = [[FSLoginViewController alloc] init];
        FSNavigationController *navController = [[FSNavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:navController animated:YES completion:nil];
        return ;
    }
    
    SubmitGroupViewController *submitGroupVC = [SubmitGroupViewController new];
    submitGroupVC.groupModel = _model;
    [self.navigationController pushViewController:submitGroupVC animated:YES];
}

- (IBAction)helpButtonTouchUpInside:(UIButton *)sender {
    FSGroupBuyHelperViewController *helperVC = [FSGroupBuyHelperViewController new];
    [self.navigationController pushViewController:helperVC animated:YES];
}

@end
