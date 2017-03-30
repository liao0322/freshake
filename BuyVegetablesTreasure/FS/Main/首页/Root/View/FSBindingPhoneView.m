//
//  FSBindingPhoneView.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2017/3/29.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import "FSBindingPhoneView.h"
#import "XFLimitedTextField.h"
#import "XFKVCPersistence.h"

#define CAPTCHA_INTERVAL_TIME 59

@interface FSBindingPhoneView ()

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet XFLimitedTextField *phoneNumberTextField;

@property (weak, nonatomic) IBOutlet XFLimitedTextField *captchaTextField;

@property (weak, nonatomic) IBOutlet UIButton *bindingButton;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *requestCaptchaButton;

@end

@implementation FSBindingPhoneView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.phoneNumberTextField.borderStyle = UITextBorderStyleNone;
    self.phoneNumberTextField.maxCount = 11;
    
    self.captchaTextField.borderStyle = UITextBorderStyleNone;
    self.captchaTextField.maxCount = 4;
    
    self.bindingButton.layer.cornerRadius = 3.0f;
    self.bindingButton.layer.masksToBounds = YES;
    
    self.cancelButton.layer.cornerRadius = 3.0f;
    self.cancelButton.layer.masksToBounds = YES;
    
    self.bindingButton.enabled = NO;
    
    [self.bindingButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorDomina]] forState:UIControlStateNormal];
    
    self.requestCaptchaButton.layer.borderWidth = 0.5f;
    self.requestCaptchaButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.requestCaptchaButton.layer.cornerRadius = 3.0f;
    self.requestCaptchaButton.layer.masksToBounds = YES;

    
    /*
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
     */
    
}

/*
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
*/

+ (instancetype)bindingPhoneView {
    FSBindingPhoneView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    return view;
}

+ (void)show {
    FSBindingPhoneView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([FSBindingPhoneView class]) owner:self options:nil] lastObject];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    
}
- (IBAction)bindingButtonDidClicked:(UIButton *)sender {
    NSString *unionID = [XFKVCPersistence get:@"unionId"];
    
    // 获取用户输入的手机号
    NSString *accountStr = self.phoneNumberTextField.text;
    
    // 获取用户输入的验证码
    NSString *captcha = self.captchaTextField.text;
    
    if ([Tools isBlankString:accountStr]) {
        return [SVProgressHUD showInfoWithStatus:@"请输入您的手机号"];
    }
    else if (![Tools isMobileNum:accountStr]) {
        return [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号!"];
    }
    else if ([Tools isBlankString:captcha]) {
        return [SVProgressHUD showInfoWithStatus:@"请输入验证码"];
        
    }
    

    NSString *domainString = @"";
#if HTTP_TEST_TYPE == 0
    domainString = @"http://test.freshake.cn:9970";
#elif HTTP_TEST_TYPE == 1
    domainString = @"http://h5.freshake.cn";
#elif HTTP_TEST_TYPE == 2
    domainString = @"http://test.freshake.cn:9970";
#endif
    NSDictionary *parameters = @{
                                 @"page": @"BoundPhone",
                                 @"unionid": unionID,
                                 @"code": captcha,
                                 @"phone": accountStr
                                 };
    NSString *URLString = [NSString stringWithFormat:@"%@/%@", domainString, @"api/Phone/Fifth/index.aspx"];
    
    [XFNetworking GET:URLString parameters:parameters success:^(id responseObject, NSInteger statusCode) {
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        
        // 绑定失败
        if (![dataDict[@"issuccess"] boolValue]) {
            [SVProgressHUD showInfoWithStatus:dataDict[@"context"]];
            return;
        }
        [SVProgressHUD showSuccessWithStatus:@"绑定成功"];
        [self cancelButtonDidClicked:nil];
        [self bindingSuccessWithDict:dataDict];
    } failure:^(NSError *error, NSInteger statusCode) {
    }];
    
}

- (void)bindingSuccessWithDict:(NSDictionary *)dataDict {
    
    // 登录成功
    // 持久化相关信息
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *userDefaultsNumbers = @[@"amount",
                                     @"exp",
                                     @"point",
                                     @"group_id"];
    NSArray *userDefaultsStrings = @[@"telphone",
                                     @"mobile",
                                     @"CouponNum",
                                     @"FolderNum",
                                     @"address",
                                     @"avatar",
                                     @"nick_name",
                                     @"user_name",
                                     @"sex"];
    
    for (int i = 0; i < userDefaultsStrings.count; i++) {
        [userDefaults setObject:dataDict[userDefaultsStrings[i]] forKey:userDefaultsStrings[i]];
        if (userDefaultsNumbers.count > i) {
            [userDefaults setObject:[dataDict[userDefaultsNumbers[i]] stringValue] forKey:userDefaultsNumbers[i]];
        }
    }
    if (dataDict[@"birthday"]) {
        [userDefaults setObject:dataDict[@"birthday"] forKey:@"birthday"];
    }
    [userDefaults setBool:NO forKey:@"isMobLogin"];
    [userDefaults setObject:[NSString stringWithFormat:@"%@",dataDict[@"id"]] forKey:@"UID"];
    [userDefaults setObject:[NSString stringWithFormat:@"%@",dataDict[@"agentId"]] forKey:@"ZID"];
    
    [userDefaults setObject:dataDict[@"ISshare"] forKey:@"isShare"];
    [userDefaults setObject:dataDict[@"shareUrl"] forKey:@"shareUrl"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UserChange" object:nil];
    // 发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UserIsLogined" object:nil];
    
    // 删除购物车商品
    [self delStoreGoods];
    
}

#pragma 删除购物车商品
- (void)delStoreGoods {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *mid = [userDefaults objectForKey:@"MID"];
    NSString *uid = [userDefaults objectForKey:@"UID"];
    
    NSString *urlString = [NSString stringWithFormat:DelStoreCartUrl,UUID,mid,uid];
    NSLog(@"%@",urlString);
    [HttpRequest sendRequest:urlString param:nil requestStyle:Get setSerializer:Json success:^(id data)
     {
         NSLog(@"%@",data[@"context"]);
         
     } failure:nil];
}

- (IBAction)cancelButtonDidClicked:(UIButton *)sender {
    [self removeFromSuperview];
}

- (IBAction)textFieldChanged:(XFLimitedTextField *)sender {
    self.bindingButton.enabled = self.phoneNumberTextField.text.length >= 11 && self.captchaTextField.text.length;
}

- (IBAction)requestCaptcha:(UIButton *)sender {
    // 获取用户输入的手机号
    NSString *accountStr = self.phoneNumberTextField.text;
    
    // 检查是否合格
    if ([Tools isBlankString:accountStr]) {
        return [SVProgressHUD showInfoWithStatus:@"请输入手机号"];
    }
    if (![Tools isMobileNum:accountStr]) {
        return [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号!"];
    }
    [self startCountDown];
    [self sendVerificationWithMoblie:accountStr];
}

- (void)startCountDown {
    __block int timeout = CAPTCHA_INTERVAL_TIME; // 倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if (timeout <= 0) { // 倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                // 设置界面的按钮显示 根据自己需求设置
                [self.requestCaptchaButton setTitle:@"点击获取" forState:UIControlStateNormal];
                self.requestCaptchaButton.enabled = YES;
            });
        } else {
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                // 设置界面的按钮显示 根据自己需求设置
                [UIView animateWithDuration:1 animations:^{
                    [self.requestCaptchaButton setTitle:[NSString stringWithFormat:@"%@ s", strTime] forState:UIControlStateNormal];
                }];
                self.requestCaptchaButton.enabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (void)sendVerificationWithMoblie:(NSString *)moblie {
    
    NSString *urlString = [NSString stringWithFormat:GETCODE, moblie, @"0"];
    
    [XFNetworking GET:urlString parameters:nil success:^(id responseObject, NSInteger statusCode) {
        /*
        NSDictionary *data = [self dictWithData:responseObject];
        
        if ([data[@"issuccess"] boolValue]) {
            
        }
        [SVProgressHUD showInfoWithStatus:data[@"context"]];
         */
    } failure:^(NSError *error, NSInteger statusCode) {
        //[self showInfoWidthError:error];
    }];
}

#pragma mark - keyboard events -

///键盘显示事件
/*
- (void) keyboardWillShow:(NSNotification *)notification {
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
    CGFloat offset = (panelInputTextView.frame.origin.y+panelInputTextView.frame.size.height+INTERVAL_KEYBOARD) - (self.view.frame.size.height - kbHeight);
    
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //将视图上移计算好的偏移
    if(offset > 0) {
        [UIView animateWithDuration:duration animations:^{
            self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
}

///键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {
    // 键盘动画时间
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
}
*/
@end
