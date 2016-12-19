//
//  RockViewController.m
//  BuyVegetablesTreasure
//
//  Created by ky on 15/10/22.
//  Copyright (c) 2015年 c521xiong. All rights reserved.
//

#import "RockViewController.h"
#import "ShowGifView.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "AdWebViewController.h"

@interface RockViewController ()<CLLocationManagerDelegate,CBCentralManagerDelegate>
{
    ShowGifView *_showGifView;
    
    CLLocationManager * _locationManager;
    CLBeaconRegion * _region;
    //
    //    UIImageView *_bottomImageView;
    //    记录需要跳转的URL
    // NSString *_pushURL;
    
    //摇到的ibeacon设备信息
    NSString *_UUIDStr;
    NSString *_MajorStr;
    NSString *_MinorStr;
    CBCentralManager *_manager;
    
    NSMutableArray *_beaconListArray;
}

@end

@implementation RockViewController
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}
- (void) viewWillAppear:(BOOL)animated
{
    [self resignFirstResponder];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"0xf5f6f8"];
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xF6F6F6"];
    self.navigationItem.titleView = [Utillity customNavToTitle:@"摇一摇"];
    self.navigationItem.leftBarButtonItem = [UIFactory createBackBBIWithTarget:self action:@selector(back)];
    
    _beaconListArray = [NSMutableArray array];
    _manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];

    _UUIDStr=[NSString string];
    _MajorStr=[NSString string];
    _MinorStr=[NSString string];
    
    [self initWebView];
    [self initiBeacon];
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initWebView
{
    NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"shake_anim" withExtension:@"gif"];
    CGRect _rect;
    if (SCREEN_HEIGHT<=480) {
        _rect=CGRectMake((SCREEN_WIDTH-150)/2, 100, 150, 150);
    }else{
        _rect=CGRectMake((SCREEN_WIDTH-200*(SCREEN_WIDTH/320))/2, 100*(SCREEN_WIDTH/320), 200*(SCREEN_WIDTH/320), 200*(SCREEN_WIDTH/320));
    }
    if (isPad)
    {
        _rect=CGRectMake((SCREEN_WIDTH-160*(SCREEN_WIDTH/320))/2, 60*(SCREEN_WIDTH/320), 160*(SCREEN_WIDTH/320), 160*(SCREEN_WIDTH/320));
    }
    _showGifView=[[ShowGifView alloc]initWithFrame:_rect fileURL:fileUrl];
    _showGifView.backgroundColor = [UIColor clearColor];
    __weak typeof(self)weakSelf = self;
    _showGifView.GifStop=^(){
        [weakSelf stopLocationManager];
    };
    [self.view addSubview:_showGifView];
}

-(void)initiBeacon{
    
    _locationManager=[[CLLocationManager alloc]init];
    _locationManager.delegate=self;
    
//    NSUUID *estimoteUUID = [[NSUUID alloc] initWithUUIDString:@"FDA50693-A4E2-4FB1-AFCF-C6EB07647825"];
//    _region = [[CLBeaconRegion alloc] initWithProximityUUID:estimoteUUID identifier:@"ibeacon"];
    
    NSUUID *estimoteUUID = [[NSUUID alloc] initWithUUIDString:@"AB8190D5-D11E-4941-ACC4-42F30510B408"];
    _region = [[CLBeaconRegion alloc] initWithProximityUUID:estimoteUUID identifier:@"ibeacon"];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager*)manager didEnterRegion:(CLRegion*)region
{
    [_locationManager startRangingBeaconsInRegion:_region];
}

- (void)locationManager:(CLLocationManager*)manager didExitRegion:(CLRegion*)region
{
    [_locationManager stopRangingBeaconsInRegion:_region];
}

#pragma mark - 停止定位外设
- (void)stopLocationManager {
    
    [_locationManager stopRangingBeaconsInRegion:_region];
    if (_beaconListArray.count > 0) {
        
        [self requestDataFromNetWithUUID:@"AB8190D5-D11E-4941-ACC4-42F30510B408" Major:_MajorStr Minor:_MinorStr];
    }
    else
    {
        [Tools myHud:@"附近无商家活动" inView:self.view];
    }
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    [_beaconListArray removeAllObjects];
    
    NSDictionary *beaconDic;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"UID"]!=nil) {
        
        NSMutableArray *beaconArray = [NSMutableArray array];
        
        for (CLBeacon *beacon in beacons) {
            if (beacon.accuracy > 0) {
                [beaconArray addObject:beacon];
            }
        }
        
        
        
        if (beaconArray.count > 0) {
            
            CLBeacon *updataBeacon = beaconArray[0];
            beaconDic = @{@"uuid":updataBeacon.proximityUUID.UUIDString,
                          @"major":[updataBeacon.major stringValue],
                          @"minor":[updataBeacon.minor stringValue],
                          @"device_id":@"0"};
            [_beaconListArray addObject:beaconDic];
        }
    }
}


#pragma mark 让这个Controller本身支持摇动并成为第一响应者
- (BOOL)canBecomeFirstResponder {
    return YES;
}

#pragma mark 检测到摇动开始
- (void) motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        NSLog(@"开始摇一摇");
        if (![_showGifView.playStr isEqual:@"1"]) {
            [_showGifView startGif];
            
            if ([CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]])
            {
                [_locationManager startMonitoringForRegion:_region];
                [_locationManager startRangingBeaconsInRegion:_region];
            }else{
                NSLog(@"This device does not support monitoring beacon regions");
            }
        }
    }
}

#pragma mark 摇动取消
-(void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        NSLog(@"摇一摇取消");
    }
}

#pragma mark 检测结束
-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        NSLog(@"摇一摇结束");
    }
}

#pragma mark 获取数据
-(void)requestDataFromNetWithUUID:(NSString *)uuid Major:(NSString *)major Minor:(NSString *)minor
{
    NSDictionary *strDic = @{@"user_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"UID"],
                             @"List":_beaconListArray};
    
    NSString *urlString = [NSString stringWithFormat:GetShake,[Utillity DataTOjsonString:strDic],uuid];
    NSLog(@"%@",urlString);
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Date isShowLoading:NO success:^(id data)
    {
        if ([data isKindOfClass:[NSArray class]]) {
            
            self.hidesBottomBarWhenPushed = YES;
            AdWebViewController *adWebView = [[AdWebViewController alloc] init];
            adWebView.url = data[0][@"page_url"];
            adWebView.name = @"领取优惠券";
            adWebView.isCoupon = YES;
            [self.navigationController pushViewController:adWebView animated:YES];
        }
        else [Tools myHud:@"附近无商家活动" inView:self.view];
        
    } failure:nil];
}

#pragma mark - CBCentralManagerDelegate-蓝牙回调函数
//判断蓝牙是否可用
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSString * state = nil;
    
    switch ([central state])
    {
        case CBCentralManagerStateUnsupported:
            state = @"The platform/hardware doesn't support Bluetooth Low Energy.";
            break;
        case CBCentralManagerStateUnauthorized:
            state = @"The app is not authorized to use Bluetooth Low Energy.";
            break;
        case CBCentralManagerStatePoweredOff:
            NSLog(@"CBCentralManagerStatePoweredOff");
            state = @"Bluetooth is currently powered off.";
            break;
        case CBCentralManagerStatePoweredOn:
            NSLog(@"CBCentralManagerStatePoweredOn");
            state = @"work";
            break;
        case CBCentralManagerStateUnknown:
        default:
            ;
    }
    NSLog(@"Central manager state: %@", state);
}

@end
