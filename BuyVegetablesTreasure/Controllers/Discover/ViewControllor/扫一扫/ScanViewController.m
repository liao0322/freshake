//
//  ScanViewController.m
//  Esshop
//
//  Created by Song on 16/5/23.
//  Copyright © 2016年 aierbeitie. All rights reserved.
//

#import "ScanViewController.h"

#define Height IS_IPHONE_4_OR_LESS ? 100:146


@interface ScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"0xf5f6f8"];
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xF6F6F6"];
    self.navigationItem.titleView = [Utillity customNavToTitle:@"扫一扫"];
    self.navigationItem.leftBarButtonItem = [UIFactory createBackBBIWithTarget:self action:@selector(back)];

    //设置自己定义的界面
    [self setOverlayPickerView];
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupCamera];
    _isUp = NO;
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.008 target:self selector:@selector(repeatTime) userInfo:nil repeats:YES];
}
-(void)repeatTime
{
     CGRect rect = _lineImg.frame;
    if (_isUp == NO) {
        rect.origin.y += 1;
        
        if (rect.origin.y >= (ScreenWidth - 12.0f + (Height)-64))
        {
            _isUp = YES;
        }
    } else {
        rect.origin.y -= 1;
        
        if (rect.origin.y <= (Height))
        {
            _isUp = NO;
        }
    }
    _lineImg.frame = rect;
}
- (void)setupCamera
{
    // Device （获取手机设备的硬件 —— 摄像头）
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input （获取手机摄像头的输入流设置）
    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:nil];
    
    // Output （获取手机摄像头的输出流设置）
    _output = [[AVCaptureMetadataOutput alloc]init];
    // 设置输出流协议 AVCaptureMetadataOutputObjectsDelegate
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session 硬件配置设置
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    // 加入硬件配置的输入输出流
    // 策略模式：用策略方法去处理逻辑判断，使用者并不需要知道里面的内部实现，它只需要知道对应返回值去判断下一步处理
    
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    //    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code];
    
    if ([self.output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode])
    {
        self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code];
    }
    
    // Preview 二维码图层（花边等图案）
    dispatch_async(dispatch_get_main_queue(), ^{
        // 更新界面
        // Preview
        _prelayer =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
        _prelayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        //    _preview.frame =CGRectMake(20,110,280,280);
        _prelayer.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        [self.view.layer insertSublayer:self.prelayer atIndex:0];
        // Start 开启摄像头运行
        [_session startRunning];
    });
    
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    NSString *stringValue;
    
    // 元数据对象
    if ([metadataObjects count] >0)
    {
        // 可读码对象
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    // 扫描成功后调用，解析二维码
    [_session stopRunning];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    [_timer invalidate];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stringValue]];
    
    NSLog(@"扫一扫结果:%@",stringValue);
    
}
//设置自己定义的界面
- (void)setOverlayPickerView
{
    // 最上部view
    UIView *upView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0, ScreenWidth, Height)];
    upView.alpha = 0.5;
    upView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:upView];
    
    // 用于说明的label
    UILabel * labIntroudction= [[UILabel alloc] init];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.frame=CGRectMake(30.0f, (Height)/2-20, ScreenWidth-60, 50.0f);
    labIntroudction.font = [UIFont systemFontOfSize:16.0f];
    labIntroudction.textColor=[UIColor whiteColor];
    labIntroudction.textAlignment = NSTextAlignmentCenter;
    labIntroudction.text = @"将二维码放入扫描区域，鲜摇派会为您自动识别";
    labIntroudction.numberOfLines = 0;
    [upView addSubview:labIntroudction];
    
    // 最左部view
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(upView.frame), 40.0f, ScreenWidth - 76.0f)];
    leftView.alpha = 0.5;
    leftView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:leftView];
    
    // 最右部view
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth - 40.0f, CGRectGetMaxY(upView.frame), 40.0f, ScreenWidth - 76.0f)];
    rightView.alpha = 0.5;
    rightView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:rightView];
    
    // 中间的框
    UIImageView *kuangImg = [[UIImageView alloc] initWithFrame:CGRectMake(38.0f, CGRectGetMaxY(upView.frame), ScreenWidth - 76.0f, ScreenWidth - 76.0f)];
    kuangImg.image = IMAGE(@"watch_sao_kuang");
    [self.view addSubview:kuangImg];
    
    // 画中间的基准线
    _lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(38.0f, CGRectGetMaxY(upView.frame), ScreenWidth - 76.0f, 3.0f)];
    _lineImg.image = IMAGE(@"watch_sao_line");
    [self.view addSubview:_lineImg];
    
    // 最下部view
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(kuangImg.frame), ScreenWidth, ScreenHeight)];
    bottomView.alpha = 0.5;
    bottomView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:bottomView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
