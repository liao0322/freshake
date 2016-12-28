//
//  PayGroupOrderTableView.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/4/7.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "PayGroupOrderTableView.h"
#import "PaymentCell.h"
#import "CustomerInfoCell.h"
#import "PriceDetailCell.h"
#import "PlayGroupView.h"
#import "SiteViewController.h"
//#import "GroupDetailsImageViewController.h"
#import "FSGroupBuyHelperViewController.h"
#import "RemarkCell.h"
#import "PickupInfoCell.h"
#import "TimeOrCouponCell.h"

#define SectionHeight 50

@interface PayGroupOrderTableView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, copy) UITableView *payGroupOrderTableView;
@property (nonatomic, copy) PlayGroupView *playGroup;

@property (nonatomic, copy) SiteModel *siteModel;
@property (nonatomic, copy) NSString *fendianName;
@property (nonatomic, copy) PriceDetailCell *cell;

@property (nonatomic, assign) BOOL isShowAssorting;
@property (nonatomic, assign) BOOL isUserAdress;

@end

@implementation PayGroupOrderTableView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {

        [self initGroupTableView];
    }
    return self;
}

#pragma mark - 初始化
- (void)initGroupTableView {
    
    _express_id = @"0";
    _express_fee = @"0";
    _fendianId = [[NSUserDefaults standardUserDefaults] objectForKey:@"merchantsID"];
    _fendianName = [[NSUserDefaults standardUserDefaults] objectForKey:@"merchantsName"];
    _accept_address = [[NSUserDefaults standardUserDefaults] objectForKey:@"merchantsAddress"];
    
    _payGroupOrderTableView = [[UITableView alloc]initWithFrame:self.frame style:UITableViewStyleGrouped];
    _payGroupOrderTableView.delegate = self;
    _payGroupOrderTableView.dataSource = self;
    _payGroupOrderTableView.separatorStyle = NO;
    [self addSubview:_payGroupOrderTableView];
    
    NSArray *cellArray = @[@"PaymentCell",
                           @"PickupInfoCell",
                           @"PriceDetailCell",
                           @"UITableViewCell",
                           @"RemarkCell",
                           @"CustomerInfoCell",
                           @"TimeOrCouponCell"];
    
    for (int i = 0; i < cellArray.count; i++) {
        [_payGroupOrderTableView registerClass:[NSClassFromString(cellArray[i]) class] forCellReuseIdentifier:cellArray[i]];
    }
}

- (UISwitch *)integralSwitch {
    
    if (!_integralSwitch) {
        
        _integralSwitch = [UISwitch new];
        [_integralSwitch addTarget:self
                            action:@selector(switchChange:)
                  forControlEvents:UIControlEventValueChanged];
    }
    
    return _integralSwitch;
}

- (void)switchChange:(UISwitch *)integralSwitch {
    self.reloadPrice();
}

#pragma mark - 事件处理
#pragma mark 刷新
- (void)refreshTableView {
    [_payGroupOrderTableView reloadData];
}

- (void)setAvailableIntegral:(CGFloat)availableIntegral {
    
    _availableIntegral = availableIntegral;
    [_payGroupOrderTableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0 || section == 1) {
        return 2;
    }
    
    return 1;
}

#pragma mark 设置Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        if (_isUserAdress) {
            
            if (indexPath.row == 0) {
                
                PickupInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PickupInfoCell"];
                cell.model = self.siteModel;
                return cell;
            }
            else {
                
                RemarkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RemarkCell"];
                return cell;
            }
        }
        else {
            
            if (indexPath.row == 0) {
                
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
                
                if (cell == nil) {
                    
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
                    cell.selectionStyle = NO;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    
                    for (int i = 0; i < 1; i++) {
                        
                        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 39 * i, ScreenWidth, 0.5)];
                        line.backgroundColor = [UIColor colorWithHexString:@"0xE2E2E2"];
                        [cell addSubview:line];
                    }
                }

                cell.textLabel.text = _fendianName;
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                
                return cell;
            }
            else {
                
                CustomerInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomerInfoCell"];
                [cell setData];
                return cell;
            }
        }
    }
    else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            PaymentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PaymentCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else {
            
            TimeOrCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimeOrCouponCell"];
            cell.textLabel.text = [NSString stringWithFormat:@"可用%.0f积分抵用%.2f元", self.availableIntegral, (float)self.availableIntegral / 100];
            cell.accessoryView = self.integralSwitch;
            return cell;
        }
        

    }
    else if (indexPath.section == 2) {
        
        _cell = [tableView dequeueReusableCellWithIdentifier:@"PriceDetailCell"];
        _cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [_cell setGroupModel:_gourpModel];
        
        WS(weakSelf);
        _cell.isSelect = ^(BOOL isSelect) {
            
            _isShowAssorting = isSelect;
            [weakSelf.payGroupOrderTableView reloadData];
        };
        
        return _cell;
    }
    else {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        cell.selectionStyle = NO;
        
        __weak typeof(_goAddress)weakGoViewController = _goAddress;
        if (_playGroup == nil) {
            
            _playGroup = [[PlayGroupView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 90) andShowNumber:@"2"];
            
            _playGroup.goPlayGroup=^(){
                weakGoViewController([FSGroupBuyHelperViewController new]);
            };
            
            [cell addSubview:_playGroup];
        }

        return cell;
    }
}

#pragma mark - UITableViewDelegate
#pragma mark 设置Cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        if (_isUserAdress) {
            
            if (indexPath.row == 0) {
                
                return [tableView cellHeightForIndexPath:indexPath
                                                   model:self.siteModel
                                                 keyPath:@"model"
                                               cellClass:[PickupInfoCell class]
                                        contentViewWidth:ScreenWidth];
            }
            
            return 45;
        }
        else {
            
            if (indexPath.row == 0) {
                return 40;
            }
            
            return 135;
        }
    }
    else if (indexPath.section == 1) {
        
        if (indexPath.row == 1) {
            return 45;
        }
        
        return 50 + 50 * 3;
    }
    else if (indexPath.section == 2) {
        return _isShowAssorting ? 250 : 150;
    }
    else {
        return 90;
    }
}

#pragma mark 设置断头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 1 || section == 3) {
        return 0.01;
    }
    
    return SectionHeight;
}

#pragma mark 设置断尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

#pragma mark 设置段头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0 || section == 2)
    {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, SectionHeight)];
        bgView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 20, 20)];
        titleImage.tintColor = [UIColor colorDomina];
        titleImage.image = [[UIImage imageNamed:section == 0 ? @"到店自提图标" : @"商品详情"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [bgView addSubview:titleImage];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleImage.frame) + 10, 15, ScreenWidth, 20)];
        titleLabel.text = section == 0 ? @"收（取）货地址" : @"商品详情";
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textColor = [UIColor colorDomina];
        [bgView addSubview:titleLabel];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
        line.backgroundColor = [UIColor colorWithHexString:@"0xDAD9D9"];
        [bgView addSubview:line];
        
        for (int i = 0; i < 2; i++) {
            
            UILabel *line = [UILabel new];
            line.backgroundColor = LineColor;
            [bgView addSubview:line];
            
            line.sd_layout
            .leftEqualToView(bgView)
            .rightEqualToView(bgView)
            .topEqualToView(bgView)
            .heightIs(0.5);
            
            if (i == 0) line.sd_layout.topEqualToView(bgView);
            else line.sd_layout.bottomEqualToView(bgView);
        }
        
        return bgView;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        SiteViewController *siteVc = [[SiteViewController alloc] init];
        siteVc.isDelivery = _isDelivery;
        siteVc.isDistribution = _isDistribution;
        
        siteVc.midSite = ^(Map *mapArray) {
            
            _isUserAdress = NO;
            _fendianName = mapArray.Fendianname;
            _express_id = @"0";
            _express_fee = @"0.00";
            [_cell setDistancePrice:_express_fee];
            if (_reloadPrice) {
                _reloadPrice();
            }
            _fendianId = mapArray.id;
            _accept_address = mapArray.addr;
            [_payGroupOrderTableView reloadData];
        };
        
        siteVc.userAddress = ^(SiteModel *userAddressArray) {
            
            CLLocationCoordinate2D coor;
            coor.latitude = [userAddressArray.X doubleValue];
            coor.longitude = [userAddressArray.Y doubleValue];
            _currentCoor(coor);
            
            _isUserAdress = YES;
            _siteModel = userAddressArray;
            _express_id = @"1";
            [Single sharedInstance].userTel = userAddressArray.Phone;
            
            //满多少减运费
            _express_fee = [[NSUserDefaults standardUserDefaults] objectForKey:@"DistancePrice"];
            if ([_gourpModel.ActivityPrice floatValue] >= [_fullPrice floatValue]) {
                _express_fee = @"0.00";
            }
            [_cell setDistancePrice:_express_fee];
            
            if (_reloadPrice) {
                _reloadPrice();
            }
            [Single sharedInstance].userName = [NSString stringWithFormat:@"%@ %@",userAddressArray.userName,[userAddressArray.sex boolValue] ? @"先生" : @"女士"];
            _accept_address = [NSString stringWithFormat:@"%@ %@",userAddressArray.Area,userAddressArray.Address];
            
            [_payGroupOrderTableView reloadData];
        };
        
        _goAddress(siteVc);
    }
}

@end
