//
//  ViewController.swift
//  iOS-switch-map-swift
//
//  Created by shaobin on 16/12/16.
//  Copyright © 2016年 autonavi. All rights reserved.
//

import UIKit

class MKMapViewDelegateHandler:NSObject, MKMapViewDelegate {
    weak var realHandler: ViewController!
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        realHandler.handleMapviewRegionChange(mapView: mapView)
    }
    
    override init() {
        super.init()
    }
}

class ViewController: UIViewController, MAMapViewDelegate, UIAlertViewDelegate{
    
    var gaodeMapView : MAMapView! = nil
    var appleMapView : MKMapView! = nil
    var isSwitching : Bool = false
    var mkMapviewDelegateHandler : MKMapViewDelegateHandler! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        mkMapviewDelegateHandler = MKMapViewDelegateHandler.init()
        mkMapviewDelegateHandler.realHandler = self
        
        self.gaodeMapView = MAMapView.init(frame: self.view.bounds)
        self.gaodeMapView.delegate = self
        self.view.addSubview(self.gaodeMapView)
        
        self.appleMapView = MKMapView.init(frame: self.view.bounds)
        self.appleMapView.delegate = mkMapviewDelegateHandler
        self.view.addSubview(self.appleMapView)
        self.appleMapView.isHidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    
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
    
    //MARK: -地图delegate
    func mapView(_ mapView: MAMapView, regionDidChangeAnimated animated: Bool) {
        self.handleMapviewRegionChange(mapView: mapView)
    }
 
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
    
    func MARegionForMKRegion(mkRegion:MKCoordinateRegion) -> MACoordinateRegion {
        var maRegion: MACoordinateRegion! = MACoordinateRegionMake(mkRegion.center, MACoordinateSpanMake(mkRegion.span.latitudeDelta, mkRegion.span.longitudeDelta))
        
        if(maRegion.center.latitude + maRegion.span.latitudeDelta / 2 > 90) {
            maRegion.span.latitudeDelta = (90.0 - maRegion.center.latitude) / 2;
        }
        if(maRegion.center.longitude + maRegion.span.longitudeDelta / 2 > 180) {
            maRegion.span.longitudeDelta = (180.0 - maRegion.center.longitude) / 2;
        }

        
        return maRegion;
    }
    
    func MKRegionForMARegion(maRegion:MACoordinateRegion) -> MKCoordinateRegion {
        let mkRegion:MKCoordinateRegion! = MKCoordinateRegionMake(maRegion.center, MKCoordinateSpanMake(maRegion.span.latitudeDelta, maRegion.span.longitudeDelta));
        
        return mkRegion;
    }
    
    //MARK: -alertview delegate
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if(buttonIndex == 1) {
            self.performSwitching()
        }
    }
}

