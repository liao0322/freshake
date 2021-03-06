//
//  XFExpressDetailsViewController.m
//  InnerForCourier
//
//  Created by DamonLiao on 2017/2/4.
//  Copyright © 2017年 DamonLiao. All rights reserved.
//

#import "XFExpressDetailsViewController.h"
#import "XFExpressDetailsFirstLineTVCell.h"
#import "XFExpressDetailsTimeLineTVCell.h"
#import "XFExpress.h"
#import "XFExpressList.h"
#import "XFExpressNoDataTVCell.h"
#import "Order.h"
#import "MyOrderDetailsModel.h"

#define MARGIN_LEFT 70.0f

@interface XFExpressDetailsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSMutableArray *dataArray;

@property (copy, nonatomic) NSString *originalNo;
@property (copy, nonatomic) NSString *sourceCode;

@property (nonatomic) Order *model;
@property (nonatomic) XFExpress *express;
@property (copy, nonatomic, readonly) NSDictionary *orderStatusDict;

@property (assign, nonatomic) BOOL noExpress;

@end

@implementation XFExpressDetailsViewController

static NSString * const viewExpressTimeLineTVCellID = @"viewExpressTimeLineTVCellID";
static CGFloat const EstimatedCellHeight = 100.0f;

- (instancetype)initWithOrder:(Order *)order {
    self = [super init];
    if (!self) return nil;
    _originalNo = order.order_no;
    _sourceCode = order.sourceCode;
    return self;
}

- (instancetype)initWithMyOrderDetailsModel:(MyOrderDetailsModel *)model {
    self = [super init];
    if (!self) return nil;
    _originalNo = model.order_no;
    _sourceCode = model.sourceCode;
    return self;
}


#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - Override

- (void)requestData {
    [super requestData];

    NSDictionary *parametersDict = @{
                                     @"originalNo": self.originalNo,
                                     @"sourceCode": self.sourceCode,
                                     @"syscode": @"001"
                                     };
    
    NSString *domainString = @"";
    
#if HTTP_TEST_TYPE == 2
    
    domainString = @"http://122.144.136.72:8090/ordercenter/ocapi/";
    
#elif HTTP_TEST_TYPE == 1
    domainString = @"http://oc.freshake.cn:8080/ocapi/";

#endif
    NSString *urlString = [NSString stringWithFormat:@"%@%@", domainString, @"queryOrderExpress"];

    [XFNetworking GET:urlString parameters:parametersDict success:^(id responseObject, NSInteger statusCode) {
        if (statusCode != 200) {
            return;
        }
        
        NSDictionary *dictData = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        
        NSString *code = dictData[@"code"];
        if (![code isEqualToString:@"0"]) {
            return;
        }
        if (!dictData[@"result"]) {
            return;
        }
        NSArray *dataArray = [XFExpressList mj_objectArrayWithKeyValuesArray:dictData[@"result"][@"expresslist"]];
        
        XFExpress *express = [XFExpress mj_objectWithKeyValues:dictData[@"result"][@"express"]];
        
        if (dataArray.count != 0) {
            self.dataArray = [dataArray mutableCopy];
            self.noExpress = NO;
        } else {
            self.noExpress = YES;
            [self.dataArray removeAllObjects];
        }
        if (express) {
            self.express = express;
        }
        
        [self.tableView reloadData];
    } failure:^(NSError *error, NSInteger statusCode) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)initialize {
    [super initialize];
    self.title = @"查看物流";
    self.noExpress = NO;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, MARGIN_LEFT, 0, 0);
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = EstimatedCellHeight;
}

- (void)registerViews {
    [super registerViews];
    [self.tableView registerClass:[XFExpressDetailsTimeLineTVCell class] forCellReuseIdentifier:viewExpressTimeLineTVCellID];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger sections = 0;
    if (self.express) {
        sections += 1;
    }
    if (self.dataArray.count || self.noExpress) {
        sections += 1;
    }
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 1;
    if (section == 1) {
        rows = self.dataArray.count ? self.dataArray.count : 1;
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        XFExpressDetailsFirstLineTVCell *cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XFExpressDetailsFirstLineTVCell class]) owner:nil options:nil] lastObject];
        if (self.express.progress.length > 0) {
            cell.expressStatusLabel.text = self.orderStatusDict[self.express.progress];
        }
        
        return cell;
    } else {
        
        if (self.dataArray.count) {
            XFExpressDetailsTimeLineTVCell *cell = [tableView dequeueReusableCellWithIdentifier:viewExpressTimeLineTVCellID forIndexPath:indexPath];
            XFExpressList *express = self.dataArray[indexPath.row];
            if (indexPath.row == 0) {
                express.first = YES;
            } else  {
                express.first = NO;
            }
            cell.model = express;
            return cell;
        } else {
            XFExpressNoDataTVCell *cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XFExpressNoDataTVCell class]) owner:nil options:nil] lastObject];
            return cell;
        }

    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15.0f;
}

#pragma mark - LazyLoad

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSDictionary *)orderStatusDict {
    return @{
             @"001": @"处理中",
             @"002": @"已支付",
             @"003": @"已分仓",
             @"004": @"已确认",
             @"005": @"已分拣",
             @"006": @"已打包",
             @"007": @"已出库",
             @"008": @"已发货",
             @"009": @"已完成",
             @"010": @"已取消"
             };
}

@end
