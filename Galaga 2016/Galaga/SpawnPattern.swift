//
//  SpawnPattern.swift
//  Galaga
//
//  Created by App Camp on 7/28/16.
//  Copyright © 2016 App Camp. All rights reserved.
//

import Foundation
import SpriteKit

enum SpawnPattern {
    case BasicPattern1, BasicPattern2
    
    func getList() -> [Spawn] {
        switch self {
        case .BasicPattern1:
            var spawns : [Spawn] = []
            spawns.append(Spawn(loc: SpawnLocation.topX2, time: 0.0, type: EnemyType.redMoth))
            spawns.append(Spawn(loc: SpawnLocation.topX4, time: 0.0, type: EnemyType.redMoth))
            spawns.append(Spawn(loc: SpawnLocation.topX6, time: 0.0, type: EnemyType.redMoth))
            spawns.append(Spawn(loc: SpawnLocation.topX8, time: 0.0, type: EnemyType.redMoth))
            spawns.append(Spawn(loc: SpawnLocation.topX2, time: 1.5, type: EnemyType.blueMoth))
            spawns.append(Spawn(loc: SpawnLocation.topX4, time: 1.5, type: EnemyType.redMoth))
            spawns.append(Spawn(loc: SpawnLocation.topX6, time: 1.5, type: EnemyType.redMoth))
            spawns.append(Spawn(loc: SpawnLocation.topX8, time: 1.5, type: EnemyType.blueMoth))
            spawns.append(Spawn(loc: SpawnLocation.topX2, time: 3.0, type: EnemyType.redMoth))
            spawns.append(Spawn(loc: SpawnLocation.topX4, time: 3.0, type: EnemyType.redMoth))
            spawns.append(Spawn(loc: SpawnLocation.topX6, time: 3.0, type: EnemyType.redMoth))
            spawns.append(Spawn(loc: SpawnLocation.topX8, time: 3.0, type: EnemyType.redMoth))
            return spawns
        case .BasicPattern2:
            var spawns : [Spawn] = []
            spawns.append(Spawn(loc: SpawnLocation.topX2, time: 0.0, type: EnemyType.redMoth))
            spawns.append(Spawn(loc: SpawnLocation.topX4, time: 0.0, type: EnemyType.redMoth))
            spawns.append(Spawn(loc: SpawnLocation.topX6, time: 0.0, type: EnemyType.redMoth))
            spawns.append(Spawn(loc: SpawnLocation.topX8, time: 0.0, type: EnemyType.redMoth))
            spawns.append(Spawn(loc: SpawnLocation.topX2, time: 1.5, type: EnemyType.blueMoth))
            spawns.append(Spawn(loc: SpawnLocation.topX4, time: 1.5, type: EnemyType.redMoth))
            spawns.append(Spawn(loc: SpawnLocation.topX6, time: 1.5, type: EnemyType.redMoth))
            spawns.append(Spawn(loc: SpawnLocation.topX8, time: 1.5, type: EnemyType.blueMoth))
            spawns.append(Spawn(loc: SpawnLocation.topX2, time: 3.0, type: EnemyType.redMoth))
            spawns.append(Spawn(loc: SpawnLocation.topX4, time: 3.0, type: EnemyType.blueMoth))
            spawns.append(Spawn(loc: SpawnLocation.topX6, time: 3.0, type: EnemyType.blueMoth))
            spawns.append(Spawn(loc: SpawnLocation.topX8, time: 3.0, type: EnemyType.redMoth))
            return spawns
        }
        
    }
    
}

enum SpawnLocation  {
    case topX1, topX2, topX3, topX4, topX5, topX6, topX7, topX8, topX9, rightBottom, rightTop, leftBottom, leftTop
    func getPoint(screenSize: CGSize) -> CGPoint {
        switch self {
        case .topX1:
            return CGPoint(x: screenSize.width * 0.1, y: screenSize.height)
        case .topX2:
            return CGPoint(x: screenSize.width * 0.2, y: screenSize.height)
        case .topX3:
            return CGPoint(x: screenSize.width * 0.3, y: screenSize.height)
        case .topX4:
            return CGPoint(x: screenSize.width * 0.4, y: screenSize.height)
        case .topX5:
            return CGPoint(x: screenSize.width * 0.5, y: screenSize.height)
        case .topX6:
            return CGPoint(x: screenSize.width * 0.6, y: screenSize.height)
        case .topX7:
            return CGPoint(x: screenSize.width * 0.7, y: screenSize.height)
        case .topX8:
            return CGPoint(x: screenSize.width * 0.8, y: screenSize.height)
        case .topX9:
            return CGPoint(x: screenSize.width * 0.9, y: screenSize.height)
        case .rightBottom:
            return CGPoint(x: screenSize.width + 50, y: screenSize.height * 0.4)
        case .rightTop:
            return CGPoint(x: screenSize.width + 50, y: screenSize.height * 0.7)
        case .leftBottom:
            return CGPoint(x: -50, y: screenSize.height * 0.4)
        case .leftTop:
            return CGPoint(x: -50, y: screenSize.height * 0.7)
        }
    }
}

public class Spawn {
    public static var screenSize : CGSize = CGSize()
    var spawnLocation : CGPoint
    var spawnTime : Double
    var spawnType : EnemyType
    
    init(loc: SpawnLocation, time: Double, type: EnemyType) {
        spawnLocation = loc.getPoint(Spawn.screenSize)
        spawnTime = time
        spawnType = type
    }
}

enum EnemyType {
    case redMoth, blueMoth
}