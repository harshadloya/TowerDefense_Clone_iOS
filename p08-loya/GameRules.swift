//
//  GameRules.swift
//  p08-loya
//
//  Created by Harshad Loya on 5/11/17.
//  Copyright © 2017 Harshad Loya. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameRules: SKScene
{
    
    var gameName = SKLabelNode()
    var text1 = SKLabelNode()
    var text2 = SKLabelNode()
    var text3 = SKLabelNode()
    var text4 = SKLabelNode()
    var text5 = SKLabelNode()
    var text6 = SKLabelNode()
    var text7 = SKLabelNode()
    var text8 = SKLabelNode()
    var text9 = SKLabelNode()
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
        gameName.position.y += 200
        gameName.text = "Tower Defense Game Description and Rules"
        gameName.fontSize = 50
        self.addChild(gameName)
        
        //Game Rules
        text1 = self.createButton()
        text1.text = "1. The game has 3 types of enemies and towers"
        text1.fontSize = 25
        text1.position.y += 100
        self.addChild(text1)
        
        text2 = self.createButton()
        text2.text = "2. Monster 1 has health of 2, Monster 2 has health of 4 and Monster 3 has health of 9"
        text2.fontSize = 25
        text2.position.y += 50
        self.addChild(text2)
        
        text3 = self.createButton()
        text3.text = "3. Tower 1 does 1 damage giving 20 gold when enemy is killed, Tower 2 does 2 damage"
        text3.fontSize = 25
        self.addChild(text3)
        
        text4 = self.createButton()
        text4.text = "giving 25 gold and Tower 3 does 5 damage giving 35 gold"
        text4.fontSize = 25
        text4.position.y -= 35
        self.addChild(text4)
        
        
        text5 = self.createButton()
        text5.text = "4. Select the position to place the tower from the marked spots and"
        text5.fontSize = 25
        text5.position.y -= 80
        self.addChild(text5)
        
        text5 = self.createButton()
        text5.text = "then click on tower icon of desired type "
        text5.fontSize = 25
        text5.position.y -= 105
        self.addChild(text5)
        
        text7 = self.createButton()
        text7.text = "5. Survive 5 waves to win the game"
        text7.fontSize = 25
        text7.position.y -= 155
        self.addChild(text7)
        
        text8 = self.createButton()
        text8.text = "6. Protect the castle, dont let its health drop to 0 or below."
        text8.fontSize = 25
        text8.position.y -= 205
        self.addChild(text8)
        
        text9 = self.createButton()
        text9.text = "7. When enemy reaches castle, the remaining health of enemy is taken out from castle's health"
        text9.fontSize = 24
        text9.position.y -= 255
        self.addChild(text9)
        
        //Rules Display Button
        button2 = self.createButton()
        button2.text = "Back"
        button2.position.y -= 355
        button2.fontSize = 65
        self.addChild(button2)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch in touches
        {
            let location = touch.location(in: self)
            
            if button2.contains(location)
            {
                let gameMenuScene = GameMenuScene()
                gameMenuScene.size = CGSize(width: 1280, height: 720)
                gameMenuScene.scaleMode = .aspectFill
                self.view?.presentScene(gameMenuScene)
            }
        }
    }
    
    func createButton() -> SKLabelNode
    {
        let newButton = SKLabelNode()
        newButton.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        newButton.zPosition = 2
        newButton.fontColor = SKColor.black
        newButton.fontName = "Oetztype"
        
        return newButton
    }

}
