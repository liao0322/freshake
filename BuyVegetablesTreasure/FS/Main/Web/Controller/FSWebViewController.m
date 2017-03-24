//
//  FSWebViewController.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2017/3/15.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import "FSWebViewController.h"
#import <WebKit/WebKit.h>

@interface FSWebViewController ()

@property (nonatomic) WKWebView *webView;
@property (copy, nonatomic) NSString *urlString;

@end

@implementation FSWebViewController

- (instancetype)initWithUrlString:(NSString *)urlString {
    self = [super init];
    if (!self) return nil;
    _urlString = urlString;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)addSubviews {
    [super addSubviews];
    [self.view addSubview:self.webView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - LazyLoad

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:self.view.frame];
    }
    return _webView;
}

@end
