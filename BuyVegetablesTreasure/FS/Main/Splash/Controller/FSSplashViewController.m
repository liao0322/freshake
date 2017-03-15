//
//  FSSplashViewController.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2017/3/14.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import "FSSplashViewController.h"
#import "AppDelegate.h"
#import "JDFile.h"
#import "XFKVCPersistence.h"
#import "XFMemoryStorage.h"

@interface FSSplashViewController ()
@property (weak, nonatomic) IBOutlet UIButton *adImageButton;
@property (weak, nonatomic) IBOutlet UIButton *countDownButton;

@property (nonatomic) NSTimer *timer;
@property (assign, nonatomic) int count;

@end

static int const showTime = 3;

@implementation FSSplashViewController

#pragma mark - CycleLife

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Override

- (void)initialize {
    [super initialize];
    
    self.count = showTime;
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];

}

- (void)setupViews {
    [super setupViews];
    
    [self.countDownButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f]] forState:UIControlStateNormal];
    self.countDownButton.layer.cornerRadius = 15.0f;
    self.countDownButton.layer.masksToBounds = YES;
    [self.countDownButton setTitle:[NSString stringWithFormat:@"%ds", showTime] forState:UIControlStateNormal];
    
    
    NSString *filePath = [self filePathWithImageName:[XFKVCPersistence get:KEY_AD_IMAGE_NAME]];
    [self.adImageButton setImage:[UIImage imageWithContentsOfFile:filePath] forState:UIControlStateNormal];
}


#pragma mark - Private

- (NSString *)filePathWithImageName:(NSString *)imageName {
    NSString *filePath = nil;
    if (imageName) {
        NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        filePath = [[pathArray objectAtIndex:0] stringByAppendingPathComponent:imageName];
    }
    return filePath;
}

// 点击了广告图片
- (IBAction)adImagePressed:(UIButton *)sender {
    [XFMemoryStorage setValue:@YES forKey:KEY_PUSH_TO_AD];
    [self invalidateTimer];
    [[AppDelegate appDelegate] toMain];
}

- (IBAction)countDownButtonPressed:(UIButton *)sender {
    
}

- (void)countDown {
    self.count--;
    [self.countDownButton setTitle:[NSString stringWithFormat:@"%ds", self.count] forState:UIControlStateNormal];
    if (self.count == 0) {
        [self invalidateTimer];
        [[AppDelegate appDelegate] toMain];
    }
}

- (void)invalidateTimer {
    [self.timer invalidate];
    self.timer = nil;
}
#pragma mark - LazyLoad

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    }
    return _timer;
}
@end
