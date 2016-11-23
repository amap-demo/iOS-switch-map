# iOS-switch-map
根据地图中心点是否在国内切换高德地图和苹果地图


### 前述

- [高德官方网站申请key](http://id.amap.com/?ref=http%3A%2F%2Fapi.amap.com%2Fkey%2F).
- 阅读[参考手册](http://api.amap.com/Public/reference/iOS%20API%20v2_3D/).
- 工程基于iOS 3D地图SDK实现
- 运行demo请先执行pod install --repo-update 安装依赖库，完成后打开.xcworkspace 文件

### 使用方法
地图显示后，拖动地图，当中心点离开国内时，提示切换到苹果地图显示。

### 核心实现

- 在地图delegate内判断中心点是否在国内
```
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"是否切换到苹果地图显示" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }
    } else {
        if(AMapDataAvailableForCoordinate(self.appleMapview.centerCoordinate)) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"是否切换到高德地图显示" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }
}
```
- 切换地图，主要同步region、中心点经纬度、旋转角度。目前不支持camera视角同步
```
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
```
