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
            Enemy(spawnX: rightCenter, spawnY: roof, spawnSeconds: 0.0)
        ]
        addEnemies(enemies: enemyArray)
    }
    
}
