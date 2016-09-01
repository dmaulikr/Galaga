//
//  GameOverState.swift
//  Galaga
//
//  Created by App Camp on 7/27/16.
//  Copyright © 2016 App Camp. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverState : SKScene {
    
    override func didMoveToView(view: SKView) {
        
        super.didMoveToView(view)
        self.backgroundColor = UIColor.blackColor()
        let gameOverMessage = SKLabelNode(text: "Game Over!")
        gameOverMessage.fontSize = 60
        gameOverMessage.fontName = "DIN Condensed"
        gameOverMessage.fontColor = UIColor.whiteColor()
        gameOverMessage.position = CGPoint(x: size.width / 2, y: (size.height / 2) + (size.height / 8))
        gameOverMessage.zPosition = 1
        addChild(gameOverMessage)
        let batten: CGButton = CGButton(defaultButtonText: "Replay", activeButtonText: "Replay", colorInactive: UIColor.whiteColor(), colorActive: UIColor.grayColor(), buttonAction: {view.presentScene(GameScene(size: view.bounds.size), transition: SKTransition.fadeWithDuration(0.5))})
        batten.position = CGPoint(x: size.width / 2, y: size.height / 2)
        batten.name = "replayButton"
        addChild(batten)
        let menuButton: CGButton = CGButton(defaultButtonText: "Menu", activeButtonText: "Menu", colorInactive: UIColor.whiteColor(), colorActive: UIColor.grayColor(), buttonAction: {view.presentScene(StartGameState(size: view.bounds.size), transition: SKTransition.fadeWithDuration(0.5))})
        menuButton.position = CGPoint(x: size.width / 2, y: size.height * 0.40)
        menuButton.name = "menuButton"
        addChild(menuButton)

        
    }
    
    func startGame() -> Void{
        
    }
    
    override func update(currentTime: NSTimeInterval) {
        
    }
    
}
