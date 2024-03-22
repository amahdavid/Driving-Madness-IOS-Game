//
//  GameScene.swift
//  Solo Mission Game Tutorial
//
//  Created by David Chika Amah-Nnachi on 2024-03-18.
//

import SpriteKit
import GameplayKit
var gameScore = 0

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let startLabel = SKLabelNode(fontNamed: "THE BOLD FONT")
    let scoreLabel = SKLabelNode(fontNamed: "THE BOLD FONT")
    
    var livesNumber = 3
    let livesLabel = SKLabelNode(fontNamed: "THE BOLD FONT")
    
    let explosionSound = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)
    
    var lastUpdateTime: TimeInterval = 0
    var deltaFrameTime: TimeInterval = 0
    var amountToMovePerSecond: CGFloat = 600.0
    
    var level = 0
    enum gameState {
        case preGame
        case inGame
        case afterGame
    }
    
    var currentGameState = gameState.preGame
    // sets the player image
    let player = SKSpriteNode(imageNamed: "playerCar")
    
    struct PhysicsCategories {
        static let None : UInt32 = 0
        static let Player : UInt32 = 0b1 // 1
        static let Bullet : UInt32 = 0b10 // 2
        static let Enemy : UInt32 = 0b100 // 4
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(0xFFFFFFFF))
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
        self.physicsWorld.contactDelegate = self
        gameScore = 0
        
        for i in 0...1 {
            // sets the background image
            let background = SKSpriteNode(imageNamed: "RoadBackGround")
            background.size = self.size
            background.anchorPoint = CGPoint(x: 0.5, y: 0)
            
            // 2 backgrounds to overlap on each other
            background.position = CGPoint(
                x: self.size.width / 2, 
                y: self.size.height * CGFloat(i)
            )
            
            background.zPosition = 0
            background.name = "Background"
            self.addChild(background)
        }
        
        // how big the ship will be, 1 being normal, 2 being huge
        player.setScale(0.3)
        player.position = CGPoint(x: self.size.width / 2, y: -player.size.height)
        player.zPosition = 2
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody!.affectedByGravity = false
        player.physicsBody!.categoryBitMask = PhysicsCategories.Player
        player.physicsBody!.collisionBitMask = PhysicsCategories.None
        player.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
        
        self.addChild(player)
        
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 70
        scoreLabel.fontColor = SKColor.white
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.position = CGPoint(x: self.size.width * 0.20, y: self.size.height + scoreLabel.frame.size.height)
        scoreLabel.zPosition = 100
        self.addChild(scoreLabel)
        
        livesLabel.text = "Lives: \(livesNumber)"
        livesLabel.fontSize = 70
        livesLabel.fontColor = SKColor.white
        livesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        livesLabel.position = CGPoint(x: self.size.width * 0.80, y: self.size.height + livesLabel.frame.size.height)
        livesLabel.zPosition = 100
        self.addChild(livesLabel)
        
        let moveOnToScreenAction = SKAction.moveTo(y: self.size.height * 0.9, duration: 0.3)
        scoreLabel.run(moveOnToScreenAction)
        livesLabel.run(moveOnToScreenAction)
        
        startLabel.text = "Tap To Start"
        startLabel.fontSize = 100
        startLabel.fontColor = SKColor.white
        startLabel.zPosition = 1
        startLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        startLabel.alpha = 0
        self.addChild(startLabel)
        
        let fadeInAction = SKAction.fadeIn(withDuration: 0.3)
        startLabel.run(fadeInAction)
    }
    
    func startGame() {
        currentGameState = gameState.inGame
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
        let deleteAction = SKAction.removeFromParent()
        let deleteSequence = SKAction.sequence([fadeOutAction, deleteAction])
        startLabel.run(deleteSequence)
        
        let moveShipOntoScreen = SKAction.moveTo(y: self.size.height * 0.2, duration: 0.5)
        let startLevel = SKAction.run(startNewLevel)
        let startGameSequence = SKAction.sequence([moveShipOntoScreen, startLevel])
        player.run(startGameSequence)
    }
    
    func addScore() {
        gameScore += 1
        scoreLabel.text = "Score: \(gameScore)"
        
        if gameScore == 10 || gameScore == 25 || gameScore == 50 {
            startNewLevel()
            let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
            let scaleDown = SKAction.scale(to: 1, duration: 0.2)
            let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
            scoreLabel.run(scaleSequence)
        }
    }
    
    func loseLife() {
        livesNumber -= 1
        livesLabel.text = "Lives: \(livesNumber)"
        
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1, duration: 0.2)
        let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
        livesLabel.run(scaleSequence)
        
        if livesNumber == 0 { gameOver() }
    }
    
    func gameOver() {
        currentGameState = gameState.afterGame
        self.removeAllActions()
        
        self.enumerateChildNodes(withName: "Bullet") {
            bullet, stop in
            bullet.removeAllActions()
        }
        self.enumerateChildNodes(withName: "Enemy") {
            enemy, stop in
            enemy.removeAllActions()
        }
        let changeSceneAction = SKAction.run(changeScene)
        let waitToChangeScene = SKAction.wait(forDuration: 1)
        let changeSceneSequence = SKAction.sequence([waitToChangeScene, changeSceneAction])
        self.run(changeSceneSequence)
    }
    
    func changeScene() {
        let sceneToMoveTo = GameOverScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let myTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
    }
    
    // holds the information of which objects have made contact
    func didBegin(_ contact: SKPhysicsContact) {
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        // grabbing the category number of both bodies
        // whichever body has the lower category number should be body 1
        // whichever has the higher number then it should be body 2
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            body1 = contact.bodyA
            body2 = contact.bodyB
        } else {
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        
        // if the player has hit the enemy
        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Enemy {
            if body1.node != nil {spawnExplosion(spawnPosition: body1.node!.position)}
            if body2.node != nil {spawnExplosion(spawnPosition: body2.node!.position)}
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            
            gameOver()
        }
        
        // if the bullet has hit the enemy
        if body1.categoryBitMask == PhysicsCategories.Bullet 
            && body2.categoryBitMask == PhysicsCategories.Enemy {
            addScore()
            if body2.node != nil {
                if body2.node!.position.y > self.size.height {
                    return
                } else {
                    spawnExplosion(spawnPosition: body2.node!.position)
                }
            }
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
        }
    }
    
    func spawnExplosion (spawnPosition: CGPoint) {
        let explosion = SKSpriteNode(imageNamed: "explosion")
        explosion.position = spawnPosition
        explosion.zPosition = 3
        explosion.setScale(0)
        self.addChild(explosion)
        
        let scaleIn = SKAction.scale(to: 1.5, duration: 0.1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        let delete = SKAction.removeFromParent()
        
        let explosionSequence = SKAction.sequence([explosionSound, scaleIn, fadeOut, delete])
        explosion.run(explosionSequence)
    }

    func startNewLevel(){
        level += 1
        if self.action(forKey: "spawingEnemies") != nil {
            self.removeAction(forKey: "spawingEnemies")
        }
        
        var spawingDuration = TimeInterval()
        
        switch level {
        case 1: spawingDuration = 1.2
        case 2: spawingDuration = 0.9
        case 3: spawingDuration = 0.5
        case 4: spawingDuration = 0.2
        default:
            spawingDuration = 0.5
            print("Cannot find level info")
        }
        
        let spawn = SKAction.run(spawnEnemy)
        let waitToSpawn = SKAction.wait(forDuration: spawingDuration)
        let spawnSequence = SKAction.sequence([waitToSpawn, spawn])
        let spawnRepeat = SKAction.repeatForever(spawnSequence)
        self.run(spawnRepeat, withKey: "spawingEnemies")
    }
    
    func fireBullet() {
        let bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.name = "Bullet"
        bullet.setScale(1)
        bullet.position = player.position
        bullet.zPosition = 1
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        
        bullet.physicsBody!.affectedByGravity = false
        bullet.physicsBody!.categoryBitMask = PhysicsCategories.Bullet
        bullet.physicsBody!.collisionBitMask = PhysicsCategories.None
        bullet.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
        
        self.addChild(bullet)
        
        let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1)
        let deleteBullet = SKAction.removeFromParent()
        let bulletSequence = SKAction.sequence([moveBullet, deleteBullet])
        bullet.run(bulletSequence)
    }
    
    func spawnEnemy(){
        let randomXStart = random(min: CGRectGetMinX(gameArea), max: CGRectGetMaxX(gameArea))
        let randomXEnd = random(min: CGRectGetMinX(gameArea), max: CGRectGetMaxX(gameArea))
        
        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)
        
        let enemy = SKSpriteNode(imageNamed: "policeCar")
        enemy.name = "Enemy"
        enemy.setScale(0.6)
        enemy.position = startPoint
        enemy.zPosition = 2
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.categoryBitMask = PhysicsCategories.Enemy
        enemy.physicsBody!.collisionBitMask = PhysicsCategories.None
        enemy.physicsBody!.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Bullet
        
        self.addChild(enemy)
        
        let moveEnemy = SKAction.move(to: endPoint, duration: 1.5)
        let deleteEnemy = SKAction.removeFromParent()
        let loseAlife = SKAction.run(loseLife)
        let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy, loseAlife])
        
        if currentGameState == gameState.inGame { enemy.run(enemySequence) }
        
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        let amountToRotate = atan2(dy, dx)
        enemy.zRotation = amountToRotate
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if currentGameState == gameState.preGame { startGame() }
        else if currentGameState == gameState.inGame { fireBullet() }
    }
    
    // allows the ship to move horizontally and vertically
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let pointOfTouch = touch.location(in: self)
            let previousPointOfTouch = touch.previousLocation(in: self)
            
            let amountDraggedforX = pointOfTouch.x - previousPointOfTouch.x
            let amountDraggedforY = pointOfTouch.y - previousPointOfTouch.y
            
            if currentGameState == gameState.inGame {
                player.position.x += amountDraggedforX
                player.position.y += amountDraggedforY
            }
            
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
    
    // runs once per game frame, used to move the background by moving it a tiny amount
    // to move our background a good amount we need to know how the time
    // gives the illusion for an endless scrolling
    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime == 0 {
            lastUpdateTime = currentTime
        } else {
            deltaFrameTime = currentTime - lastUpdateTime
            lastUpdateTime = currentTime
        }
        
        let amountToMoveBackground = amountToMovePerSecond * CGFloat(deltaFrameTime)
        self.enumerateChildNodes(withName: "Background") {
            background, stop in
            
            background.position.y -= amountToMoveBackground
            
            if background.position.y < -self.size.height {
                background.position.y += self.size.height * 2
            }
        }
    }
}
