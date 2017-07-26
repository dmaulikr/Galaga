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
    var startingFrameCount: Int
    var enemies: [Enemy]?
    
    init(startingFrameCount: Int) {
        self.startingFrameCount = startingFrameCount
    }
    
    func update(frameCount: Int) {
        let currentFrame = frameCount - startingFrameCount
        if let enemyArray = enemies {
            for enemy in enemyArray {
                enemy.update(frameCount: currentFrame)
            }
        }
    }
}
