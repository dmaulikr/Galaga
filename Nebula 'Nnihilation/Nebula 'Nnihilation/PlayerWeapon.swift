//
//  PlayerWeapon.swift
//  Nebula 'Nnihilation
//
//  Created by Jack Hamilton on 7/14/17.
//  Copyright © 2017 App Camp. All rights reserved.
//

import Foundation
import SpriteKit
import SceneKit

class PlayerWeapon: Weapon {
    
    var damage = 7
    var force = 1.0
    var fireRate = 4
    var filename = "PlayerBullet"
    var bulletName = "PlayerBullet"
    var categoryMask = 1
    var contactMask = 0
    
}
