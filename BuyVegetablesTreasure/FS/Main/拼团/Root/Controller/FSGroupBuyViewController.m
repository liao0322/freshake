//
//  FSGroupBuyViewController.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/27.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSGroupBuyViewController.h"
#import "FSGroupBuyTVCell.h"
#import "GroupModel.h"
#import "FSGroupBuyDetailsViewController.h"

@interface FSGroupBuyViewController ()
<
    UITableViewDataSource,
    UITableViewDelegate
>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (copy, nonatomic) NSMutableArray *dataArray;

@end

@implementation FSGroupBuyViewController

static NSString * const groupBuyTVCellID = @"groupBuyTVCellID";

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Override

- (void)getDataFromRemote {
    [super getDataFromRemote];
    
    [self requestDataFromNet];
    
}

- (void)initialization {
    [super initialization];
    
    self.title = @"天天拼团";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorViewBG];
    self.tableView.contentInset = UIEdgeInsetsMake(15, 0, 0, 0);
    self.tableView.rowHeight = SCREEN_WIDTH / (375 / 300.0f);

}

- (void)registerCells {
    [super registerCells];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FSGroupBuyTVCell class]) bundle:nil] forCellReuseIdentifier:groupBuyTVCellID];

}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    rows = self.dataArray.count ? self.dataArray.count : 0;
    return rows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FSGroupBuyTVCell *cell = [tableView dequeueReusableCellWithIdentifier:groupBuyTVCellID forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"a");
    FSGroupBuyDetailsViewController *detailVC = [FSGroupBuyDetailsViewController new];
    detailVC.model = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

#pragma mark - Custom

- (void)requestDataFromNet {
    
    NSString *midSitnrg = [[NSUserDefaults standardUserDefaults] objectForKey:@"MID"];
    NSString *urlString = [NSString stringWithFormat:GetProduct_ActivityList, midSitnrg];

    [SVProgressHUD showWithStatus:@"正在加载..."];
    [XFNetworking GET:urlString parameters:nil success:^(id responseObject, NSInteger statusCode) {
        [SVProgressHUD dismiss];
        NSDictionary *data = [self dictWithData:responseObject];
        
        if ([data[@"issuccess"] boolValue]) {
            
            NSArray *arr = data[@"List"];
            
            for (NSDictionary *dict in arr) {
                
                GroupModel *groupModel = [GroupModel modelWithDict:dict];
                [self.dataArray addObject:groupModel];
            }
            
            if (!self.dataArray.count) {
                self.tableView.backgroundView = self.noDataView;
            } else {
                self.tableView.backgroundView = nil;
            }
            [self.tableView reloadData];
        }
        
    } failure:^(NSError *error, NSInteger statusCode) {
        [self showInfoWidthError:error];
    }];

}

#pragma mark - LazyLoad

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
