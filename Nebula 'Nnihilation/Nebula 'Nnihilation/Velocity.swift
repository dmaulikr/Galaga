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
    var vector: CGVector {
        get {
            return CGVector (dx: magnitude * cos((angle / 180) * .pi),
                             dy: magnitude * sin((angle / 180) * .pi))
        }
        set (newValue) {
            magnitude = sqrt(Double(pow(newValue.dx, 2) + pow(newValue.dy, 2)))
            angle = (asin(Double(newValue.dy) / magnitude) * 180) / .pi
        }
    }
    
    /*
     */
    init(magnitude: Double, angle: Double) {
        self.magnitude = magnitude
        self.angle = angle
    }
    
}
