//
//  MainMenuScene.swift
//  Solo Mission Game Tutorial
//
//  Created by David Chika Amah-Nnachi on 2024-03-21.
//

import Foundation
import SpriteKit

class MainMenuScene: SKScene {
    let createrLabel = SKLabelNode(fontNamed: "THE BOLD FONT")
    let gameLabelOne = SKLabelNode(fontNamed: "THE BOLD FONT")
    let gameLabelTwo = SKLabelNode(fontNamed: "THE BOLD FONT")
    let startGameLabel = SKLabelNode(fontNamed: "THE BOLD FONT")
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "RoadBackGround")
        background.size = self.size
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = 0
        self.addChild(background)
        
        createrLabel.text = "David Chika's"
        createrLabel.fontSize = 60
        createrLabel.fontColor = SKColor.white
        createrLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.78)
        createrLabel.zPosition = 1
        self.addChild(createrLabel)
        
        gameLabelOne.text = "Driving"
        gameLabelOne.fontSize = 200
        gameLabelOne.fontColor = SKColor.white
        gameLabelOne.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.7)
        gameLabelOne.zPosition = 1
        self.addChild(gameLabelOne)
        
        gameLabelTwo.text = "Madness"
        gameLabelTwo.fontSize = 200
        gameLabelTwo.fontColor = SKColor.white
        gameLabelTwo.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.62)
        gameLabelTwo.zPosition = 1
        self.addChild(gameLabelTwo)
        
        startGameLabel.text = "Start Game!"
        startGameLabel.fontSize = 100
        startGameLabel.fontColor = SKColor.white
        startGameLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.4)
        startGameLabel.zPosition = 1
        self.addChild(startGameLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let pointOfTouch = touch.location(in: self)
            
            if startGameLabel.contains(pointOfTouch) {
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
        }
    }
}
