//
//  SettingsViewController.swift
//  Bounce
//
//  Created by WSU Senior Design on 4/18/17.
//  Copyright © 2017 Jordan Little. All rights reserved.
//

import UIKit
import GameplayKit
import AVFoundation

class SettingsViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var soundEffectsSwitch: UISwitch!
    @IBOutlet weak var backgroundSwitch: UISwitch!
    
    var audioPlayer: AVAudioPlayer!
    var isPaused: Bool!
    
    
    @IBAction func SESwiped(_ sender: Any) {
        let SE: Bool = soundEffectsSwitch.isOn
        UserDefaults.standard.set(SE, forKey: "Sound Effects")
    }
    @IBAction func BMSwiped(_ sender: Any) {
        let BM: Bool = backgroundSwitch.isOn
        UserDefaults.standard.set(BM, forKey: "Background Music")
        
        if (!BM) {
            self.audioPlayer.stop()
        } else if (!isPaused && BM){
            self.audioPlayer.play()
        }
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        performSegue(withIdentifier: "unwindFromSettings", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (UserDefaults.standard.bool(forKey: "Sound Effects") == true) {
            soundEffectsSwitch.isOn = true
        }
        else {
            soundEffectsSwitch.isOn = false
        }
        
        if (UserDefaults.standard.bool(forKey: "Background Music") == true) {
            backgroundSwitch.isOn = true
        } else {
            backgroundSwitch.isOn = false
        }
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
