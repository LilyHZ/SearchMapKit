//
//  ViewController.swift
//  SearchMapKit
//
//  Created by xly on 15-7-26.
//  Copyright (c) 2015年 Lily. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var btnHotel: UIButton!
    @IBOutlet weak var btnHospital: UIButton!
    @IBOutlet weak var btnSM: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    var flag = true
    
    //初始化位置 经/纬度
    let initLocation = CLLocation(latitude: 24.4604090000, longitude: 118.0876380000)
    //设置搜索范围为4公里
    let searchRadius:CLLocationDistance = 4000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //对三个按钮的设置
        self.btnHospital.alpha = 0
        self.btnHotel.alpha = 0
        self.btnSM.alpha = 0
        self.btnHospital.layer.cornerRadius = 10
        self.btnHotel.layer.cornerRadius = 10
        self.btnSM.layer.cornerRadius = 10
        
        //首先让按钮的透明度为0
        self.btnMenu.alpha = 0
        
        //按钮在1s的时间里透明度为1，旋转90°
        UIView.animateWithDuration(1, delay: 1, options: UIViewAnimationOptions.CurveEaseInOut, animations: {() ->Void in
            self.btnMenu.alpha = 1
            self.btnMenu.transform = CGAffineTransformMakeRotation(0.25 * 3.1415927)//旋转角度90/360*3.1415927
            }, completion: nil)
        
        //创建一个区域 以xx经纬度为中心，以xx半径显示
        let region = MKCoordinateRegionMakeWithDistance(initLocation.coordinate, searchRadius, searchRadius)
        //设置显示
        mapView.setRegion(region, animated: true)
        
        searchMap("place")
    }

    @IBAction func btnMenuClick(sender: UIButton) {
        
        if flag {
            UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                self.btnMenu.transform = CGAffineTransformMakeRotation(0)//回到原来的位置
                
                //对三个按钮的设置
                self.btnHospital.alpha = 0.8
                self.btnHospital.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(1.5, 1.5), CGAffineTransformMakeTranslation(-80, -25))//先放大1.5倍，位移再偏移
                
                self.btnHotel.alpha = 0.8
                self.btnHotel.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(1.5, 1.5), CGAffineTransformMakeTranslation(0, -50))//先放大1.5倍，位移再偏移
                
                self.btnSM.alpha = 0.8
                self.btnSM.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(1.5, 1.5), CGAffineTransformMakeTranslation(80, -25))//先放大1.5倍，位移再偏移
                
                }, completion: nil)
            flag = false
        }else{
            reset()
            
        }
        
    }
    
    @IBAction func btnHotelClick(sender: AnyObject) {
        mapView.removeAnnotations(mapView.annotations)
        searchMap("hotel")
        reset()
    }
    
    @IBAction func btnHospitalClick(sender: AnyObject) {
        mapView.removeAnnotations(mapView.annotations)
        searchMap("hospital")
        reset()
    }
    
    @IBAction func btnSMClick(sender: AnyObject) {
        mapView.removeAnnotations(mapView.annotations)
        searchMap("supermarket")
        reset()
    }
    
    
    /**按钮复原*/
    func reset(){
        flag = true
        UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.btnMenu.transform = CGAffineTransformMakeRotation(0.25 * 3.1415927)//回到原来的位置
            
            //对三个按钮的设置
            self.btnHospital.alpha = 0
            self.btnHospital.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(1, 1), CGAffineTransformMakeTranslation(0, 0))
            
            self.btnHotel.alpha = 0
            self.btnHotel.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(1, 1), CGAffineTransformMakeTranslation(0, 0))
            
            self.btnSM.alpha = 0
            self.btnSM.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(1, 1), CGAffineTransformMakeTranslation(0, 0))
            
            }, completion: nil)
    }
    
    //增加兴趣点
    func addLocation(title:String,latitude:CLLocationDegrees,longtitude:CLLocationDegrees){
        //保存兴趣位置
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
        let annotation = MyAnnotation(coordinate: location, title: title)
        mapView.addAnnotation(annotation)
    }
    
//    //搜索
//    func searchMap(place:String){
//        //首先创建搜索请求
//        let request = MKLocalSearchRequest()
//        //搜索的语言是place
//        request.naturalLanguageQuery = place
//        
//        //设置缩放大小
//        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
//        //搜索区域
//        request.region  = MKCoordinateRegion(center: initLocation.coordinate, span: span)
//        //启动搜索并把返回结果保存在数组中
//        let search = MKLocalSearch(request: request)
//        search.startWithCompletionHandler { (response:MKLocalSearchResponse!,error:NSError!) ->Void in
//            for item in response.mapItems as [MKMapItem]{
//                self.addLocation(item.name, latitude: item.placemark.location.coordinate.latitude, longtitude: item.placemark.location.coordinate.longitude)
//            }
//        }
//        
//    }
    
    //搜索
    func searchMap(place:String){
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = place
        //搜索当前区域
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        request.region = MKCoordinateRegion(center:initLocation.coordinate, span: span)
        //启动搜索,并且把返回结果保存在数组中
        let search = MKLocalSearch(request: request)
        search.startWithCompletionHandler { (response:MKLocalSearchResponse!, error:NSError!) -> Void in
            for item in response.mapItems as [MKMapItem]{
                self.addLocation(item.name, latitude: item.placemark.location.coordinate.latitude, longtitude:  item.placemark.location.coordinate.longitude)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

