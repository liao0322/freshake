//
//  ExpressageCell.h
//  BuyVegetablesTreasure
//
//  Created by sc on 15/10/15.
//  Copyright (c) 2015年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface ExpressageCell : UITableViewCell<UITextFieldDelegate>

// 商品数量
@property (nonatomic, assign) NSInteger goodsCount;

// 商品名称
@property (nonatomic, copy) NSString *goodsName;

@property (nonatomic, copy) void(^goPayment)(NSArray *arr);
@property (nonatomic, copy) void(^editTextField)();

@property (weak, nonatomic) IBOutlet UITextField *remarkText;
@property (weak, nonatomic) IBOutlet UITextField *mobile;
@property (weak, nonatomic) IBOutlet UITextField *nameText;


// 付款
- (IBAction)goPayment:(id)sender;

- (void)setData:(UserModel *)model;


@end
