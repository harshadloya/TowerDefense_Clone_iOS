//
//  GameScene.swift
//  p08-loya
//
//  Created by Harshad Loya on 5/9/17.
//  Copyright © 2017 Harshad Loya. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhyCat
{
    static let Path : UInt32 = 0x1 << 1
    static let Enemy : UInt32 = 0x1 << 2
    static let Bullet : UInt32 = 0x1 << 3
}

class GameScene: SKScene {
    
    var map = JSTileMap()
    var towerPositions = TMXObjectGroup()
    var road = TMXObjectGroup()
    var towerPosArray = Array<SKSpriteNode>()
    var defaultRange = SKShapeNode()
    
    var goldLabel = SKLabelNode()
    var gold = Int()
    
    override func didMove(to view: SKView)
    {
        map = JSTileMap(named: "Level1.tmx")
        map.position.y += 7
        self.addChild(map)
        
        createPhysicsAssets()
        
    }
    
    func createPhysicsAssets()
    {
        road = map.groupNamed("Path")
        
        var roadArrayObjects = NSMutableArray()
        roadArrayObjects =  road.objects
        
        var roadDictObj = NSDictionary()
        var roadX = CGFloat()
        var roadY = CGFloat()
        var roadW = Double()
        var roadH = Double()
        
        for z in 0...roadArrayObjects.count-1
        {
            roadDictObj = roadArrayObjects.object(at: z) as! NSDictionary
            roadX = roadDictObj.value(forKey: "x") as! CGFloat
            roadY = roadDictObj.value(forKey: "y") as! CGFloat
            roadW = (roadDictObj.value(forKey: "width") as! NSString).doubleValue
            roadH = (roadDictObj.value(forKey: "height") as! NSString).doubleValue
            
            let roadNode = SKSpriteNode(color: SKColor.clear, size: CGSize(width: roadW, height: roadH))
            roadNode.position = CGPoint(x: roadX + CGFloat(roadW / 2.0), y: roadY + 20)
            roadNode.zPosition = -40
            
            roadNode.physicsBody = SKPhysicsBody(rectangleOf: roadNode.size)
            roadNode.physicsBody?.isDynamic = false
            roadNode.physicsBody?.categoryBitMask = PhyCat.Path
            roadNode.physicsBody?.collisionBitMask = PhyCat.Enemy
            roadNode.physicsBody?.contactTestBitMask = 0
            
            map.addChild(roadNode)
        }
        
        towerPositions = map.groupNamed("TowerPos")
        
        var towerPosArrayObjects = NSMutableArray()
        towerPosArrayObjects =  towerPositions.objects
        
        var towerPosDictObj = NSDictionary()
        var towerPosX = CGFloat()
        var towerPosY = CGFloat()
        var towerPosW = Double()
        var towerPosH = Double()
        
        for z in 0...towerPosArrayObjects.count-1
        {
            towerPosDictObj = towerPosArrayObjects.object(at: z) as! NSDictionary
            towerPosX = towerPosDictObj.value(forKey: "x") as! CGFloat
            towerPosY = towerPosDictObj.value(forKey: "y") as! CGFloat
            towerPosW = (towerPosDictObj.value(forKey: "width") as! NSString).doubleValue
            towerPosH = (towerPosDictObj.value(forKey: "height") as! NSString).doubleValue
            
            let towerPosNode = SKSpriteNode(color: SKColor.clear, size: CGSize(width: towerPosW, height: towerPosH))
            towerPosNode.position = CGPoint(x: towerPosX + CGFloat(towerPosW / 2.0), y: towerPosY + 30)
            towerPosNode.zPosition = -40
            
            towerPosArray.append(towerPosNode)
            //map.addChild(towerPosNode)
        }
    }
    
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
   {
        for touch in touches
        {
            defaultRange.removeFromParent()
            
            let location  = touch.location(in: self)
            for x in 0...towerPosArray2.count-1
            {
                if towerPosArray2[x].contains(location)
                {
                    defaultRange = SKShapeNode(circleOfRadius: towerPosArray2[x].size.width + 20)
                    defaultRange.strokeColor = SKColor.white
                    defaultRange.fillColor = UIColor(red: 169.0/255.0, green: 169.0/255.0, blue: 169.0/255.0, alpha: 0.35)
                    defaultRange.position = towerPosArray2[x].position
                    
                    map.addChild(defaultRange)
                    
                }
            }
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
