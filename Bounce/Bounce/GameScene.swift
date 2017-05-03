//
//  GameScene.swift
//  Bounce
//
//  Created by WSU Senior Design on 4/11/17.
//  Copyright © 2017 Jordan Little. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var redBallNode: SKSpriteNode!
    var greenBallNode: SKSpriteNode!
    var startStopLabel: SKLabelNode!
    var bounceSoundAction: SKAction!
    var breakSoundAction: SKAction!
    var audioPlayer: AVAudioPlayer!
    
    var viewController: UIViewController?
    var soundEffects: Bool = true
    var backgroundMusic: Bool = true
    
    override func didMove(to view: SKView) {
        UserDefaults.standard.set(soundEffects, forKey: "Sound Effects")
        UserDefaults.standard.set(backgroundMusic, forKey: "Background Music")
        
        let screenPhysicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        screenPhysicsBody.friction = 0.0
        screenPhysicsBody.categoryBitMask = 0b100
        screenPhysicsBody.contactTestBitMask = 0b001

        self.physicsBody = screenPhysicsBody
        
        redBallNode = self.childNode(withName: "redBall") as! SKSpriteNode
        startStopLabel = self.childNode(withName: "startStop") as! SKLabelNode
        
        self.physicsWorld.contactDelegate = self
        self.initGame()
    }
    
    
    
    func initGame() {
        bounceSoundAction = SKAction.playSoundFileNamed("bounce.mp3", waitForCompletion: false)
        breakSoundAction = SKAction.playSoundFileNamed("glassbreak.mp3", waitForCompletion: false)
        
        let musicURL = Bundle.main.url(forResource: "WSU-Fight-Song.mp3", withExtension: nil)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: musicURL!)
        } catch {
            print ("Error accessing music")
        }
        audioPlayer.volume = 0.10
        audioPlayer.numberOfLoops = -1
        
        self.pauseGame()

    }
    
    func startGame() {
        self.isPaused = false
        self.startStopLabel.text = "Stop"
        redBallNode.physicsBody?.applyImpulse(CGVector(dx: 150.0, dy: 100.0))
        
        backgroundMusic = UserDefaults.standard.bool(forKey: "Background Music")
        
        if (backgroundMusic) {
            audioPlayer.play()
        }
    }
    
    func pauseGame() {
        self.isPaused = true
        self.startStopLabel.text = "Start"
        backgroundMusic = UserDefaults.standard.bool(forKey: "Background Music")
        
        if (backgroundMusic) {
            audioPlayer.pause()
        }
    }
    
    func addGreenBall(point: CGPoint) {
        greenBallNode = SKSpriteNode(imageNamed: "greenball.png")
        greenBallNode.name = "greenBall"
        greenBallNode.physicsBody = SKPhysicsBody(circleOfRadius: 50.0)
        greenBallNode.physicsBody?.affectedByGravity = false
        greenBallNode.physicsBody?.friction = 0.0
        greenBallNode.physicsBody?.restitution = 1.0
        greenBallNode.physicsBody?.linearDamping = 0.0
        greenBallNode.physicsBody?.categoryBitMask = 0b010
        greenBallNode.physicsBody?.collisionBitMask = 0b11110
        greenBallNode.physicsBody?.contactTestBitMask = 0b001
        greenBallNode.position = point
        self.addChild(greenBallNode)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        soundEffects = UserDefaults.standard.bool(forKey: "Sound Effects")
        
        if contact.bodyA.node?.name == "greenBall" {
            contact.bodyA.node?.removeFromParent()
            if (soundEffects) {
                run(breakSoundAction)
                print("break Played")
            }
        }
        else if contact.bodyB.node?.name == "greenBall" {
            contact.bodyB.node?.removeFromParent()
            if (soundEffects) {
                print("break Played")
                run(breakSoundAction)
            }
        }
        else {
            if (soundEffects) {
                run(bounceSoundAction)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let point = t.location(in: self)
            let nodeArray = nodes(at: point)
            
            if (nodeArray.count == 0) {
                addGreenBall(point: point)
            }
            
            for node in nodeArray {
                if (node.name == "settings") {
                    self.viewController?.performSegue(withIdentifier: "toSettings", sender: self)
                }
                    
                else if (node.name == "startStop") {
                    if (self.isPaused) {
                        self.startGame()
                    } else {
                        self.pauseGame()
                    }
                }
            }
        }
    }
    
    
    
    @IBAction func unwindFromSettings (sender: UIStoryboardSegue) {
        self.viewController?.navigationController?.popViewController(animated: true)
    }

    /*
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    */
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
