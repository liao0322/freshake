//
//  AppDelegate.h
//  BuyVegetablesTreasure
//
//  Created by sc on 15/10/14.
//  Copyright (c) 2015年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol WXDelegate <NSObject>
//
//- (void)loginSuccessByCode:(NSString *)code;
//
//@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (assign, nonatomic) NSInteger allowRotation;
@property (strong, nonatomic) CLLocationManager * locationManager;
@property (strong, nonatomic) NSTimer *timer;
//@property (weak,   nonatomic) id<WXDelegate> wxDelegate;
/// 获取App的代理
+ (AppDelegate *)appDelegate;

- (void)toMain;
@end

