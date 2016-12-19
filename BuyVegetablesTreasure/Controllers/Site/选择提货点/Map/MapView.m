//
//  MapView.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/4/12.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "MapView.h"

@interface MapView ()<MAMapViewDelegate,AMapSearchDelegate>

@property (nonatomic, copy) MAMapView *mapView;

@end

@implementation MapView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self initMap];
    }
    
    return self;
}

#pragma mark - 初始化
#pragma mark 初始化地图
- (void)initMap {
    
    [MAMapServices sharedServices].apiKey = @"144d673b9f9bb31c00e499a7809cd5b7";
    _mapView = [[MAMapView alloc] initWithFrame:self.frame];
    _mapView.delegate = self;
    _mapView.zoomLevel = 16;
    _mapView.showsUserLocation = YES;
    [_mapView setUserTrackingMode:MAUserTrackingModeNone animated:YES];
    
    [self addSubview:_mapView];
    
    CLLocationCoordinate2D coor;
    coor.latitude = 22.546999;
    coor.longitude = 114.085945;
    [self initPointAnnotationWithCoor:coor];
}

#pragma mark 创建高德大头针
- (void)initPointAnnotationWithCoor:(CLLocationCoordinate2D)coor {
    
    [AMapSearchServices sharedServices].apiKey = @"144d673b9f9bb31c00e499a7809cd5b7";
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = coor;
    [_mapView addAnnotation:pointAnnotation];
}

#pragma mark 大头针代理方法
- (MAAnnotationView *)mapView:(MAMapView *)mapView
            viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil) {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout = YES;
        annotationView.animatesDrop = YES;
        annotationView.draggable = YES;
        annotationView.pinColor = MAPinAnnotationColorPurple;
        
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 0, 100, 100);
        view.backgroundColor = [UIColor redColor];
        annotationView.leftCalloutAccessoryView = view;
        return annotationView;
    }
    return nil;
}

@end
