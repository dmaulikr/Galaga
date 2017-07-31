//
//  ComplexWaves.swift
//  Nebula 'Nnihilation
//
//  Created by Jack Hamilton on 7/27/17.
//  Copyright © 2017 App Camp. All rights reserved.
//

import Foundation
import SpriteKit

class ComplexWave1FromLeft: Wave {
    
    required init(startingFrameCount: Int, parent: SKNode) {
        super.init(startingFrameCount: startingFrameCount, parent: parent)
        let enemyArray = [
            Enemy(spawnX: left - 300, spawnY: roof - 300, spawnSeconds: 0.0),
            Enemy(spawnX: left - 500, spawnY: roof - 300, spawnSeconds: 0.0),
            Enemy(spawnX: left - 700, spawnY: roof - 300, spawnSeconds: 0.0),
            Enemy(spawnX: left - 900, spawnY: roof - 300, spawnSeconds: 0.0),
            Enemy(spawnX: left - 1100, spawnY: roof - 300, spawnSeconds: 0.0)
        ]
        enemyArray[0].velocity.angle = 360
        enemyArray[1].velocity.angle = 360
        enemyArray[2].velocity.angle = 360
        enemyArray[3].velocity.angle = 360
        enemyArray[4].velocity.angle = 360
        enemyArray[0].velocity.magnitude = 6
        enemyArray[1].velocity.magnitude = 6
        enemyArray[2].velocity.magnitude = 6
        enemyArray[3].velocity.magnitude = 6
        enemyArray[4].velocity.magnitude = 6
        addEnemies(enemies: enemyArray)
    }
    
    override func update(frameCount: Int) {
        super.update(frameCount: frameCount)
        for enemy in enemies {
            if (enemy.velocity.angle > 270 && Int(enemy.position.x) > center - 100) {
                enemy.velocity.angle -= 1
            }
        }
    }
    
}

class ComplexWave1FromRight: Wave {
    
    required init(startingFrameCount: Int, parent: SKNode) {
        super.init(startingFrameCount: startingFrameCount, parent: parent)
        let enemyArray = [
            Enemy(spawnX: right + 200, spawnY: roof - 600, spawnSeconds: 0.0),
            Enemy(spawnX: right + 400, spawnY: roof - 600, spawnSeconds: 0.0),
            Enemy(spawnX: right + 600, spawnY: roof - 600, spawnSeconds: 0.0),
            Enemy(spawnX: right + 800, spawnY: roof - 600, spawnSeconds: 0.0),
            Enemy(spawnX: right + 1000, spawnY: roof - 600, spawnSeconds: 0.0)
        ]
        enemyArray[0].velocity.angle = 180
        enemyArray[1].velocity.angle = 180
        enemyArray[2].velocity.angle = 180
        enemyArray[3].velocity.angle = 180
        enemyArray[4].velocity.angle = 180
        enemyArray[0].velocity.magnitude = 6
        enemyArray[1].velocity.magnitude = 6
        enemyArray[2].velocity.magnitude = 6
        enemyArray[3].velocity.magnitude = 6
        enemyArray[4].velocity.magnitude = 6
        addEnemies(enemies: enemyArray)
    }
    
    
    override func update(frameCount: Int) {
        super.update(frameCount: frameCount)
        for enemy in enemies {
            if (enemy.velocity.angle < 270 && Int(enemy.position.x) < center + 100) {
                enemy.velocity.angle += 1
            }
        }
    }
    
}
