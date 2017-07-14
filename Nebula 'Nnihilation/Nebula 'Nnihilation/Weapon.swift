//
//  Weapon.swift
//  Nebula 'Nnihilation
//
//  Created by Jack Hamilton on 7/14/17.
//  Copyright © 2017 App Camp. All rights reserved.
//

import Foundation

protocol Weapon {
    
    var damage: Int { get }
    var force: Double { get }
    var fireRate: Int { get }
    var filename: String { get }
    var name: String { get }
    var categoryMask: Int { get }
    var contactMask: Int { get }
    
}
