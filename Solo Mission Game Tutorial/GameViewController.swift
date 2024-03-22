//
//  GameViewController.swift
//  Solo Mission Game Tutorial
//
//  Created by David Chika Amah-Nnachi on 2024-03-18.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

class GameViewController: UIViewController {
    
    var backingAudio = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let filePath = Bundle.main.path(forResource: "gameTheme", ofType: "wav")
        let audioUrl = URL(fileURLWithPath: filePath!)
        
        do {
            backingAudio = try AVAudioPlayer(contentsOf: audioUrl)
        } 
        catch {
            return print("Cannot find audio")
        }
        
        backingAudio.numberOfLoops = -1
        backingAudio.volume = 1
        backingAudio.play()
        
        if let view = self.view as! SKView? {
            let scene = MainMenuScene(size: CGSize(width: 1536, height: 2048))
            view.showsFPS = false
            view.showsNodeCount = false
            view.ignoresSiblingOrder = true
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            // Present the scene
            view.presentScene(scene)
            }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
