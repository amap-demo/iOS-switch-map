//
//  ViewController.m
//  iOS-switch-map
//
//  Created by shaobin on 16/11/23.
//  Copyright © 2016年 autonavi. All rights reserved.
//

#import "ViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <MapKit/MapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

@interface ViewController () <MAMapViewDelegate, MKMapViewDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) MAMapView *gaodeMapview;
@property (nonatomic, strong) MKMapView *appleMapview;

@property (nonatomic, assign) BOOL isSwitching;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.gaodeMapview = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.gaodeMapview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.gaodeMapview.delegate = self;
    [self.view addSubview:self.gaodeMapview];
    [self.gaodeMapview setZoomLevel:4.5 animated:NO];
    
    self.appleMapview = [[MKMapView alloc] initWithFrame:self.view.bounds];
    self.appleMapview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.appleMapview.delegate = self;
    [self.view addSubview:self.appleMapview];
    [self.appleMapview setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 地图delegate
- (void)mapView:(UIView *)mapView regionDidChangeAnimated:(BOOL)animated {
    if(mapView.isHidden) {
        return;
    }
    
    if(self.isSwitching) {
        self.isSwitching = NO;
        return;
    }
    
    if([mapView isKindOfClass:[MAMapView class]]) {
        if(!AMapDataAvailableForCoordinate(self.gaodeMapview.centerCoordinate)) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"是否切换到苹果地图显示" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }
    } else {
        if(AMapDataAvailableForCoordinate(self.appleMapview.centerCoordinate)) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"是否切换到高德地图显示" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }
}

#pragma mark - alertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1) {
        [self performSwitching];
    }
}

/**
 执行切换
 */
- (void)performSwitching {
    self.isSwitching = YES;
    
    [self.gaodeMapview setHidden:!self.gaodeMapview.isHidden];
    [self.appleMapview setHidden:!self.appleMapview.isHidden];
    
    if(!self.gaodeMapview.isHidden) {
        MACoordinateRegion region = [self MARegionForMKRegion:self.appleMapview.region];
        [self.gaodeMapview setRegion:region];
        
        self.gaodeMapview.centerCoordinate = self.appleMapview.centerCoordinate;
        
        [self.gaodeMapview setRotationDegree:self.appleMapview.camera.heading];
    } else {
        MKCoordinateRegion region = [self MKRegionForMARegion:self.gaodeMapview.region];
        [self.appleMapview setRegion:region];
        
        self.appleMapview.centerCoordinate = self.gaodeMapview.centerCoordinate;
        
        [self.appleMapview.camera setHeading:self.gaodeMapview.rotationDegree];
    }
}

/**
 高德地图转苹果地图
 */
- (MKCoordinateRegion)MKRegionForMARegion:(MACoordinateRegion)maRegion {
    MKCoordinateRegion mkRegion = MKCoordinateRegionMake(maRegion.center, MKCoordinateSpanMake(maRegion.span.latitudeDelta, maRegion.span.longitudeDelta));
    
    return mkRegion;
}

/**
 苹果地图转高德地图
 */
- (MACoordinateRegion)MARegionForMKRegion:(MKCoordinateRegion)mkRegion {
    MACoordinateRegion maRegion = MACoordinateRegionMake(mkRegion.center, MACoordinateSpanMake(mkRegion.span.latitudeDelta, mkRegion.span.longitudeDelta));
    
    
    if(maRegion.center.latitude + maRegion.span.latitudeDelta / 2 > 90) {
        maRegion.span.latitudeDelta = (90.0 - maRegion.center.latitude) / 2;
    }
    if(maRegion.center.longitude + maRegion.span.longitudeDelta / 2 > 180) {
        maRegion.span.longitudeDelta = (180.0 - maRegion.center.longitude) / 2;
    }
    
    return maRegion;
}

@end
