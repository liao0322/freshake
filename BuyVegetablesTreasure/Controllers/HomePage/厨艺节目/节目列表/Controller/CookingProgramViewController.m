//
//  CookingProgramViewController.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/4/26.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "CookingProgramViewController.h"
#import "CookingProgramListModel.h"
#import "CookingProgramView.h"

@interface CookingProgramViewController ()

@property (nonatomic, copy) CookingProgramView *cookingProgramView;
@property (nonatomic, copy) NSMutableArray *dataSource;

@end

@implementation CookingProgramViewController

- (void)viewWillAppear:(BOOL)animated {
    [self getStorePament];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSource = [NSMutableArray array];
    
    [self setNav];
    [self initCookingProgramView];
    [self getStorePament];
}

#pragma mark - 初始化
#pragma mark 节目列表
- (void)initCookingProgramView {
    
    _cookingProgramView = [[CookingProgramView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
    [self.view addSubview:_cookingProgramView];
    
    WS(weakSelf);
    _cookingProgramView.goViewController = ^(UIViewController *viewController) {
        
        weakSelf.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:viewController animated:YES];
    };
    
    _cookingProgramView.isCollect = ^(NSString *idSitrng, NSString *nameString, BOOL isCollect) {
        
        if (isCollect) {
            [weakSelf addVedioCollectionWithId:idSitrng name:nameString];
        }
        else {
            [weakSelf removeVedioCollectionWithId:idSitrng];
        }
    };
}

#pragma mark 设置导航条
- (void)setNav {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = [Utillity customNavToTitle:@"厨艺节目"];
    self.navigationItem.leftBarButtonItem = [UIFactory createBackBBIWithTarget:self action:@selector(back)];
}

#pragma mark - 事件处理
#pragma mark 返回
- (void)back{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - 数据请求
- (void)getStorePament {

    NSString *midString = [[NSUserDefaults standardUserDefaults] objectForKey:@"MID"];
    NSString *uidString = [[NSUserDefaults standardUserDefaults] objectForKey:@"UID"];
    NSString *urlString = [NSString stringWithFormat:GetVedioList,midString,uidString];
    NSLog(@"%@",urlString);
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:YES success:^(id data)
     {
         if ([data[@"issuccess"] boolValue]) {
             
             [_dataSource removeAllObjects];
             
             for (NSDictionary *dic in data[@"List"]) {
                 
                 CookingProgramListModel *model = [[CookingProgramListModel alloc] init];
                 [model setValuesForKeysWithDictionary:dic];
                 [_dataSource addObject:model];
             }
             
             _cookingProgramView.dataSource = _dataSource;
             [_cookingProgramView refreshTableView];
         }
        
     } failure:nil];
}

#pragma mark 收藏视频
- (void)addVedioCollectionWithId:(NSString *)idString name:(NSString *)nameString {
    
    NSString *urlString = [NSString stringWithFormat:AddVedioCollection,idString,kGetUserId,nameString];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:NO success:^(id data)
     {
         [Tools myHud:data[@"context"] inView:self.view];
         
     } failure:nil];
}

#pragma mark 取消收藏视频
- (void)removeVedioCollectionWithId:(NSString *)idString {
    
    NSString *uidString = [[NSUserDefaults standardUserDefaults] objectForKey:@"UID"];
    NSString *urlString = [NSString stringWithFormat:RemoveVedioCollection,idString,uidString];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:NO success:^(id data)
     {
         [Tools myHud:data[@"context"] inView:self.view];
         
     } failure:nil];
}

@end
