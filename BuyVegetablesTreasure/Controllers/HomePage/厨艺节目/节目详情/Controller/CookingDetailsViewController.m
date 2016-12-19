//
//  CookingDetailsViewController.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/4/29.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "CookingDetailsViewController.h"
#import "CookingProgramListModel.h"
#import "CookingDetailsView.h"
#import "XSMediaPlayer.h"
#import "AppDelegate.h"

@interface CookingDetailsViewController ()

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) CookingDetailsView *cookingDetailsView;
@property (nonatomic, strong) XSMediaPlayer *player;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation CookingDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [NSMutableArray array];
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.appDelegate.allowRotation = 1;
    
    // 设置导航条
    [self setNav];
    // 初始化播放器
    [self initPlayer];
    // 获取视频信息
    [self getVedioInfo];
    // 初始化节目想起
    [self initCookingDetailsView];
    // 初始化收藏按钮
    [self initCollect];
    // 增加浏览次数
    [self addReckonFlow];
}

- (void)viewWillDisappear:(BOOL)animated {

    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.appDelegate.allowRotation = 0;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        
        self.player.frame = CGRectMake(0, 0, ScreenWidth, ScreenWidth / 5 * 3);
        self.navigationController.navigationBarHidden = NO;
    }
    else {
        
        self.player.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        self.navigationController.navigationBarHidden = YES;
    }
    
    CGRect frame = _cookingDetailsView.frame;
    frame.origin.y = CGRectGetMaxY(_player.frame);
    _cookingDetailsView.frame = frame;
}

#pragma mark - 初始化
#pragma mark 节目详情
- (void)initCookingDetailsView {
    
    _cookingDetailsView = [[CookingDetailsView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_player.frame), ScreenWidth, ScreenHeight - 50 - CGRectGetMaxY(_player.frame) - 64)];
    [self.view addSubview:_cookingDetailsView];
}

#pragma mark 视频播放
- (void)initPlayer {
    
    _player = [[XSMediaPlayer alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth / 5 * 3)];
    _videoURL = [_videoURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    _player.urlString = _videoURL;
    [self.view addSubview:_player];
}

#pragma mark 设置导航条
- (void)setNav {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = [Utillity customNavToTitle:_nameString];
    self.navigationItem.leftBarButtonItem = [UIFactory createBackBBIWithTarget:self action:@selector(back)];
}

#pragma mark 收藏
- (void)initCollect {
    
    UIButton *collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    collectBtn.selected = _isVedio;
    collectBtn.frame = CGRectMake(0, ScreenHeight - 64 - 50, ScreenWidth, 50);
    collectBtn.backgroundColor = [UIColor colorWithHexString:@"0xf8f8f8"];
    [collectBtn setTitle:@" 收藏" forState:UIControlStateNormal];
    [collectBtn setTitleColor:[UIColor colorWithHexString:@"0x979796"] forState:UIControlStateNormal];
    [collectBtn setTitleColor:Color forState:UIControlStateSelected];
    [collectBtn setImage:IMAGE(@"收藏灰色") forState:UIControlStateNormal];
    [collectBtn setImage:IMAGE(@"已收藏") forState:UIControlStateSelected];
    [collectBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:collectBtn];
    
    collectBtn.layer.borderColor = [UIColor colorWithHexString:@"0xd7d7d7"].CGColor;
    collectBtn.layer.borderWidth = 0.5;
}

#pragma mark - 事件处理
#pragma mark 返回
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 点击收藏或下载按钮
- (void)btnClick:(UIButton *)btn {
    
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        [self addVedioCollection];
    }
    else [self removeVedioCollection];
    
}

#pragma mark - 数据请求
#pragma mark 获取视频信息
- (void)getVedioInfo {
    
    NSString *urlString = [NSString stringWithFormat:GetVedioInfo,_idString];
    NSLog(@"详情接口%@",urlString);
    
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:YES success:^(id data)
     {
         if ([data[@"issuccess"] boolValue]) {
             
             [_dataSource removeAllObjects];
             
             CookingProgramListModel *model = [[CookingProgramListModel alloc] init];
             model.Title = _nameString;
             [model setValuesForKeysWithDictionary:data];
             [_dataSource addObject:model];
         }

         _cookingDetailsView.dataSource = _dataSource;
         [_cookingDetailsView refreshTableView];
         
     } failure:nil];
}

#pragma mark 增加浏览次数
- (void)addReckonFlow {

    NSString *urlString = [NSString stringWithFormat:ReckonFlow,_idString];
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:NO success:^(id data) {} failure:nil];
}

#pragma mark 收藏视频
- (void)addVedioCollection {
    
    NSString *uidString = [[NSUserDefaults standardUserDefaults] objectForKey:@"UID"];
    NSString *urlString = [NSString stringWithFormat:AddVedioCollection,_idString,uidString,_nameString];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:NO success:^(id data)
    {
        [Tools myHud:data[@"context"] inView:self.view];
    
    } failure:nil];
}

#pragma mark 取消收藏视频
- (void)removeVedioCollection {
    
    NSString *uidString = [[NSUserDefaults standardUserDefaults] objectForKey:@"UID"];
    NSString *urlString = [NSString stringWithFormat:RemoveVedioCollection,_idString,uidString];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:NO success:^(id data)
     {
         [Tools myHud:data[@"context"] inView:self.view];
         
     } failure:nil];
}

@end
