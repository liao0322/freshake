//
//  FSHomeViewController.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/7.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSHomeViewController.h"
#import "FSHomeView.h"
#import "FSHomeHeaderView.h"
#import "UIButton+Create.h"
#import "FSSearchViewController.h"
#import "FSHomeNavigationBar.h"
#import <Masonry.h>
#import "UIColor+Extension.h"
#import "XFNetworking.h"
#import "SearchViewController.h"

#import "HomePageModel.h"
#import "XFCarouselView.h"
#import "XFNoHighlightButton.h"

#import "Map.h"
#import "RightGoodsModel.h"

#import "FSDancingBananaHeader.h"
#import "FSSectionOneHeaderView.h"

#import "FSHomeActivityCVCell.h"
#import "FSCommodityCVCell.h"

#import "FSLoginViewController.h"
#import "FSNavigationController.h"
#import "GoodsDetailViewController.h"

#import "FSClassificationViewController.h"
#import "AdWebViewController.h"

#import "SelectSiteViewController.h"

#import "FSGroupBuyViewController.h"
#import "AmountViewController.h"

#import "FSNewCommodityViewController.h"
#import "XFMemoryStorage.h"
#import "XFKVCPersistence.h"
#import "FSWebViewController.h"


#define NAV_BAR_ALPHA 0.95f
#define APP_ID @"1136079278"

@interface FSHomeViewController ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    XFCarouselViewDelegate,
    BMKLocationServiceDelegate,
    FSHomeFourButtonViewDelegate,
    FSCommodityCVCellDelegate,
    BMKGeoCodeSearchDelegate
>

// 自定义的导航栏
@property (nonatomic) FSHomeNavigationBar *navigationBar;

// 主view
@property (nonatomic) FSHomeView *mainView;

@property (nonatomic) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic) UIActivityIndicatorView *indicatorView;
@property (copy, nonatomic) NSMutableArray *carouselImageUrlArray;
@property (copy, nonatomic) NSMutableArray *carouselModelArray;

// 百度地图相关属性
/// geo搜索服务
@property (nonatomic) BMKGeoCodeSearch *geoCodeSearch;

@property (nonatomic) BMKLocationService *locService;

/// 用户ID
@property (copy, nonatomic) NSString *uidString;

/// 这个ID是什么鬼
@property (copy, nonatomic) NSString *midString;

/// 提货点ID
@property (copy, nonatomic) NSString *storeIdString;

@property (assign, nonatomic) UIStatusBarStyle statusBarStyle;

@property (copy, nonatomic) NSMutableArray *adRlistArray;

/// 商品数据
@property (copy, nonatomic) NSMutableArray *commodityArray;

@property (copy, nonatomic) NSString *currentCityString;

@property (nonatomic) MJRefreshNormalHeader *normalHeader;

@end


@implementation FSHomeViewController

static NSString * const commodityVCCellID = @"commodityVCCellID";
static NSString * const activityCVCellID = @"activityCVCellID";
static NSString * const headerReuseID = @"headerReuseID";
static NSString * const sectionOneHeaderID = @"sectionOneHeaderID";
static NSString * const defaultFooterReuseID = @"defaultFooterReuseID";

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置自定义的 nav bar 背景透明
    [self setNavBarAppearance];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //[self startLocation];
    [self getHomeData];
    
    // 设置当前提货点名称
    [self.navigationBar.leftButton setTitle:[[[NSUserDefaults standardUserDefaults] objectForKey:@"merchantsName"] substringWithRange:NSMakeRange(0, 2)] forState:UIControlStateNormal];
    
    // 隐藏系统 nav bar
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [[UIApplication sharedApplication] setStatusBarStyle:self.statusBarStyle animated:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([[XFMemoryStorage get:KEY_PUSH_TO_AD] boolValue]) {
        [XFMemoryStorage setValue:@NO forKey:KEY_PUSH_TO_AD];
        [self pushToAd];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // 显示系统 nav bar
    if ( self.navigationController.childViewControllers.count > 1 ) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    
    self.statusBarStyle = [UIApplication sharedApplication].statusBarStyle;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    
    // 取消自定义的 nav bar 背景透明
    // [self resetNavBarAppearance];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Override


- (void)getDataFromRemote {
    
    // 检查网络
    [XFNetworking checkNetworkStatusWithBlock:^(XFNetworkStatus status) {
        
        if (status == XFNetworkStatusNotReachable || status == XFNetworkStatusUnknown) { // 无网络
            [SVProgressHUD showInfoWithStatus:@"无网络连接!"];
            
            if (!self.commodityArray.count) {
                self.mainView.backgroundView = self.netErrorView;
            }
        } else {
            self.mainView.backgroundView = nil;
//            [SVProgressHUD showWithStatus:@"正在加载..."];
//            [self showLoading];
            [XFWaterWaveView showLoading];
            // 开始定位
            [self startLocation];
        }
    }];
}


- (void)initialization {
    [super initialization];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.statusBarStyle = UIStatusBarStyleLightContent;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center addObserver:self selector:@selector(userIsLogined) name:@"UserIsLogined" object:nil];
    
    [center addObserver:self selector:@selector(userIsLogout) name:@"UserIsLogout" object:nil];
    
    [center addObserver:self selector:@selector(rid:) name:@"kJPFNetworkDidLoginNotification" object:nil];
    
    [self checkForUpdates];
    
    // 检查mid 是否存在
    NSString *mid = [[NSUserDefaults standardUserDefaults] objectForKey:@"MID"];
    if (!mid) {
        [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"MID"];
    }
}

// 检查更新
- (void)checkForUpdates {
    // 获取当前版本
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersionString = infoDic[@"CFBundleShortVersionString"];
    
    NSString *newCurrentVersionString = [currentVersionString stringByReplacingOccurrencesOfString:@"." withString:@""];
    // 获取app store 版本
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/cn/lookup?id=%@", APP_ID]];
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://test.freshake.cn:9970/api/Phone/Fifth/index.aspx?page=GetCheck&appNo=%@&type=4", newCurrentVersionString]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data == nil) {
            NSLog(@"你没有连接网络");
            return;
        }
        
        NSDictionary *appInfoDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        BOOL isSuccess = [appInfoDic[@"issuccess"] boolValue];
        if (!isSuccess) {
            return;
        }
        
        NSString *releaseInfo = appInfoDic[@"appContext"];
        
        NSString *appStoreVersion = appInfoDic[@"appName"];
        
        if ([self compareCurrentVersion:currentVersionString appStoreVersion:appStoreVersion]) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"版本更新" message:@"检测到新版本，是否更新？" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *updateAction = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@?ls=1&mt=8", APP_ID]];
                UIApplication *application = [UIApplication sharedApplication];
                if ([application canOpenURL:url]) {
                    [application openURL:url];
                }
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            
            BOOL isUpgrade = [appInfoDic[@"isupgrade"] boolValue];
            
            [alert addAction:updateAction];
            if (!isUpgrade) { // 强制升级
                [alert addAction:cancelAction];
            }
            
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
            
        } else {
            NSLog(@"版本号好像比商店大噢!检测到不需要更新");
        }
    }];
    
    [dataTask resume];
}

- (BOOL)compareCurrentVersion:(NSString *)currentVersion appStoreVersion:(NSString *)appStoreVersion {
    
    if ([currentVersion compare:appStoreVersion options:NSNumericSearch] == NSOrderedAscending) {
        // 有新版本
        return YES;
    } else {
        return NO;
    }
}

- (void)rid:(NSNotification *)not {
    NSLog(@"%@", not.userInfo);
}

// 点击了启动广告
- (void)pushToAd {
    
    NSInteger typeId = [[XFKVCPersistence get:KEY_EVENT_TYPE_ID] integerValue];
    UIViewController *viewController = [UIViewController new];
    NSInteger goodsId = [[XFKVCPersistence get:KEY_EVENT_ID] integerValue];
    
    if (typeId == 1) { // 跳转到商品详情
        
        if (goodsId == 0) return;
        GoodsDetailViewController *goodsDetailVc = [[GoodsDetailViewController alloc] init];
        goodsDetailVc.ProductId = goodsId;
        viewController = goodsDetailVc;
        
        
    } else if (typeId == 2) { // 跳转到分类
        
        FSClassificationViewController *singleClassificationVC = [[FSClassificationViewController alloc] init];
        singleClassificationVC.isSingle = YES;
        singleClassificationVC.categoryId = goodsId;
        viewController = singleClassificationVC;
        
    } else { // 跳转到 web
        
        /*
        AdWebViewController *ad = [[AdWebViewController alloc] init];
        ad.name = model.Name;
        ad.url = model.Url;
        viewController = ad;
         */
        
        
        FSWebViewController *webVC = [FSWebViewController new];
        viewController = webVC;
        
    }
    
    [self.navigationController pushViewController:viewController animated:YES];

}

- (void)addSubviews {
    [super addSubviews];
    [self.view addSubview:self.mainView];
    [self.view addSubview:self.navigationBar];

    [self.navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.mainView);
        make.height.equalTo(@64);
        make.top.left.equalTo(@0);
    }];
}

- (void)registerCells {
    [super registerCells];

    // 注册 cell
    [self.mainView registerClass:[FSHomeActivityCVCell class] forCellWithReuseIdentifier:activityCVCellID];
    
    [self.mainView registerNib:[UINib nibWithNibName:NSStringFromClass([FSCommodityCVCell class]) bundle:nil] forCellWithReuseIdentifier:commodityVCCellID];
    
    // 注册 header
    [self.mainView registerClass:[FSHomeHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerReuseID];
    
    [self.mainView registerNib:[UINib nibWithNibName:NSStringFromClass([FSSectionOneHeaderView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionOneHeaderID];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.mainView.frame = self.view.bounds;
    self.indicatorView.frame = self.view.bounds;
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSInteger section = 0;
    if (self.carouselModelArray.count || self.adRlistArray.count) {
        section += 1;
    }
    if (self.commodityArray.count) {
        section += 1;
    }
    return section;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    
    if (section == 0) {
        return self.adRlistArray.count;
    } else if (section == 1) {
        return self.commodityArray.count;
    }
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        FSHomeActivityCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:activityCVCellID forIndexPath:indexPath];
        
        HomePageModel *model = self.adRlistArray[indexPath.row];
        
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.ImgUrl]];
        
        return cell;
    } else if (indexPath.section == 1) {
        NSInteger row = indexPath.row;
        
        FSCommodityCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:commodityVCCellID forIndexPath:indexPath];
        cell.delegate = self;

        if (row % 2 == 0) { // 偶
            cell.rightSeparatorLine.hidden = NO;

        } else {
            cell.rightSeparatorLine.hidden = YES;

        }

        if (self.commodityArray.count % 2 != 0) { // 个数为奇数
            if (row == (self.commodityArray.count - 2)) {
                cell.bottomSeparatorLine.hidden = NO;
            } else {
                cell.bottomSeparatorLine.hidden = YES;
            }
        }

        
        RightGoodsModel *model = self.commodityArray[indexPath.row];
        cell.model = model;
        return cell;
    }
    return nil;
    

}

// 设置 section 的头或尾
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) { // header
        
        if (indexPath.section == 0) {
            FSHomeHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerReuseID forIndexPath:indexPath];
            
            headerView.carouselView.imageUrlArray = self.carouselImageUrlArray;
            headerView.carouselView.delegate = self;
            headerView.fourButtonView.delegate = self;
            return headerView;
        } else if (indexPath.section == 1) {
            FSSectionOneHeaderView *sectionOneHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:sectionOneHeaderID forIndexPath:indexPath];
            return sectionOneHeader;
        }
        
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) { // footer

        return nil;
    }
    
    
    return nil;
}
/*
 * 上面这个方法使用时必须要注意的一点：
    如果布局没有为 headerView 或 footerView 设置size的话(默认size为CGSizeZero)，则该方法不会被调用。所以如果需要显示header或footer，需要手动设置size。
    可以通过设置UICollectionViewFlowLayout的headerReferenceSize和footerReferenceSize属性来全局控制size。或者通过重载代理方法来分别设置
 */

#pragma mark - UICollectionViewDelegate

/// 点击了活动 或 或者商品
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击了 %ld", indexPath.section);
    NSInteger section = indexPath.section;

    UIViewController *viewController = nil;
    
    if (section == 0) { // 点击了活动
        
        HomePageModel *model = self.adRlistArray[indexPath.row];
        
        if ([model.ObjectType integerValue] == 1) { // 跳转到商品详情
            if ([model.ObjectId integerValue] == 0) return;
            
            GoodsDetailViewController *goodsDetailVc = [[GoodsDetailViewController alloc] init];
            NSString *productIdString = [model.ObjectId stringByReplacingOccurrencesOfString:@"," withString:@""];
            goodsDetailVc.ProductId = [productIdString integerValue];
            viewController = goodsDetailVc;
            
        } else if ([model.ObjectType integerValue] == 2) { // 跳转到分类
            
            FSClassificationViewController *singleClassificationVC = [[FSClassificationViewController alloc] init];
            
            NSString *categoryIdString = [model.ObjectId stringByReplacingOccurrencesOfString:@"," withString:@""];
            singleClassificationVC.isSingle = YES;
            singleClassificationVC.categoryId = [categoryIdString integerValue];
            viewController = singleClassificationVC;
            
        } else { // 跳转到 web
            
            AdWebViewController *ad = [[AdWebViewController alloc] init];
            ad.name = model.Name;
            ad.url = model.Url;
            viewController = ad;
        }
        
    } else if (section == 1) { // 点击了商品
        
        RightGoodsModel *model = self.commodityArray[indexPath.row];
        GoodsDetailViewController *goods = [[GoodsDetailViewController alloc] init];
        goods.ProductId = [model.id integerValue];
        viewController = goods;
        
    }
    
    [self.navigationController pushViewController:viewController animated:YES];

    
}

// UICollectionViewDelegateFlowLayout 是 UICollectionViewDelegate 的子协议
#pragma mark - UICollectionViewDelegateFlowLayout

// 设置每一个 cell 的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return (CGSize){collectionView.width, collectionView.width / 2.5};
    }
    return (CGSize){collectionView.width * 0.5, [FSCommodityCVCell height]};
}

// 设置每组的边界
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

// cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return 5;
    }
    return 0;
}

// cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {

    return 0;
}

// section 的 header 高度
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return (CGSize){ScreenWidth, [FSHomeHeaderView height]};
    }
    return (CGSize){ScreenWidth, 44 + 10};
}

// section 的 footer 高度

/*
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    return (CGSize){ScreenWidth,22};
}
 */

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY > 0) { // 往上推
        
        // 取消整体透明
        self.navigationBar.alpha = NAV_BAR_ALPHA;
        
        // 设置 nav bar 背景透明
        self.navigationBar.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:offsetY / 64];
        
        if (offsetY > 32) {
            
            // 显示nav bar 阴影并设置字体为黑色和深灰色
            self.navigationBar.shadowView.hidden = NO;
            self.navigationBar.shadowView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:offsetY / 64];
            [self.navigationBar.leftButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            self.navigationBar.leftButton.tintColor = [UIColor darkGrayColor];
            
            [self.navigationBar.titleButton setTitleColor:[UIColor colorWithHex:0x8b8b91] forState:UIControlStateNormal];
            [self.navigationBar.titleButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:0 alpha:.1f]] forState:UIControlStateNormal];
            self.navigationBar.titleButton.tintColor = [UIColor grayColor];
            
            
            // 设置状态栏为黑色
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
        } else {
            // 隐藏 nav bar 阴影并设置字体为白色
            self.navigationBar.shadowView.hidden = YES;
            [self.navigationBar.leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.navigationBar.titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.navigationBar.titleButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:40 alpha:.5f]] forState:UIControlStateNormal];
            self.navigationBar.leftButton.tintColor = [UIColor whiteColor];
            self.navigationBar.titleButton.tintColor = [UIColor whiteColor];
            
            // 设置状态栏为白色
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
        }
        
    } else if (offsetY == 0) {
        
        // 显示全部并设置字体为白色
        self.navigationBar.shadowView.hidden = YES;
        [self.navigationBar.leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.navigationBar.titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.navigationBar.titleButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:40 alpha:.5f]] forState:UIControlStateNormal];
        self.navigationBar.leftButton.tintColor = [UIColor whiteColor];
        self.navigationBar.titleButton.tintColor = [UIColor whiteColor];
        
        // 设置状态栏为白色
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
        
        // 取消整体透明
        [UIView animateWithDuration:0.3f animations:^{
            self.navigationBar.alpha = NAV_BAR_ALPHA;
        }];
    } else { // 往下拉
        
        self.navigationBar.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0];
        self.navigationBar.shadowView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0];
        // nav bar 整体透明
        [UIView animateWithDuration:.3f animations:^{
            self.navigationBar.alpha = 0;
        }];
    }
}

#pragma mark - BMKLocationServiceDelegate

/// 获取用户定位坐标
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    NSLog(@"用户的位置更新了");
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    CLLocationCoordinate2D coor;
    coor.latitude = userLocation.location.coordinate.latitude;
    coor.longitude = userLocation.location.coordinate.longitude;
    
    [userDefaults setDouble:userLocation.location.coordinate.latitude forKey:@"positioningLatitude"];
    [userDefaults setDouble:userLocation.location.coordinate.longitude forKey:@"positioningLongitude"];
    
    [self getPoint:coor];
    
    // 关闭定位服务
    [self.locService stopUserLocationService];
}

#pragma mark 逆地理编码类
- (void)initBMKReverseGeoCodeOptionWith:(CLLocationCoordinate2D)coor {
    
    // 初始化检索对象
    self.geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    self.geoCodeSearch.delegate = self;
    self.geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    self.geoCodeSearch.delegate = self;
    
    // 初始化逆地理编码类
    BMKReverseGeoCodeOption *reverseGeoCodeOption = [[BMKReverseGeoCodeOption alloc] init];
    reverseGeoCodeOption.reverseGeoPoint = coor;
    [self.geoCodeSearch reverseGeoCode:reverseGeoCodeOption];
}

#pragma mark 接收反向地理编码结果
- (void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher
                            result:(BMKReverseGeoCodeResult *)result
                         errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:result.address forKey:@"CurrentSite"];
        
        NSArray *cityArray = [result.address componentsSeparatedByString:@"省"];
        
        if (cityArray.count > 1) {
            
            NSArray *cityArray2 = [cityArray[1] componentsSeparatedByString:@"市"];
            
            self.currentCityString = [NSString stringWithFormat:@"%@市",cityArray2[0]];
            [userDefaults setObject:self.currentCityString forKey:@"CurrentCity"];
        }
        else return;
    }
    else {
        
        NSLog(@"抱歉，未找到结果");
    }
}

#pragma mark - XFCarouselViewDelegate

/// 点击轮播广告
- (void)carouselView:(XFCarouselView *)carouselView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击了第 %ld 个", indexPath.row);
    UIViewController *viewController = nil;
    
    HomePageModel *model = self.carouselModelArray[indexPath.row];
    
    if ([model.ObjectType integerValue] == 1) { // 跳转到商品详情
        if ([model.ObjectId integerValue] == 0) return;
        
        GoodsDetailViewController *goodsDetailVc = [[GoodsDetailViewController alloc] init];
        NSString *productIdString = [model.ObjectId stringByReplacingOccurrencesOfString:@"," withString:@""];
        goodsDetailVc.ProductId = [productIdString integerValue];
        viewController = goodsDetailVc;
        

    } else if ([model.ObjectType integerValue] == 2) { // 跳转到分类
        
        FSClassificationViewController *singleClassificationVC = [[FSClassificationViewController alloc] init];
        
        NSString *categoryIdString = [model.ObjectId stringByReplacingOccurrencesOfString:@"," withString:@""];
        singleClassificationVC.isSingle = YES;
        singleClassificationVC.categoryId = [categoryIdString integerValue];
        viewController = singleClassificationVC;
        
    } else { // 跳转到 web
        
        AdWebViewController *ad = [[AdWebViewController alloc] init];
        ad.name = model.Name;
        ad.url = model.Url;
        viewController = ad;
    }
    
    [self.navigationController pushViewController:viewController animated:YES];

}

#pragma mark - FSHomeFourButtonViewDelegate

/// 拼团按钮点击事件
- (void)fourButtonView:(FSHomeFourButtonView *)fourButtonView togetherBuyButtonTouchUpInside:(XFVerticalButton *)sender {
    
    [self.navigationController pushViewController:[FSGroupBuyViewController new] animated:NO];
    NSLog(@"拼团");
}

/// 充值按钮点击事件
- (void)fourButtonView:(FSHomeFourButtonView *)fourButtonView topUpButtonTouchUpInside:(XFVerticalButton *)sender {
    NSLog(@"充值");

    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"UID"];
    
    // 检查用户是否登录，如果未登录，跳转到登录页
    // 如果 uid 为空
    if ([Tools isBlankString:uid]) {
        FSLoginViewController *loginVC = [[FSLoginViewController alloc] init];
        
        FSNavigationController *navController = [[FSNavigationController alloc] initWithRootViewController:loginVC];
        
        [self presentViewController:navController animated:YES completion:nil];
        return ;
    }
    
    [self.navigationController pushViewController:[AmountViewController new] animated:YES];

}

/// 新品按钮点击事件
- (void)fourButtonView:(FSHomeFourButtonView *)fourButtonView newCommodityButtonTouchUpInside:(XFVerticalButton *)sender {
    NSLog(@"新品");
    FSNewCommodityViewController *newCommodityVC = [FSNewCommodityViewController new];
    newCommodityVC.latest = @"1";
    newCommodityVC.specialOffer = @"0";
    newCommodityVC.isNewGoods = YES;
    [self.navigationController pushViewController:newCommodityVC animated:YES];
    
    
}

/// 促销按钮点击事件
- (void)fourButtonView:(FSHomeFourButtonView *)fourButtonView salesPromotionButtonTouchUpInside:(XFVerticalButton *)sender {
    NSLog(@"促销");
    FSNewCommodityViewController *newCommodityVC = [FSNewCommodityViewController new];
    newCommodityVC.latest = @"0";
    newCommodityVC.specialOffer = @"1";
    newCommodityVC.isNewGoods = NO;

    [self.navigationController pushViewController:newCommodityVC animated:YES];
}

#pragma mark - FSCommodityCVCellDelegate

/// 点击了加号
- (void)commodityCVCell:(FSCommodityCVCell *)cell plusButtonTouchUpInside:(UIButton *)sender {
    NSLog(@"点击了加号");

    NSIndexPath *indexPath = [self.mainView indexPathForCell:cell];
    RightGoodsModel *model = self.commodityArray[indexPath.row];

    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"UID"];
    NSString *mid = [[NSUserDefaults standardUserDefaults] objectForKey:@"MID"] ? [[NSUserDefaults standardUserDefaults] objectForKey:@"MID"] : @"2";
    
    __block NSInteger cartNum = [model.CartNum integerValue];
    
    // 检查用户是否登录，如果未登录，跳转到登录页
    // 如果 uid 为空
    if ([Tools isBlankString:uid]) {
        FSLoginViewController *loginVC = [[FSLoginViewController alloc] init];
        
        FSNavigationController *navController = [[FSNavigationController alloc] initWithRootViewController:loginVC];
        
        [self presentViewController:navController animated:YES completion:nil];
        return ;
    }
    
    NSString *totPriceString = @"0";
    NSString *urlString = @"";
    
    if (cartNum == 0) { // 第一次添加到购物车
        
        urlString = [NSString stringWithFormat:ADDCARTURL, model.id, UUID, uid, totPriceString, @"1", mid, @"11"];
        
    } else { // 更新购物车数量
        urlString = [NSString stringWithFormat:UpCart, UUID, mid, model.id,uid,[NSString stringWithFormat:@"%d", cartNum + 1], @"0"];
    }
    [SVProgressHUD show];
    // 发送请求
    [XFNetworking GET:urlString parameters:nil success:^(id responseObject, NSInteger statusCode) {
        [SVProgressHUD dismiss];
        NSDictionary *dataDict = [self dictWithData:responseObject];

        if ([dataDict[@"issuccess"] boolValue]) { // 成功
            
            // 动画
            CGRect rect = [cell.imageView convertRect:cell.imageView.bounds toView:self.view];
            [self initImage:rect withImage:cell.imageView.image];
            
            cartNum++;
            model.CartNum = [NSString stringWithFormat:@"%ld", (long)cartNum];
            //[self.commodityArray replaceObjectAtIndex:indexPath.row withObject:model];
            
            // 更新 UI
            [cell.countLabel setText:model.CartNum];
            
            // 设置 tabbar badge
            NSInteger badgeValue = [[[[[[self tabBarController] tabBar] items] objectAtIndex:2] badgeValue] integerValue];
            badgeValue++;
            [[[[[self tabBarController] tabBar] items] objectAtIndex:2] setBadgeValue:[NSString stringWithFormat:@"%ld", (long)badgeValue]];
            
        }
        
    } failure:^(NSError *error, NSInteger statusCode) {
        [self showInfoWidthError:error];
    }];

}

/// 点击了减号
- (void)commodityCVCell:(FSCommodityCVCell *)cell minusButtonTouchUpInside:(UIButton *)sender {
    NSLog(@"点击了减号");
    NSIndexPath *indexPath = [self.mainView indexPathForCell:cell];
    RightGoodsModel *model = self.commodityArray[indexPath.row];
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"UID"];
    NSString *mid = [[NSUserDefaults standardUserDefaults] objectForKey:@"MID"] ? [[NSUserDefaults standardUserDefaults] objectForKey:@"MID"] : @"2";
    
    __block NSInteger cartNum = [model.CartNum integerValue];
    
    NSString *urlString = @"";
    
    if (cartNum > 1) { // 更新商品的数量
        urlString = [NSString stringWithFormat:UpCart, UUID, mid, model.id, uid,[NSString stringWithFormat:@"%ld", cartNum - 1], @"1"];
    } else { // 从购物车删除商品
        urlString = [NSString stringWithFormat:DelCartUrl,UUID,mid,model.id,uid];
    }
    
    [SVProgressHUD show];
    [XFNetworking GET:urlString parameters:nil success:^(id responseObject, NSInteger statusCode) {
        
        [SVProgressHUD dismiss];
        NSDictionary *dataDict = [self dictWithData:responseObject];
        
        if ([dataDict[@"issuccess"] boolValue]) { // 成功
            
            cartNum--;
            model.CartNum = [NSString stringWithFormat:@"%ld", (long)cartNum];
            
            // 更新 UI
            [cell.countLabel setText:model.CartNum];
            
            // 设置 tabbar badge
            NSInteger badgeValue = [[[[[[self tabBarController] tabBar] items] objectAtIndex:2] badgeValue] integerValue];
            badgeValue--;
            if (badgeValue == 0) {
                [[[[[self tabBarController] tabBar] items] objectAtIndex:2] setBadgeValue:nil];
            } else {
                [[[[[self tabBarController] tabBar] items] objectAtIndex:2] setBadgeValue:[NSString stringWithFormat:@"%ld", (long)badgeValue]];
            }
            
        }
        
    } failure:^(NSError *error, NSInteger statusCode) {
        [self showInfoWidthError:error];
    }];
}


#pragma mark - Custom

- (void)userIsLogined {
    [self startLocation];
}

- (void)userIsLogout {
    [self startLocation];

}

// 导航栏左边按钮点击事件
- (void)leftButtonItemTouchUpInside:(UIButton *)sender {

    // 选择自提点
    SelectSiteViewController *selectSiteVc = [[SelectSiteViewController alloc] init];
    [self.navigationController pushViewController:selectSiteVc animated:YES];
    
}

- (void)titleButtonTouchUpInside:(UIButton *)sender {

    FSSearchViewController *searchVC = [[FSSearchViewController alloc] init];
    
    FSNavigationController *navController = [[FSNavigationController alloc] initWithRootViewController:searchVC];
    navController.navigationBar.tintColor = [UIColor colorDomina];
    [self presentViewController:navController animated:NO completion:nil];

}

- (void)setNavBarAppearance {
    
    // 设置 nav bar 背景完全透明
    self.navigationBar.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0];
    

}

- (void)resetNavBarAppearance {
    
}

#pragma mark 加入购物车动画
- (void)initImage:(CGRect)rect withImage:(UIImage *)image {
    
    UITabBar *tabBar = [[self tabBarController] tabBar];
    
    CGFloat posY = SCREEN_HEIGHT - 49;
    CGFloat itemW = tabBar.width * 0.25;
    
    CGFloat posX = itemW * 2 + 15;
    
    NSLog(@"%@", NSStringFromCGRect(tabBar.frame));
    
    __block UIImageView *cartAnimView = [[UIImageView alloc] initWithFrame:rect];
    cartAnimView.image = image;
    
    [[UIApplication sharedApplication].keyWindow addSubview:cartAnimView];
    //[self.view addSubview:self.cartAnimView];
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1.0;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 0;
    
    //这个是让旋转动画慢于缩放动画执行
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [cartAnimView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    });
    
    [UIView animateWithDuration:1.0 animations:^{
        cartAnimView.frame = CGRectMake(posX + 27.5, posY + 27.5, 0, 0);
    } completion:^(BOOL finished) {
        [cartAnimView removeFromSuperview];
        cartAnimView = nil;
    }];
}


/// 请求首页数据
- (void)getHomeData {
    NSString *urlString = [NSString stringWithFormat:HOMEPAGEURL, @"5"];
    [XFNetworking GET:urlString parameters:nil success:^(id responseObject, NSInteger statusCode) {
        
        [self.carouselModelArray removeAllObjects];
        [self.carouselImageUrlArray removeAllObjects];
        [self.adRlistArray removeAllObjects];

        NSDictionary *dictData = [self dictWithData:responseObject];
        if (!dictData) {
            NSLog(@"解析有误");
            return;
        }
        // 轮播广告
        for (NSDictionary *dict in dictData[@"AdXList"]) {
            
            HomePageModel *model = [HomePageModel modelWithDict:dict];
            [self.carouselImageUrlArray addObject:model.ImgUrl];
            [self.carouselModelArray addObject:model];
        }
        
        // 活动广告
        for (NSDictionary *dict in dictData[@"AdRList"]) {

            HomePageModel *model = [HomePageModel modelWithDict:dict];
            [self.adRlistArray addObject:model];
        }
        
        if (self.carouselModelArray.count) {
            self.navigationBar.hidden = NO;
        }
        
        [self.mainView reloadData];
        [self getCommodityData];
        
    } failure:^(NSError *error, NSInteger statusCode) {
        [self showInfoWidthError:error];
        if (self.normalHeader.isRefreshing) {
            [self.normalHeader endRefreshing];
        }
        [XFWaterWaveView dismissLoading];
    }];
    [self getShoppingCartCount];
    
}


/// 请求商品数据
- (void)getCommodityData {
    
    NSString *urlString = [NSString stringWithFormat:HomePageGoodsList,self.midString,self.uidString];
    
    [XFNetworking GET:urlString parameters:nil success:^(id responseObject, NSInteger statusCode) {
        NSDictionary *dictData = [self dictWithData:responseObject];
        
        [self.commodityArray removeAllObjects];
        NSArray *arr = dictData[@"ClassList"];
        for (NSDictionary *dict in arr) {
            RightGoodsModel *rmodel = [RightGoodsModel modelWithDict:dict];
            [self.commodityArray addObject:rmodel];
        }
        
        if (self.commodityArray.count == 0) {
            [SVProgressHUD showWithStatus:@"该提货点没有商品，请选择其他自提点"];
        }
        
        [self.mainView reloadData];
        if (self.normalHeader.isRefreshing) {
            [self.normalHeader endRefreshing];
        }
        [XFWaterWaveView dismissLoading];
        
    } failure:^(NSError *error, NSInteger statusCode) {
        [XFWaterWaveView dismissLoading];
        [self showInfoWidthError:error];
        if (self.normalHeader.isRefreshing) {
            [self.normalHeader endRefreshing];
        }
    }];
}

/// 获取购物车数量
- (void)getShoppingCartCount {
    
    NSString *urlString = [NSString stringWithFormat:SHOPPINGCARTNUM, UUID, self.uidString, self.midString];
    
    NSLog(@"购物车 = %@",urlString);
    [XFNetworking GET:urlString parameters:nil success:^(id responseObject, NSInteger statusCode) {
        
        NSDictionary *dict = [self dictWithData:responseObject];
        
        if ([dict[@"sum"] integerValue] == 0) {
            [[[[[self tabBarController] tabBar] items] objectAtIndex:2] setBadgeValue:nil];
            return;
        }

        // 设置 tabbar badge
         [[[[[self tabBarController] tabBar] items] objectAtIndex:2] setBadgeValue:[NSString stringWithFormat:@"%@", dict[@"sum"]]];
        
    } failure:^(NSError *error, NSInteger statusCode) {
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@", error.domain]];
        
    }];
}


/// 开始定位
- (void)startLocation {
    
    self.locService = [[BMKLocationService alloc] init];
    self.locService.delegate = self;
    
    // 打开定位服务
    [self.locService startUserLocationService];
}

/// 获取提货点
- (void)getPoint:(CLLocationCoordinate2D)coor {
    
    NSString *urlString = [NSString stringWithFormat:MAPURL,1,1000,coor.latitude,coor.longitude];
    NSLog(@"%@",urlString);
    
    [XFNetworking GET:urlString parameters:nil success:^(id responseObject, NSInteger statusCode) {
        NSDictionary *data = [self dictWithData:responseObject];
        NSLog(@"%@",data);
        
        Map *model = [[Map alloc] init];
        
        [model setValuesForKeysWithDictionary:data[@"list"][0]];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:model.Fendianname forKey:@"merchantsName"];
        [defaults setObject:model.Fendianname forKey:@"Fendianname"];
        [defaults setObject:model.id forKey:@"merchantsID"];
        [defaults setObject:model.mid forKey:@"MID"];
        [defaults setObject:model.addr forKey:@"merchantsAddress"];
        [defaults setObject:model.picktime forKey:@"merchantsTime"];
        [defaults setObject:model.pickJuli forKey:@"distance"];
        [defaults setObject:model.Distance forKey:@"Distance"];
        [defaults setObject:model.DistancePrice forKey:@"DistancePrice"];
        [defaults setBool:[model.IsDistribution boolValue] forKey:@"IsDistribution"];
        [defaults setObject:model.xPoint forKey:@"xPoint"];
        [defaults setObject:model.yPoint forKey:@"yPoint"];
        [defaults setObject:model.fullPrice forKey:@"fullPrice"];
        
        NSLog(@"%@",model.Distance);
        
        self.midString = [Tools isBlankString:[defaults objectForKey:@"MID"]] ? @"5" : [defaults objectForKey:@"MID"];
        self.uidString = [Tools isBlankString:[defaults objectForKey:@"UID"]] ? @"0" : [defaults objectForKey:@"UID"];
        self.storeIdString = [defaults objectForKey:@"merchantsID"];
        
        [self.navigationBar.leftButton setTitle:[[[NSUserDefaults standardUserDefaults] objectForKey:@"merchantsName"] substringWithRange:NSMakeRange(0, 2)] forState:UIControlStateNormal];
        
        [self getHomeData];
        
    } failure:^(NSError *error, NSInteger statusCode) {
        [self showInfoWidthError:error];
        if (self.normalHeader.isRefreshing) {
            [self.normalHeader endRefreshing];
        }
        [XFWaterWaveView dismissLoading];
        
    }];
}

/// 下拉刷新时调用
- (void)refreshData:(MJRefreshNormalHeader *)sender {

    // 开始定位
    [self startLocation];
}

#pragma mark - LazyLoad

- (FSHomeNavigationBar *)navigationBar {
    if (!_navigationBar) {
        _navigationBar = [[FSHomeNavigationBar alloc] init];
        [_navigationBar.leftButton addTarget:self action:@selector(leftButtonItemTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [_navigationBar.titleButton addTarget:self action:@selector(titleButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        _navigationBar.hidden = YES;
    }
    return _navigationBar;
}

- (FSHomeView *)mainView {
    if (!_mainView) {
        _mainView = [[FSHomeView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _mainView.dataSource = self;
        _mainView.delegate = self;
        _mainView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
        _mainView.backgroundColor = [UIColor colorWithRGBHex:0xededed];
        _mainView.showsVerticalScrollIndicator = NO;
        // 添加下拉刷新
        //_mainView.mj_header = self.refreshHeader;
//        _mainView.refreshControl = self.refreshControl;
        
        _mainView.mj_header = self.normalHeader;
    }
    return _mainView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    }
    return _flowLayout;
}

- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        _indicatorView.backgroundColor = [UIColor whiteColor];
        _indicatorView.color = [UIColor darkGrayColor];

    }
    return _indicatorView;
}

- (NSMutableArray *)carouselImageUrlArray {
    if (!_carouselImageUrlArray) {
        _carouselImageUrlArray = [NSMutableArray array];
    }
    return _carouselImageUrlArray;
}

- (NSMutableArray *)carouselModelArray {
    if (!_carouselModelArray) {
        _carouselModelArray = [NSMutableArray array];
    }
    return _carouselModelArray;
}

- (NSMutableArray *)adRlistArray {
    if (!_adRlistArray) {
        _adRlistArray = [NSMutableArray array];
    }
    return _adRlistArray;
}

- (NSMutableArray *)commodityArray {
    if (!_commodityArray) {
        _commodityArray = [NSMutableArray array];
    }
    return _commodityArray;
}


- (MJRefreshNormalHeader *)normalHeader {
    if (!_normalHeader) {
        _normalHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData:)];
        _normalHeader.lastUpdatedTimeLabel.hidden = YES;
    }
    return _normalHeader;
}



/*
- (FSDancingBananaHeader *)refreshHeader {
    if (!_refreshHeader) {
        _refreshHeader = [FSDancingBananaHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData:)];
        _refreshHeader.lastUpdatedTimeLabel.hidden = YES;
        _refreshHeader.stateLabel.hidden = YES;
    }
    return _refreshHeader;
}
*/

/*
- (UIRefreshControl *)refreshControl {
    if (!_refreshControl) {
        _refreshControl = [UIRefreshControl new];
        //_refreshControl.tintColor = [UIColor colorDomina];
        [_refreshControl addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventValueChanged];
    }
    return _refreshControl;
}
*/


@end
