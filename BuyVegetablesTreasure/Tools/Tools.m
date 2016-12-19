//
//  Tools.m
//  youmai
//
//  Created by bu88 on 14-10-27.
//  Copyright (c) 2014年 lindu. All rights reserved.
//

#import "Tools.h"
#import "RechargeViewController.h"

#import "NSString+MD5.h"

// 支付宝导入文件
#import "AliOrder.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "APAuthV2Info.h"

//微信
#import "WXApi.h"
#import "WXApiManager.h"

@implementation Tools

+ (BOOL) isIphone4s {
    CGSize size = [UIScreen mainScreen].bounds.size;
    if (size.width == 320.0f && size.height == 480.0f) {
        return YES;
    }
    return NO;
}

+ (void) myHud:(NSString *)str inView:(UIView *)view
{
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.color = [UIColor grayColor];
    hud.margin=13.0;
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    [[[UIApplication sharedApplication].delegate window] addSubview:hud];
    
    hud.labelFont = [UIFont systemFontOfSize:20];
    
    [hud show:YES];
    if (size.width == 320.0f)
    {
        hud.yOffset = 130.f;
        hud.detailsLabelText = str;
    }else if(size.width > 414.f)
    {
        hud.yOffset = 350.f;
        hud.labelText = str;
    }
    else
    {
        hud.yOffset = 200.f;
        hud.detailsLabelText = str;
    }
    [hud hide:YES afterDelay:2];
}

+ (void) myHud:(NSString *)str
{
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.color = [UIColor grayColor];
    hud.margin=13.0;
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    [[[UIApplication sharedApplication].delegate window] addSubview:hud];
    
    hud.labelFont = [UIFont systemFontOfSize:20];
    
    [hud show:YES];
    if (size.width == 320.0f)
    {
        hud.yOffset = 130.f;
        hud.detailsLabelText = str;
    }else if(size.width > 414.f)
    {
        hud.yOffset = 350.f;
        hud.labelText = str;
    }
    else
    {
        hud.yOffset = 200.f;
        hud.detailsLabelText = str;
    }
    [hud hide:YES afterDelay:2];
}

+ (void) myAlert:(NSString *)str {
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"注意" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

+ (void)myAlert:(NSString *)str target:(id)target 
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:str delegate:target cancelButtonTitle:nil otherButtonTitles:@"取消",@"确定", nil];
    [alert show];
}

+ (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([string isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

+ (ZYWeekDayEnum) todayIs {
    NSDateFormatter *fmtter =[[NSDateFormatter alloc] init];
    [fmtter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [fmtter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [fmtter setDateFormat:@"EEE"];
    NSString* dayString = [fmtter stringFromDate:[NSDate date]];
    if (nil == dayString) {
        return UnKnow;
    }
    
    if ([dayString hasPrefix:@"Mon"]) {
        return Monday;
    }
    if ([dayString hasPrefix:@"Tue"]) {
        return Tuesday;
    }
    if ([dayString hasPrefix:@"Wed"]) {
        return Wednesday;
    }
    if ([dayString hasPrefix:@"Thu"]) {
        return Thursday;
    }
    if ([dayString hasPrefix:@"Fri"]) {
        return Friday;
    }
    if ([dayString hasPrefix:@"Sat"]) {
        return Saturday;
    }
    if ([dayString hasPrefix:@"Sun"]) {
        return Sunday;
    }
    return UnKnow;
}

+ (BOOL) isMobileNum:(NSString*)mobileNum {
    if([self isBlankString: mobileNum]){
        return NO;
    }
    if(mobileNum.length > 11){
        return NO;
    }

    NSString *telRegex = @"^[1][34578]\\d{9}";
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", telRegex];
    if ([regextestcm evaluateWithObject:mobileNum] == YES)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL)isValidateEmail:(NSString *)email {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (void)searchBarToClearWithSearchBar:(UISearchBar *)searchBar {
    for (UIView *view in searchBar.subviews) {
        if([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending){
            if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
                [[view.subviews objectAtIndex:0] removeFromSuperview];
                break;
            }
        }else{
            if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                [view removeFromSuperview];
                break;
            }
        }
    }
}

+ (BOOL) isPureInt:(NSString*)string {
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return ([scan scanInt:&val] && [scan isAtEnd]);
}

+ (NSMutableAttributedString *) getAttributedStringWithString:(NSString *)string {
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:string];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, string.length)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, string.length)];
    return attri;
}

+ (UITableView *)tableViewWithFrame:(CGRect)frame style:(UITableViewStyle)style delegate:(id)delegete dataSource:(id)dataSource
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:style];
   // tableView.backgroundColor = [UIColor clearColor];
    tableView.scrollEnabled = YES;
   // tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.delegate = delegete;
    tableView.dataSource = dataSource;
    return tableView;
}

+ (CGSize)stringSizeWithString:(NSString *)str attributes:(NSDictionary *)attributes {
    return [str sizeWithAttributes:attributes];
}

+ (CGSize)stringSizeWithSting:(NSString *)str Font:(UIFont *)stringFont boundRect:(CGSize)size
{
    NSDictionary *attribute = @{NSFontAttributeName: stringFont};
    CGSize strSize = [str boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    return strSize;
}



#pragma mark - 友盟分享,target不能为nil

//+ (void)umShareWithTarget:(id)target shareText:(NSString *)text shareImage:(UIImage *)image 
//{
//    UIImage *tempImage=image;
//    if(tempImage==nil)
//        tempImage=IMAGE(@"person_icon");
//    if(text==nil)
//        text=@"P2N信息发布系统";
//    [UMSocialSnsService presentSnsIconSheetView:target appKey:UMAppkey shareText:text shareImage:tempImage shareToSnsNames:@[UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone,UMShareToQQ,UMShareToSms] delegate:target];
//}
#if 1
+ (void)alipayPayRequestWithTradeNO:(NSString *)tradeNO ProductName:(NSString *)productName ProductDescription:(NSString *)productDescription Amount:(NSString *)amount notify_url:(NSString *)notify_url
{
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    AliOrder *order = [[AliOrder alloc] init];
    order.partner = KAlipayPartnerID;    // 商户后台生成
    order.seller = KAlipaySellerAccount; // 支付宝账号
    
    // ----------- 找服务器要数据 --------------
    order.tradeNO = tradeNO; //订单号（由商家自行制定）
    order.productName = productName; //商品标题
    order.productDescription = productDescription; //商品描述
    
    order.amount = [NSString stringWithFormat:@"%.2f",[amount floatValue]]; //商品价格
//    order.amount = [NSString stringWithFormat:@"%.2f",0.01];
    // 通知我们自己的服务器订单已经完成
    order.notifyURL = notify_url;
    // ----------- 找服务器要数据 --------------
    
    
    // ----------- 参数不变 --------------
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";         // 商品购物 “1”
    order.inputCharset = @"utf-8";    // 编码格式 utf-8
    order.itBPay = @"30m";            // 支付超时时间 30分钟
    order.showUrl = @"m.alipay.com";  // 支付网页网址
    // ----------- 参数不变 --------------
    
    // 应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    // 应用跳转scheme
    NSString *appScheme = @"XianYaoPai";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
//    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(KAlipayPrivateKey);
//    id<DataSigner> signer = CreateRSADataSigner([[NSBundle mainBundle] objectForInfoDictionaryKey:KAlipayPrivateKey]);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil)
    {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        //        9000 订单支付成功
        //        8000 正在处理中
        //        4000 订单支付失败
        //        6001 用户中途取消
        //        6002 网络连接出错
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            
            [Single sharedInstance].paytype = resultDic[@"resultStatus"];
            
             NSLog(@"---------%@----------",[Single sharedInstance].paytype);
            if ([resultDic[@"resultStatus"] isEqualToString:@"9000"])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"zhifubao" object:nil];
                
            }
            if ([resultDic[@"resultStatus"] isEqualToString:@"6001"])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"zhifubaoCancel" object:nil];
                [Tools myHud:@"支付取消" inView:[[UIApplication sharedApplication].delegate window]];
                
            }
            
        }];
    }
}
#endif

#if 0
+ (void)WeCartPayWithNoncestr:(NSString *)noncestr package:(NSString *)package partnerid:(NSString *)partnerid prepayid:(NSString *)prepayid timestamp:(NSString *)timestamp
{
    //第二次签名参数列表
    NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
    [signParams setObject: WECARTAPPID      forKey:@"appid"];
    [signParams setObject: noncestr         forKey:@"noncestr"];
    [signParams setObject: @"Sign=WXPay"    forKey:@"package"];
    [signParams setObject: partnerid        forKey:@"partnerid"];
    [signParams setObject: timestamp        forKey:@"timestamp"];
    [signParams setObject: prepayid         forKey:@"prepayid"];
    
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [signParams allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (   ![[signParams objectForKey:categoryId] isEqualToString:@""]
            && ![categoryId isEqualToString:@"sign"]
            && ![categoryId isEqualToString:@"key"]
            )
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [signParams objectForKey:categoryId]];
        }
        
    }
    //添加key字段
    [contentString appendFormat:@"key=%@",WECARTAPPKEY];
    
    //得到MD5 sign签名
    NSString *md5Sign =[contentString md5String];
    
    //添加签名
    [signParams setObject: md5Sign  forKey:@"sign"];

    //调起微信支付
    PayReq* req    = [[PayReq alloc] init];
    req.partnerId           = partnerid;
    req.prepayId            = prepayid;
    req.nonceStr            = noncestr;
    req.timeStamp           = timestamp.intValue;
    req.package             = package;
    req.sign                = md5Sign;
    [WXApi sendReq:req];
    //日志输出
    NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",WECARTAPPID,partnerid,prepayid,noncestr,(long)timestamp,package,md5Sign);
    
}
#else 

+ (void)WeCartPayWithNoncestr:(NSString *)noncestr package:(NSString *)package partnerid:(NSString *)partnerid prepayid:(NSString *)prepayid timestamp:(NSString *)timestamp
{
    NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
    [signParams setObject: WECARTAPPID      forKey:@"appid"];
    [signParams setObject: noncestr         forKey:@"noncestr"];
    [signParams setObject: @"Sign=WXPay"    forKey:@"package"];
    [signParams setObject: partnerid        forKey:@"partnerid"];
    [signParams setObject: timestamp        forKey:@"timestamp"];
    [signParams setObject: prepayid         forKey:@"prepayid"];
    
    NSMutableString *contentString = [NSMutableString string];
    NSArray *sortedArray = [[signParams allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    for (NSString *categoryId in sortedArray) {
        
        if (![[signParams objectForKey:categoryId] isEqualToString:@""] &&
            ![categoryId isEqualToString:@"sign"] &&
            ![categoryId isEqualToString:@"key"])
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [signParams objectForKey:categoryId]];
        }
        
    }
    
    [contentString appendFormat:@"key=%@",WECARTAPPKEY];
    NSLog(@"%@",contentString);
    
    NSString *md5SignString = [contentString md5String];
    [signParams setObject:md5SignString forKey:@"sign"];
    
    //调起微信支付
    PayReq *req   = [[PayReq alloc] init];
    req.partnerId = partnerid;
    req.package   = @"Sign=WXPay";
    req.prepayId  = prepayid;
    req.nonceStr  = noncestr;
    req.timeStamp = timestamp.intValue;
    req.sign      = md5SignString;
    [WXApi sendReq:req];
}

#endif

@end
