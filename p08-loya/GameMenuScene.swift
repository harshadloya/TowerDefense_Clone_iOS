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
        
        /*
        //adding snake image
        let snake = SKSpriteNode(imageNamed: "snake")
        snake.position = CGPoint(x: self.frame.width / 2 + self.frame.width / 3, y: self.frame.height / 2)
        snake.zPosition = 2
        self.addChild(snake)
        */
        
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
