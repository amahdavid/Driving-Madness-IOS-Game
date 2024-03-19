//
//  GameViewController.swift
//  Solo Mission Game Tutorial
//
//  Created by David Chika Amah-Nnachi on 2024-03-18.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as! SKView? {
            let scene = GameScene(size: CGSize(width: 1536, height: 2048))
            view.showsFPS = true
            view.showsNodeCount = true
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
