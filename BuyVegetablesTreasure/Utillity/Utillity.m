//
//  Utillity.m
//  BuyVegetablesTreasure
//
//  Created by sc on 15/10/14.
//  Copyright (c) 2015年 c521xiong. All rights reserved.
//

#import "Utillity.h"

@implementation Utillity

// 显示警告框
+ (void)showAlertViewWithMessage:(NSString *)message viewController:(UIViewController *)viewController{
    
    if (SYSTEM_VERSION > 8.0) {
        
        // iOS8 提示框
        UIAlertController *alertController =
        [UIAlertController alertControllerWithTitle:@"温馨提示"
                                            message:NSLocalizedString(message, @"")
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        // 显示
        [viewController presentViewController:alertController animated:YES completion:nil];
        
        // 添加取消按钮
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        
        // 添加到alertController上
        [alertController addAction:cancelAction];
        
    }else{
        
        // iOS7 提示框
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:NSLocalizedString(message, @"")
                                                           delegate:nil
                                                  cancelButtonTitle:@"Yes"
                                                  otherButtonTitles:nil, nil];
        // 显示
        [alertView show];
        
    }
}

// 判断网络
+ (NSString *)getNetWorkStates{
    
    UIApplication *app = [UIApplication sharedApplication];
    
    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
    
    NSString *state = [[NSString alloc]init];
    
    int netType = 0;
    
    //获取到网络返回码
    for (id child in children) {
        
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            
            switch (netType) {
                case 1:
                    state = @"2G";
                    break;
                case 2:
                    state = @"3G";
                    break;
                case 3:
                    state = @"4G";
                    break;
                case 5:
                    state = @"WIFI";
                    break;
            }
        }
    }
    
    if ( [state isEqualToString:@""] ) {
        state = @"无网络";
    }
    
    return state;
}

// 自定义导航标题
+ (UILabel *)customNavToTitle:(NSString *)title{
    
    UILabel *navTitle  = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    navTitle.text = title;
    navTitle.font = [UIFont systemFontOfSize:17];
    navTitle.textColor = [UIColor colorWithHexString:@"0x606060"];
    navTitle.textAlignment = NSTextAlignmentCenter;
    
    return navTitle;
}

// 设置导航条左键返回按钮
+ (NSArray *)setNavleftBarButtonBackWithImage:(NSString *)imageString
                                       target:(id)tartget
                                       action:(SEL)selector
{
    UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    customButton.frame     = CGRectMake(0, 0, 44, 44);
    [customButton setImage:[UIImage imageNamed:imageString]
                  forState:UIControlStateNormal];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:tartget
                                          action:selector];
    [customButton addGestureRecognizer:tapGesture];
    
    UIBarButtonItem *backButton        = [[UIBarButtonItem alloc] initWithCustomView:customButton];
    UIBarButtonItem *negativeSpacer    = [[UIBarButtonItem alloc]
                                          initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                          target:nil action:nil];
    negativeSpacer.width = -16;
    
    return [NSArray arrayWithObjects:negativeSpacer, backButton, nil];
}

// 转换Json格式
+ (NSString *)DataTOjsonString:(id)object{
    
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    jsonString = [jsonString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return jsonString;
}

+ (float)fileSizeAtPath:(NSString *)path{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:path]){
        
        long long size= [fileManager attributesOfItemAtPath:path error:nil].fileSize;
        
        return size/1024.0/1024.0;
    }
    
    return 0;
}

+ (float)folderSizeAtPath:(NSString *)path{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    float folderSize;
    
    if ([fileManager fileExistsAtPath:path]) {
        
        NSArray *childerFiles = [fileManager subpathsAtPath:path];
        
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            folderSize += [Utillity fileSizeAtPath:absolutePath];
        }
        
        //SDWebImage框架自身计算缓存的实现
        folderSize += [[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
        return folderSize;
    }
    return 0;
}

+ (void)clearCache:(NSString *)path{
    
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:path]) {
        
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    [[SDImageCache sharedImageCache] cleanDisk];
}

+ (CGFloat)getTextHeightWithText:(NSString *)text
                           width:(CGFloat)width
                            font:(UIFont *)font
{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, 10000)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:font}
                                     context:nil];
    return rect.size.height;
}

+ (CGFloat)getTextWidthWithText:(NSString *)text
                         height:(CGFloat)height
                           font:(UIFont *)font
{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(10000, height)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:font}
                                     context:nil];
    return rect.size.width;
}

+ (void)deleteCache {
    
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}

// 判断是否中文
+ (BOOL)IsChinese:(NSString *)str {
    
    for(int i=0; i< [str length];i++){
        
        int a = [str characterAtIndex:i];
        
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
        
    }
    return NO;
}

+ (NSString *)string:(NSString *)str {
    
    if ([Tools isBlankString:str]) {
        str = @"";
    }
    return [NSString stringWithFormat:@"%@",str];
}

+ (UIImage *) imageCompressForWidth:(UIImage *)sourceImage
                        targetWidth:(CGFloat)defineWidth {
    
    UIImage *newImage      = nil;
    CGSize imageSize       = sourceImage.size;
    CGFloat width          = imageSize.width;
    CGFloat height         = imageSize.height;
    CGFloat targetWidth    = defineWidth;
    CGFloat targetHeight   = height / (width / targetWidth);
    CGSize size            = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor    = 0.0;
    CGFloat scaledWidth    = targetWidth;
    CGFloat scaledHeight   = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}

+ (void)back:(UIViewController *)viewController selectedIndex:(NSInteger)index {

    viewController.tabBarController.selectedIndex = index;
    [viewController.navigationController popToRootViewControllerAnimated:YES];
}

@end
