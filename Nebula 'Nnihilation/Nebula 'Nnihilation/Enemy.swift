//
//  Enemy.swift
//  Nebula 'Nnihilation
//
//  Created by Jack Hamilton on 7/26/17.
//  Copyright © 2017 App Camp. All rights reserved.
//

import Foundation
import SpriteKit

class Enemy: SKNode {
    var health: Int
    var velocity: Velocity

    required init?(coder aDecoder: NSCoder) {
        health = 0
        velocity = Velocity(magnitude: 0, angle: 0)
        super.init(coder: aDecoder)
    }
    
    func update(frameCount: Int) {
        
    }
}
