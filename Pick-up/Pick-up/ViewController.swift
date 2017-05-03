//
//  ViewController.swift
//  Pick-up
//
//  Created by Jordan Little on 4/22/17.
//  Copyright © 2017 Jordan Little. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var defaults = UserDefaults.standard
    var currentAnnotations: [PUAnnotation] = []
    var subscribedEvents: [PUAnnotation] = []

    @IBAction func createFindTapped(_ sender: Any) {
        performSegue(withIdentifier: "toMap", sender: self)
    }
    
    @IBAction func manageEventsTapped(_ sender: Any) {
        performSegue(withIdentifier: "toSubscribedEvents", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let decodedc = defaults.object(forKey: "currentAnnotations") {
            let decodeds = defaults.object(forKey: "subscribedEvents") as! Data
            currentAnnotations = NSKeyedUnarchiver.unarchiveObject(with: decodedc as! Data) as! [PUAnnotation]
            subscribedEvents = NSKeyedUnarchiver.unarchiveObject(with: decodeds) as! [PUAnnotation]
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toMap") {
            let ViewController = segue.destination as! CreateFindViewController
            ViewController.subscribedEvents = self.subscribedEvents
            ViewController.currentAnnotations = self.currentAnnotations
        }
            
        else if (segue.identifier == "toSubscribedEvents") {
            let ViewController = segue.destination as! SubscribedTableViewController
            ViewController.subscribedEvents = self.subscribedEvents
            ViewController.currentAnnotations = self.currentAnnotations
        }
    }
    
    @IBAction func unwindFromMap (sender: UIStoryboardSegue) {
        let ViewController = sender.source as! CreateFindViewController
        self.subscribedEvents = ViewController.subscribedEvents
        self.currentAnnotations = ViewController.currentAnnotations
    }
    
    @IBAction func unwindFromSubscribedEvents (sender: UIStoryboardSegue) {
        let ViewController = sender.source as! SubscribedTableViewController
        self.subscribedEvents = ViewController.subscribedEvents
        self.currentAnnotations = ViewController.currentAnnotations
    }

}

