//
//  MyAnnotation.swift
//  SearchMapKit
//
//  Created by xly on 15-7-27.
//  Copyright (c) 2015年 Lily. All rights reserved.
//

import UIKit
import MapKit

class MyAnnotation: NSObject ,MKAnnotation{
    //大头针
    var coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var title:String!
    
    init(coordinate:CLLocationCoordinate2D,title:String){
        self.coordinate = coordinate
        self.title = title
    }
}
