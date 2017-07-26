//
//  Velocity.swift
//  Nebula 'Nnihilation
//
//  Created by Jack Hamilton on 7/26/17.
//  Copyright © 2017 App Camp. All rights reserved.
//

import Foundation
import SpriteKit

class Velocity {
    
    var magnitude: Double
    var angle: Double
    
    /*
     */
    init(magnitude: Double, angle: Double) {
        self.magnitude = magnitude
        self.angle = angle
    }
    
    func toVector() -> CGVector {
        return CGVector (x: magnitude * cos((angle / 180) * .pi),
                         y: magnitude * sin((angle / 180) * .pi))
    }
    
}
