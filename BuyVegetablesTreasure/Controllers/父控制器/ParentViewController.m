//
//  ParentViewController.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/8/16.
//
//

#import "ParentViewController.h"

@implementation ParentViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    // 背景色
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xf8f8f8"];
}

/**
 *  跳转到其他控制器
 *
 *  @param viewController 控制器
 *  @param isHidden       返回是否隐藏Tabbar
 */
- (void)pushViewControlle:(UIViewController *)viewController
       backIsHiddenTabbar:(BOOL)isHidden
{
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed = isHidden;
}

/**
 *  Json请求网络
 *
 *  @param urlString 链接
 *  @param isLoading 是否加载
 *  @param success   请求成功
 *  @param failure   请求失败
 */
- (void)requestJsonWithUrlString:(NSString *)urlString
                       isLoading:(BOOL)isLoading
                         success:(void (^)(id data))success
                         failure:(void (^)(NSError *error))failure
{
    NSMutableString *string = [[NSMutableString alloc] initWithString:urlString] ;
    NSRange range = NSMakeRange(0, [string length]);
    [string replaceOccurrencesOfString:@"(null)" withString:@"0" options:NSCaseInsensitiveSearch range:range];
    IFPLog(@"%@",string);
    
    [HttpRequest sendGetOrPostRequest:string param:nil requestStyle:Get setSerializer:Json isShowLoading:isLoading success:^(id data)
     {
         if (success != nil) {
             success(data);
         }
         
     } failure:^(NSError *error)
     {
         if (failure != nil) {
             failure(error);
         }
         
         IFPLog(@"%@",error);
     }];
}

/**
 *  Date请求网络
 *
 *  @param urlString 链接
 *  @param isLoading 是否加载
 *  @param success   请求成功
 *  @param failure   请求失败
 */
- (void)requestDateWithUrlString:(NSString *)urlString
                       isLoading:(BOOL)isLoading
                         success:(void (^)(id data))success
                         failure:(void (^)(NSError *error))failure
{
    NSMutableString *string = [[NSMutableString alloc] initWithString:urlString] ;
    NSRange range = NSMakeRange(0, [string length]);
    [string replaceOccurrencesOfString:@"(null)" withString:@"0" options:NSCaseInsensitiveSearch range:range];
    IFPLog(@"%@",string);
    
    [HttpRequest sendGetOrPostRequest:string param:nil requestStyle:Get setSerializer:Date isShowLoading:isLoading success:^(id data)
     {
         if (success != nil) {
             success(data);
         }
         
     } failure:^(NSError *error)
     {
         if (failure != nil) {
             failure(error);
         }
         
         IFPLog(@"%@",error);
     }];
}

#pragma mark - 余额支付
/**
 *  设置或输入支付密码
 */
- (void)setPayWithIsExist:(BOOL)isExist {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:isExist ? @"余额支付" : @"设置支付密码" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    NSArray *arr = isExist ? @[@"请输入支付密码"] : @[@"请输入登录密码",@"请输入支付密码",@"请再次输入支付密码"];
    for (int i = 0; i < arr.count; i++) {
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = arr[i];
            textField.secureTextEntry = YES;
        }];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PayState" object:@"0"];
    }];
    
    UIAlertAction *okAction =
    [UIAlertAction actionWithTitle:@"确定"
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction *action)
     {
         NSMutableArray *passwordArary = [NSMutableArray array];
         for (UITextField *textField in alertController.textFields) {
             [passwordArary addObject:textField.text];
         }
         
         if (isExist) {
             // 支付
             [self amountPayWithPassword:[passwordArary[0] md5String]];
         }
         else {
             
             if ([passwordArary[1] length] < 6) {
                 return [Tools myAlert:@"密码不得小于6位"];
             }
             else if ([passwordArary[1] isEqualToString:passwordArary[2]]) {
                 [self setPayPassword:[passwordArary[1] md5String] loginPassword:[passwordArary[0] md5String]];
             }
             else {
                 return [Tools myAlert:@"两次密码不一致，请重新操作"];
             }
         }
     }];
    
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
}

/**
 *  是否有密码
 */
- (void)isPayPwd {
    
    NSString *urlString = [NSString stringWithFormat:IsPayPwd,GetUserId];
    [self requestJsonWithUrlString:urlString isLoading:YES success:^(id data) {
        
        [self setPayWithIsExist:[data[@"issuccess"] boolValue]];
        
    } failure:nil];
}

/**
 *  使用余额支付
 */
- (void)amountPayWithPassword:(NSString *)password {
    
    NSString *urlString = [NSString stringWithFormat:AmountPay,_orderNoString,password];
    [self requestJsonWithUrlString:urlString isLoading:YES success:^(id data) {
        
        if ([data[@"issuccess"] boolValue]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PayState" object:@"1"];
        }
        else [[NSNotificationCenter defaultCenter] postNotificationName:@"PayState" object:@"0"];
        
        [Tools myHud:data[@"context"] inView:self.view];
        
    } failure:nil];
}

/**
 *  设置支付密码
 */
- (void)setPayPassword:(NSString *)password
         loginPassword:(NSString *)loginPassword
{
    NSString *phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"];
    NSString *isDirectLogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"isMobLogin"];
    NSString *urlString = [NSString stringWithFormat:SetPayPwd,phone,loginPassword,isDirectLogin,password];
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:YES success:^(id data)
     {
         if ([data[@"issuccess"] boolValue]) {
             [Tools myAlert:@"设置支付密码成功，请重新输入支付密码完成购物" target:self];
         }
         else [Tools myAlert:data[@"context"]];
         
     } failure:nil];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        [self setPayWithIsExist:YES];
    }
}

@end
