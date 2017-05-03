//
//  PUAnnotation.swift
//  Pick-up
//
//  Created by Jordan Little on 4/22/17.
//  Copyright © 2017 Jordan Little. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class PUAnnotation: NSObject, MKAnnotation, NSCoding {
    var title: String?
    var subtitle: String?
    var puDate: Date?
    var puInformation: String?
    var coordinate: CLLocationCoordinate2D
    var rating: Int!
    var subscribed: Bool!
    
    override init () {
        self.title = nil
        self.subtitle = nil
        self.puDate = nil
        self.puInformation = nil
        self.coordinate = CLLocationCoordinate2D.init()
        self.rating = 0
        self.subscribed = false
    }
    
    init(title: String, subtitle: String, date: Date, info: String, coords: CLLocationCoordinate2D, rating: Int, subscribed: Bool) {
        self.title = title
        self.subtitle = subtitle
        self.puDate = date
        self.puInformation = info
        self.coordinate = coords
        self.rating = rating
        self.subscribed = subscribed
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let title = aDecoder.decodeObject(forKey: "title") as! String
        let subtitle = aDecoder.decodeObject(forKey: "subtitle") as! String
        let date = aDecoder.decodeObject(forKey: "date") as! Date
        let info = aDecoder.decodeObject(forKey: "info") as! String
        let latitudeText = aDecoder.decodeObject(forKey: "latitude") as! String
        let longitudeText = aDecoder.decodeObject(forKey: "longitude") as! String
        let rating = aDecoder.decodeObject(forKey: "rating") as! Int
        let subscribed = aDecoder.decodeObject(forKey: "subscribed") as! Bool
        
        let latitude: CLLocationDegrees = Double(latitudeText)!
        let longitude: CLLocationDegrees = Double(longitudeText)!
        
        let coords = CLLocationCoordinate2DMake(latitude, longitude)
        
        self.init(title: title, subtitle: subtitle, date: date, info: info, coords: coords, rating: rating, subscribed: subscribed)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "title")
        aCoder.encode(subtitle, forKey: "subtitle")
        aCoder.encode(puDate, forKey: "date")
        aCoder.encode(puInformation, forKey: "info")
        
        let latitudeText:String = "\(coordinate.latitude)"
        let longitudeText:String = "\(coordinate.longitude)"
        
        aCoder.encode(latitudeText, forKey: "latitude")
        aCoder.encode(longitudeText, forKey: "longitude")
        aCoder.encode(rating, forKey: "rating")
        aCoder.encode(subscribed, forKey: "subscribed")
    }
    
}
