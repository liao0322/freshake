//
//  FSOpenPushViewController.m
//  BuyVegetablesTreasure
//
//  Created by 江玉元 on 2016/12/20.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSOpenPushViewController.h"

@interface FSOpenPushViewController (){
    NSString *_isOpenPush;
}

@end

@implementation FSOpenPushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isOpenPush = @"0";
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xF6F6F6"];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"0xf2f2f2"];
    self.navigationItem.titleView = [Utillity customNavToTitle:@"消息设置"];
    self.navigationItem.leftBarButtonItem = [UIFactory createBackBBIWithTarget:self action:@selector(back)];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0f) {
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone != setting.types) {
            _isOpenPush = @"1";
        } else {
            _isOpenPush = @"0";
        }
    } else {
        //iOS7
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if(UIRemoteNotificationTypeNone != type){
            _isOpenPush=@"1";
        }else{
            _isOpenPush=@"0";
        }

    }
    
    [self initView];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initView {
    UIImageView *_tImageView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-90, 114, 20, 20)];
    [self.view addSubview:_tImageView];
    
    UILabel *_titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-60, 104, 160,40)];
    _titleLabel.textAlignment=NSTextAlignmentCenter;
    _titleLabel.font=[UIFont boldSystemFontOfSize:20];
    _titleLabel.textColor=[UIColor colorWithHexString:@"0x606060"];
    [self.view addSubview:_titleLabel];
    
    if ([_isOpenPush isEqualToString:@"1"]) {
        _tImageView.image=IMAGE(@"选中背景");
        _titleLabel.text=@"消息提醒已开启";
    }else{
        _tImageView.image=IMAGE(@"set_关闭图标");
        _titleLabel.text=@"消息提醒已关闭";
    }
    
    UILabel *_tLabel=[[UILabel alloc]initWithFrame:CGRectMake(20,164, SCREEN_WIDTH-40,80)];
    _tLabel.font=[UIFont systemFontOfSize:16];
    _tLabel.textColor=[UIColor colorWithHexString:@"0x616161"];
    NSString *_tStr=@"要开启或停用鲜摇派客户端的消息提醒服务，您可以在设置>通知>鲜摇派中手动设置。";
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:_tStr];
    [attributeString setAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"0xff6600"],   NSFontAttributeName : [UIFont systemFontOfSize:16]} range:NSMakeRange(24, 10)];
    _tLabel.numberOfLines=3;
    _tLabel.attributedText=attributeString;
    [self.view addSubview:_tLabel];
    
    for (int i = 0; i<3; i++) {
        UIImageView *_lImageView=[[UIImageView alloc]initWithFrame:CGRectMake(20, 259+40*i, 20, 20)];
        [self.view addSubview:_lImageView];
        
        UILabel *_litleLabel=[[UILabel alloc]initWithFrame:CGRectMake(50, 254+40*i, SCREEN_WIDTH-80,30)];
        _litleLabel.font=[UIFont systemFontOfSize:16];
        _litleLabel.textColor=[UIColor colorWithHexString:@"0x606060"];
        [self.view addSubview:_litleLabel];
        
        switch (i) {
            case 0:
                _lImageView.image=IMAGE(@"set_图层-8");
                _litleLabel.text=@"打开“设置”";
                break;
            case 1:
                _lImageView.image=IMAGE(@"set_椭圆-1");
                _litleLabel.text=@"打开“通知中心”";
                break;
            default:
                _lImageView.image=IMAGE(@"logo.jpg");
                _litleLabel.text=@"选择“鲜摇派”开启提醒";
                break;
        }
    }
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
