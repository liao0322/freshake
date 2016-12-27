//
//  AmountViewController.m
//  BuyVegetablesTreasure
//
//  Created by Song on 16/3/11.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "AmountViewController.h"
#import "RechargeViewController.h"
#import "AmountTableView.h"
#import "AmountTextField.h"
#import "AmountModel.h"

@interface AmountViewController ()

@property (nonatomic, strong) AmountTableView *amountTableView;
@property (nonatomic, strong) AmountTextField *amountTextField;

@end

@implementation AmountViewController

- (void)viewDidLoad {
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xf8f8f8"];
    
    [self setNav];
//    [self initAmountView];
    [self initAmountTextField];
    [self initAmountTableView];
    [self getRechargeImage];
}

- (void)setNav {
    self.navigationItem.title = @"余额充值";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"充值记录" style:UIBarButtonItemStylePlain target:self action:@selector(goRecord)];
}

- (void)goRecord {
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:[NSClassFromString(@"RechargeRecordViewController") new] animated:YES];
}

- (void)initAmountTextField {

    self.amountTextField = [AmountTextField new];
    [self.view addSubview:self.amountTextField];
    
    WS(weakSelf);
    [self.amountTextField setAmountBlock:^(NSString *priceString, NSString *idString) {
        [weakSelf goPaymentMentod:priceString idString:idString];
    }];
    
    self.amountTextField.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view)
    .heightIs(50);
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    
}

- (void)initAmountTableView {
    
    self.amountTableView = [AmountTableView new];
    [self.view addSubview:self.amountTableView];
    
    WS(weakSelf);
    [self.amountTableView setAmountBlock:^(NSString *priceString, NSString *idString) {
        [weakSelf goPaymentMentod:priceString idString:idString];
    }];
    
    self.amountTableView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topEqualToView(self.view)
    .bottomSpaceToView(self.amountTextField, 0);
    
    self.amountTableView.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    
    

}

- (void)getRechargeImage {
        
    [HttpRequest sendRequest:LMMC(Path(@"GetRecharge")) param:nil requestStyle:Get setSerializer:Json success:^(id data) {
        
        if ([data[@"issuccess"] boolValue]) {
            
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dic in data[@"List"]) {
                
                AmountModel *model = [AmountModel new];
                [model setValuesForKeysWithDictionary:dic];
                [arr addObject:model];
            }
            
            self.amountTableView.dataSource = arr;
        }

    } failure:nil];
}

- (void)goPaymentMentod:(NSString *)priceString idString:(NSString *)idString {
    
    [self.view endEditing:YES];
    
    if ([Tools isBlankString:priceString]) {
        return [Tools myHud:@"请输入充值金额" inView:self.view];
    }
    else if ([priceString floatValue] <= 0) {
        return [Tools myHud:@"充值金额不得小于0" inView:self.view];
    }
    
    RechargeViewController *rechargeVC = [[RechargeViewController alloc] init];
    rechargeVC.Money = priceString;
    rechargeVC.rechargeId = idString;

    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:rechargeVC animated:YES];
}

@end
