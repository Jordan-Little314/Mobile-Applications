//
//  CreateFindViewController.swift
//  Pick-up
//
//  Created by Jordan Little on 4/22/17.
//  Copyright © 2017 Jordan Little. All rights reserved.
//

import Foundation
import UIKit
import UIKit
import MapKit
import CoreLocation
import CoreData

class CreateFindViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate, UISearchBarDelegate {

    var defaults = UserDefaults.standard
    var locationManager : CLLocationManager!
    var pinPlaced: Bool = false
    var currentAnnotations: [PUAnnotation] = []
    var subscribedEvents: [PUAnnotation] = []
    var tappedAnnotation: PUAnnotation!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var eventTitle: UITextField!
    @IBOutlet weak var eventLoc: UITextField!
    @IBOutlet weak var eventDate: UITextField!
    @IBOutlet weak var eventInfo: UITextField!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.searchBar.endEditing(true)
    }
    
    func longPress(gestureRecognizer: UILongPressGestureRecognizer) {
        if (eventTitle.text == "" || eventLoc.text == "" || eventDate.text == "" || eventInfo.text == "") {
            pinPlaced = true
        }
        
        if (!pinPlaced && gestureRecognizer.state == UIGestureRecognizerState.began) {
            let touchPoint = gestureRecognizer.location(in: mapView)
            let newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            let dateFormater = DateFormatter()
            dateFormater.dateStyle = DateFormatter.Style.short
            let date = dateFormater.date(from: eventDate.text!)
            let annotation = PUAnnotation(title: eventTitle.text!, subtitle: eventLoc.text!, date: date!, info: eventInfo.text!, coords: newCoordinates, rating: 0, subscribed: false)
            
            currentAnnotations.append(annotation)
            mapView.addAnnotation(annotation)
            
            let encodedDataCur: Data = NSKeyedArchiver.archivedData(withRootObject: currentAnnotations)
            defaults.set(encodedDataCur, forKey: "currentAnnotations")
            defaults.synchronize()
            
            pinPlaced = true
        }
        
        else if (gestureRecognizer.state == UIGestureRecognizerState.ended) {
            pinPlaced = false
            eventTitle.text = ""
            eventLoc.text = ""
            eventDate.text = ""
            eventInfo.text = ""
        }
    }
    
    // When user taps on the disclosure button you can perform a segue to navigate to another view controller
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView{
            print(view.annotation?.title! as Any) // annotation's title
            print(view.annotation?.subtitle! as Any) // annotation's subttitle
            
            //Perform a segue here to navigate to another viewcontroller
            // On tapping the disclosure button you will get here
            tappedAnnotation = view.annotation as! PUAnnotation
            self.performSegue(withIdentifier: "toInformation", sender: self)
        }
    }
    
    // Here we add disclosure button inside annotation window
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            //return nil
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
        }
        
        let button = UIButton(type: UIButtonType.detailDisclosure) as UIButton // button with info sign in it
        
        pinView?.rightCalloutAccessoryView = button
        
        return pinView
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if (searchBar.text == "") {
            for annotation in mapView.annotations {
                mapView.view(for: annotation)?.isHidden = false
            }
        } else {
            for annotation in currentAnnotations {
                let title = annotation.title!
                let description = annotation.puInformation
                let date = annotation.puDate
                let dateFormater = DateFormatter()
                dateFormater.dateStyle = DateFormatter.Style.short
                var dateString: String = ""
                if (date != nil) {
                    dateString = dateFormater.string(from: date!)
                }
                let location = annotation.subtitle
                
                if ((title.range(of: searchBar.text!)) != nil || (description?.range(of: searchBar.text!)) != nil || (dateString.range(of: searchBar.text!)) != nil || (location?.range(of: searchBar.text!)) != nil) {
                    mapView.view(for: annotation)?.isHidden = false
                } else {
                    mapView.view(for: annotation)?.isHidden = true
                }
            }
        }
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.enablesReturnKeyAutomatically = false
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if (searchBar.text == "") {
            for annotation in mapView.annotations {
                mapView.view(for: annotation)?.isHidden = false
            }
        } else {
            for annotation in currentAnnotations {
                let title = annotation.title!
                let description = annotation.puInformation
                let date = annotation.puDate
                let dateFormater = DateFormatter()
                dateFormater.dateStyle = DateFormatter.Style.short
                var dateString: String = ""
                if (date != nil) {
                    dateString = dateFormater.string(from: date!)
                }
                let location = annotation.subtitle
                
                if ((title.range(of: searchBar.text!)) != nil || (description?.range(of: searchBar.text!)) != nil || (dateString.range(of: searchBar.text!)) != nil || (location?.range(of: searchBar.text!)) != nil) {
                    mapView.view(for: annotation)?.isHidden = false
                } else {
                    mapView.view(for: annotation)?.isHidden = true
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toInformation") {
            let ViewController = segue.destination as! InformationViewController
            ViewController.puEvent = tappedAnnotation
            ViewController.subscribedEvents = self.subscribedEvents
            ViewController.currentAnnotations = self.currentAnnotations
        }
    }
    
    @IBAction func unwindFromInformation (sender: UIStoryboardSegue) {
        let ViewController = sender.source as! InformationViewController
        self.subscribedEvents = ViewController.subscribedEvents
        self.currentAnnotations = ViewController.currentAnnotations
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.mapView.delegate = self
        
        mapView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        mapView.mapType = MKMapType.standard
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action:(#selector(longPress)))
        gestureRecognizer.minimumPressDuration = 2.0
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
        
        searchBar.delegate = self
        
        self.initializeLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        for annotation in currentAnnotations {
            mapView.addAnnotation(annotation)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let rootVC = self.navigationController!.topViewController
        if (rootVC?.isKind(of: ViewController.self))! {
            performSegue(withIdentifier: "unwindFromMap", sender: self)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
