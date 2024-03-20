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
    let player = SKSpriteNode(imageNamed: "playerCar")
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min:CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    
    
    let gameArea: CGRect
    override init(size: CGSize) {
        let maxAspectRatio: CGFloat = 16.0 / 9.0
        let playableHeight = size.width / maxAspectRatio
        let playableWidth = min(playableHeight, size.width)
        let marginX = (size.width - playableWidth) / 2
        let marginY = (size.height - playableHeight) / 2
        // game area so that the player does not go off the screen
        gameArea = CGRect(x: marginX, y: marginY, width: playableWidth, height: size.height)
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // this function runs as soon as the scene loads up
    override func didMove(to view: SKView) {
        // sets the background image
        let background = SKSpriteNode(imageNamed: "RoadBackGround")
        // sets the background size to the scene size
        background.size = self.size
        // gets the center point of the scene
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        // layering of the bakground, we want this to be at the bottom of our game
        // the lower the number the further back the object is
        background.zPosition = 0
        self.addChild(background)
        
        // how big the ship will be, 1 being normal, 2 being huge
        player.setScale(0.5)
        player.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.2)
        player.zPosition = 2
        self.addChild(player)
        
        startNewLevel()
    }
    
    func startNewLevel(){
        let spawn = SKAction.run(spawnEnemy)
        let waitToSpawn = SKAction.wait(forDuration: 1)
        let spawnSequence = SKAction.sequence([spawn, waitToSpawn])
        let spawnRepeat = SKAction.repeatForever(spawnSequence)
        self.run(spawnRepeat)
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
    
    func spawnEnemy(){
        let randomXStart = random(min: CGRectGetMinX(gameArea), max: CGRectGetMaxX(gameArea))
        let randomXEnd = random(min: CGRectGetMinX(gameArea), max: CGRectGetMaxX(gameArea))
        
        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)
        
        let enemy = SKSpriteNode(imageNamed: "policeCar")
        enemy.setScale(1)
        enemy.position = startPoint
        enemy.zPosition = 2
        self.addChild(enemy)
        
        let moveEnemy = SKAction.move(to: endPoint, duration: 1.5)
        let deleteEnemy = SKAction.removeFromParent()
        let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy])
        enemy.run(enemySequence)
        
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        let amountToRotate = atan2(dy, dx)
        enemy.zRotation = amountToRotate
    }
    
    // when we touch the screen, fire a bullet
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        fireBullet()
    }
    
    // allows the ship to move left right
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let pointOfTouch = touch.location(in: self)
            let previousPointOfTouch = touch.previousLocation(in: self)
            
            let amountDraggedforX = pointOfTouch.x - previousPointOfTouch.x
            let amountDraggedforY = pointOfTouch.y - previousPointOfTouch.y
            
            player.position.x += amountDraggedforX
            player.position.y += amountDraggedforY
            
            // Constraints for horizontal movement
            if player.position.x > gameArea.maxX {
                player.position.x = gameArea.maxX
            } else if player.position.x < gameArea.minX {
                player.position.x = gameArea.minX
            }

            // Constraints for vertical movement
            if player.position.y > gameArea.maxY {
                player.position.y = gameArea.maxY
            } else if player.position.y < gameArea.minY {
                player.position.y = gameArea.minY
            }
        }
    }
}
