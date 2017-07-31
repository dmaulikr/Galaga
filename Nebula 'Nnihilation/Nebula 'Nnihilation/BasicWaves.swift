//
//  BasicWave.swift
//  Nebula 'Nnihilation
//
//  Created by Jack Hamilton on 7/26/17.
//  Copyright © 2017 App Camp. All rights reserved.
//

import Foundation
import SpriteKit

class BasicWave: Wave {
    
    required init(startingFrameCount: Int, parent: SKNode) {
        super.init(startingFrameCount: startingFrameCount, parent: parent)
        let enemyArray = [
            Enemy(spawnX: leftCenter, spawnY: roof, spawnSeconds: 0.0),
            Enemy(spawnX: rightCenter, spawnY: roof, spawnSeconds: 0.0),
            BasicEnemy1(spawnX: center, spawnY: roof, spawnSeconds: 2.0)
        ]
        addEnemies(enemies: enemyArray)
    }
    
}

class BasicWave2: Wave {
    
    required init(startingFrameCount: Int, parent: SKNode) {
        super.init(startingFrameCount: startingFrameCount, parent: parent)
        let enemyArray = [
            Enemy(spawnX: left - 300, spawnY: roof - 500, spawnSeconds: 0.0),
            Enemy(spawnX: right + 300, spawnY: roof - 500, spawnSeconds: 0.0),
            Enemy(spawnX: center, spawnY: roof, spawnSeconds: 0.0)
        ]
        enemyArray[0].velocity.angle = 320
        enemyArray[1].velocity.angle = 220
        addEnemies(enemies: enemyArray)
    }
    
}
