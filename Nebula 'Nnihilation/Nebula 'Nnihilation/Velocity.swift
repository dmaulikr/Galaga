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
    private var internalAngle: Double
    //Stored as a radian. Passed as degrees.
    var angle: Double {
        get {
            return (internalAngle * 180) / .pi
        }
        set {
            internalAngle = (newValue / 180) * .pi
        }
    }
    var vector: CGVector {
        get {
            return CGVector (dx: magnitude * cos((angle / 180) * .pi),
                             dy: magnitude * sin((angle / 180) * .pi))
        }
        set {
            magnitude = sqrt(Double(pow(newValue.dx, 2) + pow(newValue.dy, 2)))
            internalAngle = (asin(Double(newValue.dy) / magnitude) * 180) / .pi
        }
    }
    
    //Accepts a degree quantity for angle. Converts it internally to a radian.
    init(magnitude: Double, angle: Double) {
        self.magnitude = magnitude
        self.internalAngle = (angle / 180) * .pi
    }
    
    func add(velocity: Velocity) {
        vector = CGVector(dx: vector.dx + velocity.vector.dx, dy: vector.dy + velocity.vector.dy)
    }
    
}
