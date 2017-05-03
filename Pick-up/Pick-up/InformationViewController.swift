//
//  InformationViewController.swift
//  Pick-up
//
//  Created by Jordan Little on 4/27/17.
//  Copyright © 2017 Jordan Little. All rights reserved.
//

import UIKit
import CoreData

class InformationViewController: UIViewController {
    
    var defaults = UserDefaults.standard
    var puEvent: PUAnnotation!
    var currentAnnotations: [PUAnnotation] = []
    var subscribedEvents: [PUAnnotation] = []
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventLoc: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventInfo: UILabel!
    
    @IBOutlet weak var ratingOne: UIImageView!
    @IBOutlet weak var ratingTwo: UIImageView!
    @IBOutlet weak var ratingThree: UIImageView!
    @IBOutlet weak var ratingFour: UIImageView!
    @IBOutlet weak var ratingFive: UIImageView!
    
    @IBOutlet weak var subscribeOutlet: UIButton!
    
    @IBAction func subscribeTapped(_ sender: Any) {
        if (puEvent.subscribed) {
            subscribedEvents.remove(at: subscribedEvents.index(of: puEvent)!)
            puEvent.subscribed = false
            subscribeOutlet.setTitle("Subscribe to Event", for: .normal)
        } else {
            subscribedEvents.append(puEvent)
            puEvent.subscribed = true
            subscribeOutlet.setTitle("Unsubscribe from Event", for: .normal)
        }
        
        let encodedDataSub: Data = NSKeyedArchiver.archivedData(withRootObject: subscribedEvents)
        defaults.set(encodedDataSub, forKey: "subscribedEvents")
        defaults.synchronize()
 
    }
    
    func showRating() {
        
        switch puEvent.rating {
        case 0:
            ratingOne.image = #imageLiteral(resourceName: "x.png")
            ratingTwo.image = #imageLiteral(resourceName: "x.png")
            ratingThree.image = #imageLiteral(resourceName: "x.png")
            ratingFour.image = #imageLiteral(resourceName: "x.png")
            ratingFive.image = #imageLiteral(resourceName: "x.png")
            
        case 1:
            ratingOne.image = #imageLiteral(resourceName: "ok.png")
            ratingTwo.image = #imageLiteral(resourceName: "x.png")
            ratingThree.image = #imageLiteral(resourceName: "x.png")
            ratingFour.image = #imageLiteral(resourceName: "x.png")
            ratingFive.image = #imageLiteral(resourceName: "x.png")
            
        case 2:
            ratingOne.image = #imageLiteral(resourceName: "ok.png")
            ratingTwo.image = #imageLiteral(resourceName: "ok.png")
            ratingThree.image = #imageLiteral(resourceName: "x.png")
            ratingFour.image = #imageLiteral(resourceName: "x.png")
            ratingFive.image = #imageLiteral(resourceName: "x.png")
            
        case 3:
            ratingOne.image = #imageLiteral(resourceName: "ok.png")
            ratingTwo.image = #imageLiteral(resourceName: "ok.png")
            ratingThree.image = #imageLiteral(resourceName: "ok.png")
            ratingFour.image = #imageLiteral(resourceName: "x.png")
            ratingFive.image = #imageLiteral(resourceName: "x.png")
            
        case 4:
            ratingOne.image = #imageLiteral(resourceName: "ok.png")
            ratingTwo.image = #imageLiteral(resourceName: "ok.png")
            ratingThree.image = #imageLiteral(resourceName: "ok.png")
            ratingFour.image = #imageLiteral(resourceName: "ok.png")
            ratingFive.image = #imageLiteral(resourceName: "x.png")
            
        case 5:
            ratingOne.image = #imageLiteral(resourceName: "ok.png")
            ratingTwo.image = #imageLiteral(resourceName: "ok.png")
            ratingThree.image = #imageLiteral(resourceName: "ok.png")
            ratingFour.image = #imageLiteral(resourceName: "ok.png")
            ratingFive.image = #imageLiteral(resourceName: "ok.png")
            
        default:
            break
        }
    }
    
    // Just included this so that rating a zero is possible after rating it once
    func imageOneTapped() {
        if (puEvent.rating == 1) {
            puEvent.rating = 0
        } else {
            puEvent.rating = 1
        }
        showRating()
    }
    func imageTwoTapped() {
        puEvent.rating = 2
        showRating()
    }
    func imageThreeTapped() {
        puEvent.rating = 3
        showRating()
    }
    func imageFourTapped() {
        puEvent.rating = 4
        showRating()
    }
    func imageFiveTapped() {
        puEvent.rating = 5
        showRating()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizerOne = UITapGestureRecognizer(target: self, action: #selector(imageOneTapped))
        let tapGestureRecognizerTwo = UITapGestureRecognizer(target: self, action: #selector(imageTwoTapped))
        let tapGestureRecognizerThree = UITapGestureRecognizer(target: self, action: #selector(imageThreeTapped))
        let tapGestureRecognizerFour = UITapGestureRecognizer(target: self, action: #selector(imageFourTapped))
        let tapGestureRecognizerFive = UITapGestureRecognizer(target: self, action: #selector(imageFiveTapped))
        
        ratingOne.isUserInteractionEnabled = true
        ratingOne.addGestureRecognizer(tapGestureRecognizerOne)
        ratingTwo.isUserInteractionEnabled = true
        ratingTwo.addGestureRecognizer(tapGestureRecognizerTwo)
        ratingThree.isUserInteractionEnabled = true
        ratingThree.addGestureRecognizer(tapGestureRecognizerThree)
        ratingFour.isUserInteractionEnabled = true
        ratingFour.addGestureRecognizer(tapGestureRecognizerFour)
        ratingFive.isUserInteractionEnabled = true
        ratingFive.addGestureRecognizer(tapGestureRecognizerFive)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        eventTitle.text = puEvent.title
        eventLoc.text = puEvent.subtitle
        let date = puEvent.puDate
        let dateFormater = DateFormatter()
        dateFormater.dateStyle = DateFormatter.Style.full
        var dateString: String = ""
        if (date != nil) {
            dateString = dateFormater.string(from: date!)
        }
        if (puEvent.subscribed) {
            subscribeOutlet.setTitle("Unsubscribe from Event", for: .normal)
        } else {
            subscribeOutlet.setTitle("Subscribe to Event", for: .normal)
        }
        
        eventDate.text = dateString
        eventInfo.text = puEvent.puInformation
        
        showRating()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let rootVC = self.navigationController!.topViewController
        if (rootVC?.isKind(of: CreateFindViewController.self))! {
            performSegue(withIdentifier: "unwindFromInformation", sender: self)
        }
        else if (rootVC?.isKind(of: SubscribedTableViewController.self))! {
            performSegue(withIdentifier: "unwindFromInformation", sender: self)
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
