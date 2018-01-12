//
//  MapLocationViewController.m
//  XLKP
//
//  Created by Facebook on 2017/11/28.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "MapLocationViewController.h"

@interface MapLocationViewController ()<MKMapViewDelegate>
@property(nonatomic,strong)  MKMapView *mapView;
@end

@implementation MapLocationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mapView];
    [self setMapPosition:self.location];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setMapPosition:(CLLocation *)location
{
    [self.mapView setCenterCoordinate:location.coordinate animated:YES];
    CLLocationCoordinate2D center = location.coordinate;
    MKCoordinateSpan span = MKCoordinateSpanMake(0.009310,0.007812);
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    
    [self.mapView  setRegion:region animated:YES];
    self.mapView .rotateEnabled    = YES;
    self.mapView .showsUserLocation = NO;
    
    MyAnnoation *annotation=[[MyAnnoation alloc]init];
    annotation.coordinate = location.coordinate;
    [self.mapView addAnnotation:annotation];
}

- (MKMapView *)mapView
{
    if (!_mapView)
    {
        _mapView = [[MKMapView alloc]initWithFrame:self.view.bounds];
        _mapView.delegate = self;
    }
    
    return _mapView;
}

@end






@implementation MyAnnoation
@end

