//
//  GameOverState.swift
//  Galaga
//
//  Created by App Camp on 7/27/16.
//  Copyright © 2016 App Camp. All rights reserved.
//

import Foundation
import SpriteKit

class StartGameState : SKScene {
    
    var parentCtrl : UIViewController = UIViewController()
    var parentView : SKView = SKView()
    
    override func didMoveToView(view: SKView) {
        
        super.didMoveToView(view)
        self.backgroundColor = UIColor.blackColor()
        let gameOverMessage = SKLabelNode(text: "-DEX-")
        gameOverMessage.fontSize = 80
        gameOverMessage.fontName = "DIN Condensed"
        gameOverMessage.fontColor = UIColor.whiteColor()
        gameOverMessage.position = CGPoint(x: size.width / 2, y: (size.height / 4) * 3)
        gameOverMessage.zPosition = 1
        addChild(gameOverMessage)
        let startButton: CGButton = CGButton(defaultButtonText: "Start Game", activeButtonText: "Start Game", colorInactive: UIColor.whiteColor(), colorActive: UIColor.grayColor(), buttonAction: {view.presentScene(GameScene(size: view.bounds.size), transition: SKTransition.fadeWithDuration(0.5))})
        let scoreButton: CGButton = CGButton(defaultButtonText: "Scoreboard", activeButtonText: "Scoreboard", colorInactive: UIColor.whiteColor(), colorActive: UIColor.grayColor(), buttonAction: {view.presentScene(GameScene(size: view.bounds.size), transition: SKTransition.fadeWithDuration(0.5))})
        startButton.position = CGPoint(x: size.width / 2, y: size.height * 0.45)
        startButton.name = "playButton"
        scoreButton.position = CGPoint(x: size.width / 2, y: size.height * 0.35)
        scoreButton.name = "scoreButton"
        addChild(startButton)
        addChild(scoreButton)
        
    }
    
    func startGame() -> Void{
        view?.presentScene(GameScene(size: view!.bounds.size))
    }
    
    override func update(currentTime: NSTimeInterval) {
        
    }
    
}
