//
//  GameOverScene.swift
//  Solo Mission Game Tutorial
//
//  Created by David Chika Amah-Nnachi on 2024-03-20.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    let gameOverLabel = SKLabelNode(fontNamed: "THE BOLD FONT")
    let scoreLabel = SKLabelNode(fontNamed: "THE BOLD FONT")
    let highScoreLabel = SKLabelNode(fontNamed: "THE BOLD FONT")
    let restartLabel = SKLabelNode(fontNamed: "THE BOLD FONT")
    let defaults = UserDefaults()

    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "RoadBackGround")
        background.size = self.size
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = 0
        self.addChild(background)
        
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontSize = 175
        gameOverLabel.fontColor = SKColor.white
        gameOverLabel.position = CGPoint(x: self.size.width * 0.50, y: self.size.height * 0.7)
        gameOverLabel.zPosition = 1
        self.addChild(gameOverLabel)
        
        scoreLabel.text = "Score: \(gameScore)"
        scoreLabel.fontSize = 125
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.55)
        scoreLabel.zPosition = 1
        self.addChild(scoreLabel)
        
        var highScore = defaults.integer(forKey: "highScoreSaved")
        if gameScore > highScore {
            highScore = gameScore
            defaults.set(highScore, forKey: "highScoreSaved")
        }
        highScoreLabel.text = "High Score: \(highScore)"
        highScoreLabel.fontSize = 125
        highScoreLabel.fontColor = SKColor.white
        highScoreLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.45)
        highScoreLabel.zPosition = 1
        self.addChild(highScoreLabel)
        
        restartLabel.text = "Restart"
        restartLabel.fontSize = 90
        restartLabel.fontColor = SKColor.white
        restartLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.25)
        restartLabel.zPosition = 1
        self.addChild(restartLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let pointOfTouch = touch.location(in: self)
            
            if restartLabel.contains(pointOfTouch) {
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
        }
    }
}
