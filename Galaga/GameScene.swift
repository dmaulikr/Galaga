//
//  GameScene.swift
//  Galaga
//
//  Created by App Camp on 7/25/16.
//  Copyright (c) 2016 App Camp. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let player = SKSpriteNode(imageNamed: "galaga")
    var movingRight = false
    var movingLeft = false
    let rows = 5
    let shipSpeed =  1600
    let enemySpeed = 45
    let genSpeed = 10.0
    var lastGen = 0.0
    var bullets = [SKSpriteNode()]
    var bGenLastTime = 0.0
    var bGenSpeed = 0.15
    var bulletSpeed: CGFloat = 800
    var bulletDamage: Int = 15
    let boundaryCategory: UInt32 = 0x1 << 2
    let bulletCategory: UInt32 = 0x1 << 1
    let enemyCategory: UInt32 = 0x1 << 0
    var tScore = 0
    let scoreLabel = SKLabelNode(text: "0")
    var parentView : SKView = SKView()
    var spawnList : [Spawn] = []
    var score:Int {
        get {
            return tScore
        } set {
            tScore = newValue
            scoreLabel.text = String(tScore)
        }
    }
    var touchLocation : CGPoint = CGPoint()
    var parentCtrl: UIViewController = UIViewController()
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColor.blackColor()
        Spawn.screenSize = size
        self.physicsWorld.contactDelegate = self
        let bar = SKShapeNode(rectOfSize: CGSize(width: size.width - 5, height: size.height/8))
        bar.name = "bar"
        bar.fillColor = SKColor.blackColor()
        bar.position = CGPoint(x: size.width/2, y: size.height-44)
        bar.strokeColor = SKColor.whiteColor()
        bar.lineWidth = 5.0
        bar.zPosition = 100
        scoreLabel.position = CGPoint(x: size.width/2, y: size.height*0.9)
        scoreLabel.fontName = "DIN Condensed"
        scoreLabel.fontSize = 60
        scoreLabel.zPosition = 101
        player.position = CGPoint(x: size.width*0.5, y: size.height*0.1)
        player.physicsBody = SKPhysicsBody(rectangleOfSize: SKTexture(imageNamed:"galaga").size())
        player.physicsBody?.dynamic = true
        player.physicsBody?.velocity = CGVectorMake(0, 0)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.collisionBitMask = 0x0
        player.physicsBody?.linearDamping = 0
        let boundsT = SKShapeNode(rectOfSize: CGSize(width: size.width, height: 10))
        boundsT.strokeColor = UIColor.blackColor()
        let bounds = SKSpriteNode(texture: SKView().textureFromNode(boundsT))
        bounds.position = CGPoint(x: size.width/2, y: 0)
        bounds.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: size.width, height: 10))
        let boundary = bounds.physicsBody!
        boundary.collisionBitMask = 0x0
        boundary.affectedByGravity = false
        boundary.categoryBitMask = boundaryCategory
        boundary.contactTestBitMask = enemyCategory
        addChild(bounds)
        addChild(player)
        addChild(scoreLabel)
        addChild(bar)
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first as UITouch!
        touchLocation = touch.locationInNode(self)
        
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        player.removeAllActions()
    }
    
    var lastPlayerPosition: CGPoint = CGPoint(x: -999, y: -999)
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //Follow finger controls - offset of height*.1
        let distance : CGFloat = sqrt(touches.first!.locationInNode(self).x * player.position.x + touches.first!.locationInNode(self).y + (size.height * 0.1) * player.position.y)
        let moveTo: CGPoint = CGPoint(x: touches.first!.locationInNode(self).x, y: touches.first!.locationInNode(self).y + (size.height * 0.1))
        if (distance > 1) {
            player.runAction(SKAction.moveTo(moveTo, duration: Double(distance)/Double(shipSpeed)))
        }
        
        //Support for control from anywhere - maybe make this a mode in options?
        /*
        if (lastPlayerPosition.x != -999 && lastPlayerPosition.y != -999) {
            touchLocation.x += player.position.x - lastPlayerPosition.x
            touchLocation.y += player.position.y - lastPlayerPosition.y

        }
        let diff:CGPoint = CGPoint(x: touches.first!.locationInNode(self).x - touchLocation.x, y: touches.first!.locationInNode(self).y - touchLocation.y)
        let moveTo = CGPoint(x: diff.x + player.position.x, y: diff.y + player.position.y)
        let distance : CGFloat = sqrt(moveTo.x * player.position.x + moveTo.y * player.position.y);
        if (distance > 1) {
            player.runAction(SKAction.moveTo(moveTo, duration: Double(distance)/Double(shipSpeed)))
        }
        lastPlayerPosition = player.position
 */
    }
    
    override func update(currentTime: CFTimeInterval) {
        
        genEnemies(currentTime)
        if (lastGen == 0) {
            lastGen = currentTime - genSpeed + 2
        }
        if (bGenLastTime == 0) {
            bGenLastTime = currentTime - bGenSpeed
        }
        if (player.position.x < size.width * 0.1 && movingLeft) {
            player.physicsBody?.velocity = CGVectorMake(0, 0)
        } else if (player.position.x > size.width * 0.9 && movingRight) {
            player.physicsBody?.velocity = CGVectorMake(0, 0)
        }
        if (currentTime >= bGenLastTime + bGenSpeed) {
            bGenLastTime = currentTime
            
            let tBullet = SKSpriteNode(imageNamed: "galaga_bullet")
            tBullet.position = player.position
            tBullet.position.y += 10
            tBullet.position.x += 10
            tBullet.physicsBody = SKPhysicsBody(rectangleOfSize: SKTexture(imageNamed: "galaga_bullet").size())
            tBullet.physicsBody?.dynamic = true
            tBullet.physicsBody?.velocity = CGVectorMake(0, bulletSpeed)
            tBullet.physicsBody?.affectedByGravity = false
            tBullet.physicsBody?.collisionBitMask = 0x0
            tBullet.physicsBody?.categoryBitMask = bulletCategory
            tBullet.physicsBody?.contactTestBitMask = enemyCategory
            tBullet.physicsBody?.linearDamping = 0
            tBullet.physicsBody?.usesPreciseCollisionDetection = true
            bullets.append(tBullet)
            addChild(tBullet)
 
            let tBullet2 = SKSpriteNode(imageNamed: "galaga_bullet")
            tBullet2.position = player.position
            tBullet2.position.y += 10
            tBullet2.position.x -= 10
            tBullet2.physicsBody = SKPhysicsBody(rectangleOfSize: SKTexture(imageNamed: "galaga_bullet").size())
            tBullet2.physicsBody?.dynamic = true
            tBullet2.physicsBody?.velocity = CGVectorMake(0, bulletSpeed)
            tBullet2.physicsBody?.affectedByGravity = false
            tBullet2.physicsBody?.collisionBitMask = 0x0
            tBullet2.physicsBody?.categoryBitMask = bulletCategory
            tBullet2.physicsBody?.contactTestBitMask = enemyCategory
            tBullet2.physicsBody?.linearDamping = 0
            tBullet2.physicsBody?.usesPreciseCollisionDetection = true
            bullets.append(tBullet2)
            addChild(tBullet2)
 
            if (bullets[0].position.y > size.height) {
                bullets[0].removeFromParent()
                bullets.removeAtIndex(0)
            }
            if (bullets[0].position.y > size.height) {
                bullets[0].removeFromParent()
                bullets.removeAtIndex(0)
            }
        }
    }
    func genEnemies(currentTime: CFTimeInterval) {
        if (currentTime >= lastGen + genSpeed) {
            lastGen = currentTime
            spawnList = SpawnPattern.BasicPattern1.getList()
            let rand = arc4random_uniform(2)
            switch(rand) {
            case 0:
                spawnList = SpawnPattern.BasicPattern1.getList()
                break
            case 1:
                spawnList = SpawnPattern.BasicPattern2.getList()
                break
            default:
                break
            }
        }
        //Generate enemies across rows here
        /*for i in 1...rows {
         let temp = Enemy(type: EnemyType.redMoth)
         let temp2 = (CGFloat(i)/CGFloat(rows))*size.width
         let temp3 = (CGFloat(1)/CGFloat(rows*2))*size.width
         temp.physicsBody!.velocity = CGVectorMake(0, CGFloat(enemySpeed * -1))
         temp.position.x = CGFloat(temp2 - temp3)
         temp.position.y = size.height*0.9
         addChild(temp)
         }*/
        for spawn in spawnList {
            if (spawn.spawnTime <= currentTime - lastGen) {
                let temp = Enemy(type:spawn.spawnType)
                temp.physicsBody!.velocity = CGVectorMake(0, CGFloat(enemySpeed * -1))
                temp.position = spawn.spawnLocation
                addChild(temp)
                spawnList.removeFirst()
            }
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        if let firstNode = contact.bodyA.node as! SKSpriteNode? {
            if let secondNode = contact.bodyB.node as! SKSpriteNode? {
                if (contact.bodyA.categoryBitMask == bulletCategory) && (contact.bodyB.categoryBitMask == enemyCategory) {
                    bulletCollisionWithEnemy(secondNode, bullet: firstNode)
                } else if (contact.bodyA.categoryBitMask == enemyCategory) && (contact.bodyB.categoryBitMask == bulletCategory) {
                    bulletCollisionWithEnemy(firstNode, bullet: secondNode)
                }
                if (contact.bodyA.categoryBitMask == boundaryCategory) {
                    secondNode.removeFromParent()
                    removeAllChildren()
                    view?.presentScene(GameOverState(size: view!.bounds.size), transition: SKTransition.fadeWithDuration(0.5))
                }
            }
        }
    }
    
    func bulletCollisionWithEnemy(enemy: SKSpriteNode, bullet: SKSpriteNode) {
        let tempEnemy = (enemy as! Enemy)
        tempEnemy.health -= bulletDamage
        if (tempEnemy.health <= 0) {
            enemy.removeFromParent()
            score += Int((enemy.position.y / size.height) * 100) * tempEnemy.scoreMul
        }
        bullet.removeFromParent()
    }
    
}
