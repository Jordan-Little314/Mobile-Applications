//
//  GameViewController.swift
//  Bounce
//
//  Created by WSU Senior Design on 4/11/17.
//  Copyright © 2017 Jordan Little. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var scene: GameScene!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            
            scene = GameScene(fileNamed: "GameScene")
            if scene != nil {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                scene.viewController = self
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
            }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func unwindFromSettings (sender: UIStoryboardSegue) {
        let sViewController = sender.source as! SettingsViewController
        let scene = GameScene(fileNamed: "GameScene")
        scene?.audioPlayer = sViewController.audioPlayer
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toSettings") {
            let ViewController = segue.destination as! SettingsViewController
            ViewController.isPaused = scene.isPaused
            ViewController.audioPlayer = scene.audioPlayer
        }
    }
}
