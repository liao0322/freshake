//
//  FSMyOrderListViewController.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2017/1/17.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import "FSMyOrderListViewController.h"
#import "FSSegmentView.h"

@interface FSMyOrderListViewController ()
<
    UITableViewDelegate,
    UITableViewDataSource,
    FSSegmentViewDelegate
>

@property (nonatomic) NSArray *titles;
@property (nonatomic) FSSegmentView *segmentView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FSMyOrderListViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.segmentView selectIndex:0];
    
    self.tableView.contentInset = UIEdgeInsetsMake(50, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(50, 0, 0, 0);

}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.segmentView.width = self.view.width;
    self.segmentView.height = 50;
    self.segmentView.x = 0;
    self.segmentView.y = 64;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Override

- (void)initialization {
    [super initialization];
    self.title = @"我的订单";
}

- (void)addSubviews {
    [super addSubviews];
    
    [self.view addSubview:self.segmentView];

}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UITableViewCell new];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 30.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIButton buttonWithType:UIButtonTypeContactAdd];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIButton buttonWithType:UIButtonTypeContactAdd];
}


#pragma mark - FSSegmentViewDelegate

- (void)segmentView:(FSSegmentView *)segmentView didSelectedIndex:(NSInteger)index {
    NSLog(@"点%ld", index);
}

#pragma mark - LazyLoad

- (NSArray *)titles {
    return @[@"所有订单", @"待付款", @"待提货", @"已提货", @"待评价"];
}

- (FSSegmentView *)segmentView {
    if (!_segmentView) {
        _segmentView = [[FSSegmentView alloc] initWithTitles:self.titles];
        _segmentView.delegate = self;
    }
    return _segmentView;
}




@end
