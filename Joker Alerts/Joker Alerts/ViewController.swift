//
//  ViewController.swift
//  Joker Alerts
//
//  Created by Jordan Little on 2/28/17.
//  Copyright © 2017 Washington State University. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    var jokes: [Joke] = []
    var notificationsOkay = false
    var punchline = ""
    
    @IBOutlet weak var messageOutlet: UILabel!
    @IBOutlet weak var scheduleJokeOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initializeJokes()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func scheduleJokeTapped(_ sender: UIButton) {
        if (self.notificationsOkay){
            messageOutlet.text = "Joke Scheduled"
            self.scheduleNotification()
        }
        else {
            messageOutlet.text = "Notifications Disabled"
        }
    }
    
    func initializeJokes() {
        let joke1 = Joke(first: "Why did", second: "the scarecrow", third: "get a promotion?", ans: "Because he was outstanding in his field!")
        let joke2 = Joke(first: "Why is there", second: "no gambling", third: "in Africa?", ans: "There are too many cheetahs!")
        let joke3 = Joke(first: "What did", second: "the 0 say", third: "to the 8?", ans: "Hey man, nice belt.")
        //let joke4 = Joke()
        
        self.jokes.append(joke1)
        self.jokes.append(joke2)
        self.jokes.append(joke3)
        //self.jokes.append(joke4)
    }
    
    func chooseJoke() -> String {
        let randomJokeIndex = Int(arc4random_uniform(UInt32(self.jokes.count)))
        self.punchline = jokes[randomJokeIndex].answerLine
        return jokes[randomJokeIndex].firstLine + " " + jokes[randomJokeIndex].secondLine + " " + jokes[randomJokeIndex].thirdLine
    }
    
    func handleNotification (_ response: UNNotificationResponse) {
        // create the alert
        let alert = UIAlertController(title: "Answer", message: self.punchline, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        let okay = UIAlertAction(title: "Okay", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.messageOutlet.text = ""
        }
        
        alert.addAction(okay)
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Here's a joke! Tap for answer."
        content.body = chooseJoke()
        // Configure trigger for 5 seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0,
                                                        repeats: false)
        // Create request
        let request = UNNotificationRequest(identifier: "NowPlusFive",
                                            content: content, trigger: trigger)
        // Schedule request
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        }
    }
    
    func hanldeOkay(){
        messageOutlet.text = ""
    }
}

