//
//  ScanViewController.h
//  Esshop
//
//  Created by Song on 16/5/23.
//  Copyright © 2016年 aierbeitie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ScanViewController : UIViewController


@property (strong,nonatomic)AVCaptureDevice * device;     //捕捉硬件设备
@property (strong,nonatomic)AVCaptureDeviceInput * input; // 外界成像输入配置
@property (strong,nonatomic)AVCaptureMetadataOutput * output; // 成像输出配置
@property (strong,nonatomic)AVCaptureSession * session;       // 捕捉设置
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * prelayer; // 图层布局层
@property (nonatomic, retain) UIImageView * line;

@property (nonatomic, strong) UIImageView               *lineImg;
@property(assign, nonatomic) BOOL                       isUp;
@property(strong, nonatomic) NSTimer                    *timer;

@end
