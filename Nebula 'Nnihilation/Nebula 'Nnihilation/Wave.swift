//
//  Wave.swift
//  Nebula 'Nnihilation
//
//  Created by Jack Hamilton on 7/26/17.
//  Copyright © 2017 App Camp. All rights reserved.
//

import Foundation
import SpriteKit

class Wave {
    //Constants for simplified enemy spawn positioning
    //y-position just above the game
    let roof = Int(GameScene.gameHeight / 2) + 100
    let left = Int(GameScene.gameWidth * 0.1) - Int(GameScene.gameWidth / 2)
    let leftCenter = Int(GameScene.gameWidth * 0.3) - Int(GameScene.gameWidth / 2)
    let center = Int(GameScene.gameWidth * 0.5) - Int(GameScene.gameWidth / 2)
    let rightCenter = Int(GameScene.gameWidth * 0.7) - Int(GameScene.gameWidth / 2)
    let right = Int(GameScene.gameWidth * 0.9) - Int(GameScene.gameWidth / 2)
    
    var startingFrameCount: Int
    var enemies: [Enemy]
    let parent: SKNode
    
    
    required init(startingFrameCount: Int, parent: SKNode) {
        self.startingFrameCount = startingFrameCount
        enemies = []
        self.parent = parent
    }
    convenience init(parent: SKNode) {
        self.init(startingFrameCount: 0, parent: parent)
    }
    
    func addEnemies(enemies: [Enemy]) {
        for i in 0...(enemies.count - 1) {
            let enemy = enemies[i]
            enemy.wave = self
            enemy.waveIndex = i
            parent.addChild(enemy)
            self.enemies.append(enemy)
        }
    }
    
    func update(frameCount: Int) {
        let currentFrame = frameCount - startingFrameCount
        for enemy in enemies {
            if (currentFrame >= enemy.spawnFrame) {
                enemy.update(frameCount: currentFrame)
            }
        }
    }
}
