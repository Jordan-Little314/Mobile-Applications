//
//  ViewController.swift
//  JokerBarBuddy
//
//  Created by Jordan Little on 3/28/17.
//  Copyright © 2017 Washington State University. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var lineOneOutlet: UILabel!
    @IBOutlet weak var lineTwoOutlet: UILabel!
    @IBOutlet weak var lineThreeOutlet: UILabel!
    @IBOutlet weak var answerOutlet: UILabel!
    
    var url: URL!
    var dataTask: URLSessionDataTask!
    var loadedJoke: Joke!
    
    
    
    func handleResponse (data: Data?, response: URLResponse?, error: Error?) {
        if (error != nil) {
            print("error: \(error!.localizedDescription)")
        } else {
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            if statusCode != 200 {
                let msg = HTTPURLResponse.localizedString(forStatusCode: statusCode)
                print("HTTP \(statusCode) error: \(msg)")
            } else {
                // respsonse okay, do something with data
                // response okay, do something with data
                if let jsonObj = try? JSONSerialization.jsonObject(with: data!,
                                                                   options: []) {
                    let jsonDict = jsonObj as! [String: AnyObject]
                    let jokeJSON = jsonDict["joke"] as! [String: AnyObject]
                
                    loadedJoke = Joke(first: (jokeJSON["line1"] as?String)!, second: (jokeJSON["line2"] as?String)!, third: (jokeJSON["line3"] as?String)!, ans: (jokeJSON["answer"] as?String)!)
                    
                } else {
                    print("error: invalid JSON data")
                }
            }
        }
    }

    @IBAction func getJokePressed(_ sender: Any) {
        self.viewDidLoad()
        
        lineOneOutlet.text = loadedJoke.firstLine
        lineTwoOutlet.text = loadedJoke.secondLine
        lineThreeOutlet.text = loadedJoke.thirdLine
        answerOutlet.text = loadedJoke.answerLine
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        lineOneOutlet.text = ""
        lineTwoOutlet.text = ""
        lineThreeOutlet.text = ""
        answerOutlet.text = ""
        
        url = URL(string: "http://www.eecs.wsu.edu/~holder/courses/MAD/hw9/getjoke.php")!
        dataTask = URLSession.shared.dataTask(with: url!, completionHandler: handleResponse)
        dataTask.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

