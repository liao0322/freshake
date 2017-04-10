//
//  FSShowCouponView.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2017/4/5.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import "FSShowCouponView.h"
#import "FSShowCouponTVCell.h"
#import "FSHomeCouponModel.h"
#import "XFKVCPersistence.h"
#import "FSLoginViewController.h"
#import "FSNavigationController.h"
#import "FSAlertView.h"


@interface FSShowCouponView ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tbHeightConstraint;

@end

@implementation FSShowCouponView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = self.couponArray.count;
    
    if (rows == 1) {
        self.tbHeightConstraint.constant = 90;
    } else {
        self.tbHeightConstraint.constant = 150;
    }
    return self.couponArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FSHomeCouponModel *model = self.couponArray[indexPath.row];
    FSShowCouponTVCell *cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([FSShowCouponTVCell class]) owner:nil options:nil] lastObject];
    cell.model = model;
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.f;
}

- (IBAction)a:(id)sender {
    [self removeFromSuperview];
    
}

- (IBAction)getCouponButtonAction:(id)sender {
    NSString *uid = [XFKVCPersistence get:@"UID"];
    if (uid) {
        NSString *domainString = @"";
#if HTTP_TEST_TYPE == 0
        domainString = @"http://test.freshake.cn:9970";
#elif HTTP_TEST_TYPE == 1
        domainString = @"http://h5.freshake.cn";
#elif HTTP_TEST_TYPE == 2
        domainString = @"http://test.freshake.cn:9970";
#endif
        
        NSMutableString *idString = [NSMutableString string];
        
        [self.couponArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            FSHomeCouponModel *model = obj;
            
            if (idx == 0) {
                [idString appendString:model.TickId];
            } else {
                [idString appendString:[NSString stringWithFormat:@",%@", model.TickId]];
            }
            
        }];
        /*
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:idArray options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSUInteger length = jsonString.length;
        jsonString = [[[jsonString substringFromIndex:1] substringToIndex:length - 2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        */
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:@"BatchUseTick" forKey:@"page"];
        [parameters setObject:uid forKey:@"userid"];
        [parameters setObject:idString forKey:@"list"];
        
        [XFNetworking GET:[NSString stringWithFormat:@"%@/api/Phone/Fifth/index.aspx", domainString] parameters:parameters success:^(id responseObject, NSInteger statusCode) {
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            BOOL isSuccess = dict[@"issuccess"];
            [self removeFromSuperview];
            if (isSuccess) {
                [FSAlertView showSuccessWithString:dict[@"context"]];
            } else {
                [FSAlertView showErrorWithString:dict[@"context"]];
            }
            
        } failure:^(NSError *error, NSInteger statusCode) {
            [self removeFromSuperview];
            [FSAlertView showErrorWithString:@"领取失败!"];
        }];
        
    } else { // 未登录
        [self removeFromSuperview];
        FSLoginViewController *loginVC = [[FSLoginViewController alloc] init];
        
        FSNavigationController *navController = [[FSNavigationController alloc] initWithRootViewController:loginVC];
        
        UITabBarController *tabBar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        [[tabBar.viewControllers objectAtIndex:0] presentViewController:navController animated:YES completion:nil];
    }
}

@end
