//
//  BDMapViewController.m
//  BuyVegetablesTreasure
//
//  Created by sc on 15/11/5.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import "BDMapViewController.h"
#import "SelectSiteViewController.h"
#import <BaiduMapAPI_Search/BMKPoiSearchType.h>

@interface BDMapViewController ()<UITableViewDataSource,UITableViewDelegate,MAMapViewDelegate,AMapSearchDelegate>{
    
#if 0
    
    BMKMapView *_mapView;
    BMKLocationService *_locService;
    BMKPointAnnotation *_annotation;
    BMKPoiSearch *_searcher;
    BMKGeoCodeSearch *_geoCodeSearch;
    
#else
    
    MAMapView *_mapView;
    AMapSearchAPI *_search;
    AMapSearchAPI *_poiAroundSearch;
    AMapSearchAPI *_reGeocodeSearch;
    
#endif
    
    __block float longitude;
    __block float latitude;
    
    BOOL isBack;
    BOOL isFirstPositioning;
    
    NSMutableArray *_mapArray;
    NSMutableArray *_bdMapArray;
    NSMutableArray *_addrArray;
    
    UITextField *_mapTextField;
    UITableView *_tableView;
    
    NSString *address;
    NSString *_currentCity;
    MBProgressHUD * hud;
}
@end

@implementation BDMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [UIFactory createBackBBIWithTarget:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(ok)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithHexString:@"0xF48B17"];
    
    // 搜索文本框
    _mapTextField = [[UITextField alloc] init];
    _mapTextField.frame = CGRectMake(0, 0, SCREEN_WIDTH - SCREEN_WIDTH / 4, 30);
    _mapTextField.borderStyle = UITextBorderStyleRoundedRect;
    _mapTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.navigationItem.titleView = _mapTextField;
    
    _addrArray = [NSMutableArray array];
    _mapArray = [NSMutableArray array];
    _bdMapArray = [NSMutableArray array];
    
    // 创建地图
    [self initMapView];
    [self initTableView];
}

-(void)viewWillDisappear:(BOOL)animated{
    
#if 1
    
#else
    
    _mapView.delegate = nil;
    _searcher.delegate = nil;
    _geoCodeSearch.delegate = nil;
    [_mapView viewWillDisappear];
    
#endif
}

#pragma mark - 事件处理
#pragma mark 返回按钮
- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 跳转到指定地址
- (void)getCoorWithAddress:(NSString *)addressString {
    
    CLGeocoder *myGeocoder = [[CLGeocoder alloc] init];
    
    [myGeocoder geocodeAddressString:addressString completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if ([placemarks count] > 0 && error == nil) {
            
            CLPlacemark *firstPlacemark = [placemarks objectAtIndex:0];
            NSLog(@"Longitude = %f", firstPlacemark.location.coordinate.longitude);
            NSLog(@"Latitude = %f", firstPlacemark.location.coordinate.latitude);
            
            CLLocationCoordinate2D coor = firstPlacemark.location.coordinate;
            
            if (!isBack) {
                
                [self initPointAnnotationWithCoor:coor];
            }
            else {
                
                // 百度坐标
                NSDictionary* testdic = BMKConvertBaiduCoorFrom(coor,BMK_COORDTYPE_COMMON);
                
                // 转换GPS坐标至百度坐标(加密后的坐标)
                testdic = BMKConvertBaiduCoorFrom(coor,BMK_COORDTYPE_GPS);
                
                // 解密加密后的坐标字典
                CLLocationCoordinate2D baiduCoor = BMKCoorDictionaryDecode(testdic);//转换后的百度坐标
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setDouble:baiduCoor.latitude forKey:@"latitude"];
                [defaults setDouble:baiduCoor.longitude forKey:@"longitude"];
                
                NSLog(@"baiduCoor.latitude == %f",baiduCoor.latitude);
                NSLog(@"baiduCoor.longitude == %f",baiduCoor.longitude);
                
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else if ([placemarks count] == 0 && error == nil) {
            
            NSLog(@"Found no placemarks.");
        }
        else if (error != nil) {
            
            NSLog(@"An error occurred = %@", error);
        }
    }];
}

#pragma mark 确定按钮
- (void)ok {
    
    _mapView.zoomLevel = 16;
    
    [_tableView reloadData];
    
    [_mapTextField resignFirstResponder];
    
    if (!isBack) {
        address = _mapTextField.text;
    }
    
    if ([Tools isBlankString:address]) {
        [Tools myHud:@"请输入关键字" inView:self.view];
        return;
    }
    
    [self initGeocodeSearchWithAddress:address];
    
#if 0
    
    CLGeocoder *myGeocoder = [[CLGeocoder alloc] init];
    
    __weak typeof(self)WeakSelf = self;
    [myGeocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if ([placemarks count] > 0 && error == nil)
        {
            
            CLPlacemark *firstPlacemark = [placemarks objectAtIndex:0];
            NSLog(@"Longitude = %f", firstPlacemark.location.coordinate.longitude);
            NSLog(@"Latitude = %f", firstPlacemark.location.coordinate.latitude);
            
            CLLocationCoordinate2D coor;
            coor.longitude = firstPlacemark.location.coordinate.longitude;
            coor.latitude = firstPlacemark.location.coordinate.latitude;
            
            longitude = firstPlacemark.location.coordinate.longitude;
            latitude = firstPlacemark.location.coordinate.latitude;
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setDouble:longitude forKey:@"longitude"];
            [userDefaults setDouble:latitude forKey:@"latitude"];
            
            if (!isBack) {
                [WeakSelf goCoordinatesWithCoor:coor];
            }
            else {
                [WeakSelf.navigationController popViewControllerAnimated:YES];
            }
        }
    }];
    
#endif
}

#pragma mark - 控件初始化
- (void)initTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - SCREEN_HEIGHT / 2 - 64, SCREEN_WIDTH, SCREEN_HEIGHT / 2)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 70;
    _tableView.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MapCell"];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _mapArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MapCell"];
    
    if (_mapArray.count > 0)
    {
        AMapPOI *mapModel = _mapArray[indexPath.section];
        
        cell.textLabel.text = mapModel.name;
        cell.detailTextLabel.text = mapModel.address;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (![Tools isBlankString:self.currentCity]) {
        [[NSUserDefaults standardUserDefaults] setObject:self.currentCity forKey:@"CurrentCity"];
        NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentCity"]);
    }
    
    AMapPOI *mapModel = _mapArray[indexPath.section];
    address = mapModel.address;
    
    AMapGeoPoint *mapGeoPoint = mapModel.location;
    [[NSUserDefaults standardUserDefaults] setDouble:mapGeoPoint.latitude forKey:@"positioningLatitude"];
    [[NSUserDefaults standardUserDefaults] setDouble:mapGeoPoint.longitude forKey:@"positioningLongitude"];
    
    if (_isAddSite == YES) {
        
        _userSiteBlock(mapModel);
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        
        isBack = YES;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:mapModel.name forKey:@"topAdree"];
        
        [self ok];
    }
}

#pragma mark 创建高德地图
- (void)initMapView {
    
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT / 2)];
    _mapView.delegate = self;

    [self.view addSubview:_mapView];
    
    if (_isCurrentSite) {
    
        _mapView.zoomLevel = 16;
        _mapView.showsUserLocation = YES;
        [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    }
    else {
        
        CLLocationCoordinate2D coor;
        coor.latitude = 31.230416;
        coor.longitude = 121.473701;
        
        if ([self.currentCity isEqualToString:@"深圳"]) {
            
            coor.latitude = 22.546999;
            coor.longitude = 114.085945;
        }
        
        _mapView.zoomLevel = 14.5;
        [self initPointAnnotationWithCoor:coor];
        [self initPOIAroundSearchWithCoor:coor];
    }
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth / 2 - 8.5, CGRectGetHeight(_mapView.frame) / 2 - 25, 19, 25)];
    iconImageView.image = [UIImage imageNamed:@"收货-地标"];
    [self.view addSubview:iconImageView];
}

- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
    CGPoint point;
    point.x = ScreenWidth / 2;
    point.y = CGRectGetHeight(_mapView.frame) / 2;
    CLLocationCoordinate2D coor = [_mapView convertPoint:point toCoordinateFromView:_mapView];
    [self initPOIAroundSearchWithCoor:coor];
}

#pragma mark 创建高德大头针
- (void)initPointAnnotationWithCoor:(CLLocationCoordinate2D)coor {
    [self initPOIAroundSearchWithCoor:coor];
    _mapView.centerCoordinate = coor;
}

#pragma mark 周边查询
- (void)initPOIAroundSearchWithCoor:(CLLocationCoordinate2D)coor {
    
    _poiAroundSearch = [[AMapSearchAPI alloc] init];
    _poiAroundSearch.delegate = self;
    
    //构造AMapPOIAroundSearchRequest对象，设置周边请求参数
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:coor.latitude longitude:coor.longitude];
    request.requireExtension = YES;
    
    //发起周边搜索
    [_poiAroundSearch AMapPOIAroundSearch: request];
}

#pragma mark 创建正向地理编码
-(void)initGeocodeSearchWithAddress:(NSString *)addressString {
    
    //初始化检索对象
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    
    // 构造AMapGeocodeSearchRequest对象
    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
    geo.city = [NSString stringWithFormat:@"%@市",self.currentCity];
    geo.address = addressString;
    
    //发起正向地理编码
    [_search AMapGeocodeSearch:geo];
}

#pragma mark 创建逆地理编码
- (void)initReGeocodeSearchRequestWithCoor:(CLLocationCoordinate2D)coor {
        
    //初始化检索对象
    _reGeocodeSearch = [[AMapSearchAPI alloc] init];
    _reGeocodeSearch.delegate = self;
    
    //构造AMapReGeocodeSearchRequest对象
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location = [AMapGeoPoint locationWithLatitude:coor.latitude longitude:coor.longitude];
    regeo.radius = 10000;
    
    //发起逆地理编码
    [_reGeocodeSearch AMapReGoecodeSearch:regeo];
}

#pragma mark 定位
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation) {
        
        CLLocationCoordinate2D coor;
        coor.latitude = userLocation.coordinate.latitude;
        coor.longitude = userLocation.coordinate.longitude;
        
        [self initReGeocodeSearchRequestWithCoor:coor];
        
        if (!isFirstPositioning) {
            
            isFirstPositioning = YES;
            [self initPOIAroundSearchWithCoor:coor];
        }
    }
}

#pragma mark 大头针代理方法
- (MAAnnotationView *)mapView:(MAMapView *)mapView
            viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES;
        annotationView.animatesDrop = YES;
        annotationView.draggable = YES;
        annotationView.pinColor = MAPinAnnotationColorPurple;
        return annotationView;
    }
    return nil;
}

#pragma mark 正向地理编码代理方法
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request
                   response:(AMapGeocodeSearchResponse *)response
{
    if (response.geocodes.count > 0) {
        
        AMapGeocode *geocode = response.geocodes[0];
        AMapGeoPoint *geoPoint = geocode.location;
        
        CLLocationCoordinate2D coor;
        coor.latitude = geoPoint.latitude;
        coor.longitude = geoPoint.longitude;
        
        NSLog(@"latitude == %f",coor.latitude);
        NSLog(@"longitude = %f",coor.longitude);
        
        if (!isBack) {
            
            [self initPointAnnotationWithCoor:coor];
        }
        else {
            
            // 百度坐标
            NSDictionary* testdic = BMKConvertBaiduCoorFrom(coor,BMK_COORDTYPE_COMMON);
            
            // 转换GPS坐标至百度坐标(加密后的坐标)
            testdic = BMKConvertBaiduCoorFrom(coor,BMK_COORDTYPE_GPS);
            
            // 解密加密后的坐标字典
            CLLocationCoordinate2D baiduCoor = BMKCoorDictionaryDecode(testdic);//转换后的百度坐标
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setDouble:baiduCoor.latitude forKey:@"positioningLatitude"];
            [defaults setDouble:baiduCoor.longitude forKey:@"positioningLongitude"];
            
            NSLog(@"baiduCoor.latitude == %f",baiduCoor.latitude);
            NSLog(@"baiduCoor.longitude == %f",baiduCoor.longitude);
            
            [self.navigationController pushViewController:[SelectSiteViewController new] animated:YES];
        }
    }
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request
                     response:(AMapReGeocodeSearchResponse *)response
{
    
    if (response.regeocode != nil) {
        
        NSArray *cityArray = [response.regeocode.formattedAddress componentsSeparatedByString:@"省"];
        NSArray *cityArray2 = [cityArray[1] componentsSeparatedByString:@"市"];
        _cityString = [NSString stringWithFormat:@"%@市",cityArray2[0]];
        NSLog(@"%@",_cityString);
    }
}

#pragma mark POI搜索对应的回调函数
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    [_mapArray removeAllObjects];
    
    if (response.pois.count == 0){
        
//        [Tools myHud:@"请核实地址是否正确" inView:self.view];
        return;
    }
    
    [_mapArray removeAllObjects];
    [_bdMapArray removeAllObjects];
    
    [_mapArray addObjectsFromArray:response.pois];
    [_tableView reloadData];
}


@end
