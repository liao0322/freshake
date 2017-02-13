//
//  FSBaseViewController.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/7.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSBaseViewController.h"
#import "FSNoDataView.h"


@interface FSBaseViewController ()

@end

@implementation FSBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getDataFromRemote];
    [self requestData];
    [self initialization];
    [self initialize];
    [self setupViews];
    [self setupNavigationBar];
    [self addSubviews];
    [self registerCells];
    [self registerViews];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getDataFromRemote {
}

- (void)initialization {
}

- (void)setupNavigationBar {
}

- (void)addSubviews {
}

- (void)registerCells {
}

- (void)requestData {
}

- (void)initialize {
}
- (void)setupViews {
}
- (void)registerViews {}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.noDataView.frame = self.view.bounds;
    self.netErrorView.frame = self.view.bounds;
    self.loadingView.frame = CGRectMake(0, 0, 120, 120);
    self.loadingView.center = self.view.center;
}

#pragma mark - Custom

- (NSDictionary *)dictWithData:(NSData *)data {
    NSError *error = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    return error ? nil : dict;
}

- (void)showInfoWidthError:(NSError *)error {
    
    if (error.code == -1009) {
        [SVProgressHUD showInfoWithStatus:@"无网络连接!"];
    }
    else if (error.code == -1001) {
        [SVProgressHUD showInfoWithStatus:@"请求超时!"];
    }
    else if (error.code == -1004) {
        [SVProgressHUD showInfoWithStatus:@"无法连接到服务器!"];
    } else if (error.code == -1011) {
        [SVProgressHUD showInfoWithStatus:@"服务器打了个盹~>.<"];
    }
    else if (error.code == -1003) {
        [SVProgressHUD showInfoWithStatus:@"服务器打了个盹~>.<"];
    }
    else {
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@", error.domain]];
    }
}

- (void)showLoading {
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    [keyWindow addSubview:self.loadingView];
    [self.loadingView startWaveToPercent:0.5f];
}

- (void)dismissLoading {
    [self.loadingView dismissWithCompletion:^{
        [UIView animateWithDuration:0.1f animations:^{
            self.loadingView.transform = CGAffineTransformScale(self.loadingView.transform, 0.7f, 0.7f);
        } completion:^(BOOL finished) {
            [self.loadingView removeFromSuperview];
            self.loadingView = nil;
        }];
    }];
}

#pragma mark - LazyLoad

- (FSNoDataView *)noDataView {
    if (!_noDataView) {
        _noDataView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([FSNoDataView class]) owner:nil options:nil] lastObject];
    }
    return _noDataView;
}

- (FSNetErrorView *)netErrorView {
    if (!_netErrorView) {
        _netErrorView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([FSNetErrorView class]) owner:nil options:nil] lastObject];
    }
    return _netErrorView;
}

- (XFWaterWaveView *)loadingView {
    if (!_loadingView) {
        _loadingView = [XFWaterWaveView new];
    }
    return _loadingView;
}
@end
