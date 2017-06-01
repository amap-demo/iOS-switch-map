# iOS-switch-map
根据地图中心点是否在国内切换高德地图和苹果地图


### 前述

- [高德官网申请Key](http://lbs.amap.com/dev/#/).
- 阅读[开发指南](http://lbs.amap.com/api/ios-sdk/summary/).
- 工程基于iOS 3D地图SDK实现
- 运行demo请先执行pod install --repo-update 安装依赖库，完成后打开.xcworkspace 文件

### 使用方法
地图显示后，拖动地图，当中心点离开国内时，提示切换到苹果地图显示。

### 核心类/接口
| 类    | 接口  | 说明   | 版本  |
| -----|:-----:|:-----:|:-----:|
| ViewController | - (void)mapView:(UIView *)mapView regionDidChangeAnimated:(BOOL)animated; | 响应地图区域变化，判断中心点 | n/a |
| ViewController | - (void)performSwitching; | 执行切换 | n/a |

### 核心实现
#### objective-c
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
#### swift
- 判断中心点是否在国内
```
func handleMapviewRegionChange(mapView : UIView) {
        if(mapView.isHidden) {
            return
        }
        
        if(self.isSwitching) {
            self.isSwitching = false
            return
        }
        
        if(mapView.isKind(of: MAMapView.self)) {
            if(!AMapDataAvailableForCoordinate(self.gaodeMapView.centerCoordinate)) {
                let alert = UIAlertView.init(title: "", message: "是否切换到苹果地图显示", delegate: self, cancelButtonTitle: "取消", otherButtonTitles:"确定")
                alert.show()
            }
        } else {
            if(AMapDataAvailableForCoordinate(self.appleMapView.centerCoordinate)) {
                let alert = UIAlertView.init(title: "", message: "是否切换到高德地图显示", delegate: self, cancelButtonTitle: "取消", otherButtonTitles:"确定")
                alert.show()
            }
        }
    }
```
- 执行切换
```
    func performSwitching() {
        self.isSwitching = true
        
        self.gaodeMapView.isHidden = !self.gaodeMapView.isHidden
        self.appleMapView.isHidden = !self.appleMapView.isHidden
        
        if(!self.gaodeMapView.isHidden) {
            let region = self.MARegionForMKRegion(mkRegion: self.appleMapView.region)
            self.gaodeMapView.region = region
            
            self.gaodeMapView.centerCoordinate = self.appleMapView.centerCoordinate
            self.gaodeMapView.rotationDegree = CGFloat(self.appleMapView.camera.heading)
        } else {
            let region = self.MKRegionForMARegion(maRegion: self.gaodeMapView.region)
            
            self.appleMapView.region = region
            self.appleMapView.centerCoordinate = self.gaodeMapView.centerCoordinate
            self.appleMapView.camera.heading = CLLocationDirection(self.gaodeMapView.rotationDegree)
        }
    }
```
