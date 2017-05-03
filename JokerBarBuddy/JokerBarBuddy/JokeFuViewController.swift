//
//  JokeFuViewController.swift
//  JokerBarBuddy
//
//  Created by Jordan Little on 3/28/17.
//  Copyright © 2017 Washington State University. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

class JokeFuViewController: UIViewController {

    @IBOutlet weak var passFailOutlet: UILabel!
    @IBOutlet weak var startOutlet: UILabel!
    @IBOutlet weak var finishOutlet: UILabel!
    @IBOutlet weak var tryAgainOutlet: UIButton!
    
    var firstPoint: CGPoint!
    var lastPoint: CGPoint!
    var isTestEnded: Bool!
    var points = [UIView]()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            firstPoint = touch.location(in: self.view)
            lastPoint = touch.location(in: self.view)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (!isTestEnded) {
            if let touch = touches.first{
                let currentPoint = touch.location(in: self.view)
                let dotView = UIView(frame: CGRect(x: currentPoint.x, y: currentPoint.y, width: 5.0, height: 5.0))
                dotView.backgroundColor = UIColor.blue
                self.view.addSubview(dotView)
                if (abs(currentPoint.y - firstPoint.y) > 10) {
                    passFailOutlet.text = "Fail"
                }
                lastPoint = currentPoint
                points.append(dotView)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?){
        isTestEnded = true
        if (self.startOutlet.frame.contains(firstPoint) && self.finishOutlet.frame.contains(lastPoint)) {
            if (passFailOutlet.text != "Fail") {
                passFailOutlet.text = "Pass"
            }
        } else {
            passFailOutlet.text = "Fail"
        }
        
        tryAgainOutlet.isHidden = false
    }


    @IBAction func tryAgainPressed(_ sender: Any) {
        for p in points {
            p.removeFromSuperview()
        }
        isTestEnded = false
        tryAgainOutlet.isHidden = true
        passFailOutlet.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isTestEnded = false
        tryAgainOutlet.isHidden = true
        passFailOutlet.text = ""
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
