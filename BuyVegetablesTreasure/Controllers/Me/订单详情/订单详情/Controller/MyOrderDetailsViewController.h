//
//  MyOrderDetailsViewController.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/9/5.
//
//

#import "ParentViewController.h"

@interface MyOrderDetailsViewController : ParentViewController

// 商品ID
@property (nonatomic, strong) NSString *idString;

#pragma mark - 拼团
// 是否拼团
@property (nonatomic, assign) BOOL isGroup;
// 订单号
@property (nonatomic, strong) NSString *orderString;
// 商家Id
@property (nonatomic, strong) NSString *midString;

@end
