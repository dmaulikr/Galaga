//
//  BasicEnemy1.swift
//  Nebula 'Nnihilation
//
//  Created by Jack Hamilton on 7/26/17.
//  Copyright © 2017 App Camp. All rights reserved.
//

import Foundation
import SpriteKit

class BasicEnemy1: Enemy {
    
    override var imageFilename: String {
        return "Enemy2"
    }
    
    var direction = false
    
    override init(spawnLocation: CGPoint, spawnFrame: Int) {
        super.init(spawnLocation: spawnLocation, spawnFrame: spawnFrame)
        velocity.magnitude = 6
        velocity.angle = 220
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(frameCount: Int) {
        super.update(frameCount: frameCount)
        if (!direction && velocity.angle > 220) {
            velocity.angle -= 1
        } else if (!direction && velocity.angle == 220) {
            direction = !direction
            velocity.angle += 1
        } else if (direction && velocity.angle < 320) {
            velocity.angle += 1
        } else {
            direction = !direction
            velocity.angle -= 1
        }
    }
    
}
