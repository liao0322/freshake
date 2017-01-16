//
//  FSViewExpressViewController.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2017/1/16.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import "FSViewExpressViewController.h"

#import "FSViewExpressFirstLineTVCell.h"
#import "FSViewExpressTimeLineTVCell.h"

@interface FSViewExpressViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FSViewExpressViewController

static NSString * const viewExpressFirstLineTVCellID = @"viewExpressFirstLineTVCellID";
static NSString * const viewExpressTimeLineTVCellID = @"viewExpressTimeLineTVCellID";

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Override

- (void)initialization {
    [super initialization];
    self.title = @"查看物流";
    
}

- (void)registerCells {
    [super registerCells];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FSViewExpressFirstLineTVCell class]) bundle:nil] forCellReuseIdentifier:viewExpressFirstLineTVCellID];
    
    [self.tableView registerClass:[FSViewExpressTimeLineTVCell class] forCellReuseIdentifier:viewExpressTimeLineTVCellID];
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 10;
    if (section == 0) {
        rows = 1;
    }
    return rows;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:viewExpressFirstLineTVCellID forIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:viewExpressTimeLineTVCellID forIndexPath:indexPath];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 84.0f;
    if (indexPath.section == 0) {
        height = 105.0f;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15.0f;
}

@end
