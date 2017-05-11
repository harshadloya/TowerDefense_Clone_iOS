//
//  GameMenuScene.swift
//  p08-loya
//
//  Created by Harshad Loya on 5/11/17.
//  Copyright © 2017 Harshad Loya. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameMenuScene: SKScene
{
    var gameName = SKLabelNode()
    var button1 = SKLabelNode()
    var button2 = SKLabelNode()
    
    override func didMove(to view: SKView)
    {
        //adding background
        let background = SKSpriteNode(imageNamed: "bggrid")
        background.size = CGSize(width: self.frame.width, height: self.frame.height)
        background.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        background.zPosition = 1
        self.addChild(background)
        
        gameName = self.createButton()
        gameName.position.y += 150
        gameName.text = "Tower Defense"
        gameName.fontSize = 80
        self.addChild(gameName)
        
        //Play Game Button
        button1 = self.createButton()
        button1.text = "Play"
        button1.fontSize = 65
        self.addChild(button1)
        
        //Rules Display Button
        button2 = self.createButton()
        button2.text = "Rules"
        button2.position.y -= 105
        button2.fontSize = 65
        self.addChild(button2)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch in touches
        {
            let location = touch.location(in: self)
            if button1.contains(location)
            {
                let gamescene = GameScene()
                gamescene.size = CGSize(width: 1280, height: 720)
                gamescene.scaleMode = .aspectFill
                self.view?.presentScene(gamescene)
            }
            if button2.contains(location)
            {
                let gameRulesScene = GameRules()
                gameRulesScene.size = CGSize(width: 1280, height: 720)
                gameRulesScene.scaleMode = .aspectFill
                self.view?.presentScene(gameRulesScene)
            }
        }
    }
    
    func createButton() -> SKLabelNode
    {
        //let newButton = SKSpriteNode(color: UIColor.red, size: CGSize(width: 100, height: 40))
        let newButton = SKLabelNode()
        newButton.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        newButton.zPosition = 2
        newButton.fontColor = SKColor.black
        newButton.fontName = "Oetztype"
        
        return newButton
    }
    
}
