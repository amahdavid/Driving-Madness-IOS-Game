//
//  GameScene.swift
//  Solo Mission Game Tutorial
//
//  Created by David Chika Amah-Nnachi on 2024-03-18.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    // sets the player image
    let player = SKSpriteNode(imageNamed: "playerShip")
    
    // this function runs as soon as the scene loads up
    override func didMove(to view: SKView) {
        // sets the background image
        let background = SKSpriteNode(imageNamed: "background")
        // sets the background size to the scene size
        background.size = self.size
        // gets the center point of the scene
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        // layering of the bakground, we want this to be at the bottom of our game
        // the lower the number the further back the object is
        background.zPosition = 0
        self.addChild(background)
        
        // how big the ship will be, 1 being normal, 2 being huge
        player.setScale(1)
        player.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.2)
        player.zPosition = 2
        self.addChild(player)
    }
    
    func fireBullet() {
        let bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.setScale(1)
        bullet.position = player.position
        bullet.zPosition = 1
        self.addChild(bullet)
        
        let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1)
        let deleteBullet = SKAction.removeFromParent()
        // sets the sequence of how things should happen
        // once you shot the bullet delete it after
        let bulletSequence = SKAction.sequence([moveBullet, deleteBullet])
        bullet.run(bulletSequence)
    }
    
    // when we touch the screen, fire a bullet
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        fireBullet()
    }
}
