//
//  FindBarViewController.swift
//  JokerBarBuddy
//
//  Created by Jordan Little on 3/28/17.
//  Copyright © 2017 Washington State University. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class FindBarViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate
{
    var locationManager : CLLocationManager!
    
    @IBOutlet weak var mapView: MKMapView!
    
    func initializeLocation() { // called from start up method
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            self.startLocation()
        case .denied, .restricted:
            print("location not authorized")
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    // Delegate method called whenever location authorization status changes
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus)
    {
        if ((status == .authorizedAlways) || (status == .authorizedWhenInUse)) {
            self.startLocation()
        } else {
            self.stopLocation()
        }
    }
    func startLocation () {
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    func stopLocation () {
        locationManager.stopUpdatingLocation()
    }
    
    // Delegate method called whenever location changes
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last
        if let latitude = location?.coordinate.latitude {
            print("Latitude: \(latitude)")
        }
        if let longitude = location?.coordinate.longitude {
            print("Longitude: \(longitude)")
        }
    }
    
    @IBAction func showBarsTapped(_ sender: Any) {
        self.barSearch()
    }
    
    
    func barSearch()
    {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = "bar"
        request.region = self.mapView.region
        let search = MKLocalSearch(request: request)
        search.start(completionHandler: {(response, error) in
            if error != nil
            {
                print("Error occured in search: \(error!.localizedDescription)")
            }
            else if response!.mapItems.count == 0
            {
                print("No matches found")
            }
            else
            {
                print("\(response!.mapItems.count) matches found");
                self.mapView.removeAnnotations(self.mapView.annotations);
                for item in response!.mapItems
                {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.name
                    self.mapView.addAnnotation(annotation)
                }
            }
        })
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        mapView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        mapView.mapType = MKMapType.standard
        
        self.initializeLocation()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
