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
    static let TowerRange : UInt32 = 0x1 << 4
}

class GameScene: SKScene {
    
    var map = JSTileMap()
    var towerPositions = TMXObjectGroup()
    var road = TMXObjectGroup()
    
    var towerPosArray = Array<SKSpriteNode>()
    var towerSelected = Array<Bool>()
    
    var defaultRange = SKShapeNode()
    
    var goldLabel = SKLabelNode()
    var gold = Int()
    
    var tower1 = SKSpriteNode()
    var tower2 = SKSpriteNode()
    var tower3 = SKSpriteNode()
    
    var towersOnMap = Array<SKSpriteNode>()
    var towersOnMapAt = Array<Int>()
    
    override func didMove(to view: SKView)
    {
        map = JSTileMap(named: "Level1.tmx")
        map.position.y += 7
        self.addChild(map)
        
        //Initial Gold
        gold = 10000
        
        createPhysicsAssets()
        createTowerTypesIcons()
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
            towerSelected.append(false)
            //map.addChild(towerPosNode)
        }
    }
    
    func createTowerTypesIcons()
    {
        tower3 = SKSpriteNode(imageNamed: "Cannon1_Icon")
        tower3.position = CGPoint(x: self.frame.size.width - 80, y: 90)
        tower3.zPosition = 1
        
        tower2 = SKSpriteNode(imageNamed: "Cannon1_Icon")
        tower2.position.x = tower3.position.x - 160
        tower2.position.y = tower3.position.y
        tower2.zPosition = 1
        
        tower1 = SKSpriteNode(imageNamed: "Cannon1_Icon")
        tower1.position.x = tower2.position.x - 160
        tower1.position.y = tower2.position.y
        tower1.zPosition = 1
        
        map.addChild(tower3)
        map.addChild(tower2)
        map.addChild(tower1)
        
    }
    
    var temp = Int()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
        for touch in touches
        {
            let location  = touch.location(in: self)
            
            if tower1.contains(location)
            {
                for a in 0...towerSelected.count-1
                {
                    if(towerSelected[a] == true && gold >= 50)
                    {
                        gold -= 50
                        createTower1(At: a)
                    }
                }
            }
            if tower2.contains(location)
            {
                for a in 0...towerSelected.count-1
                {
                    if(towerSelected[a] == true && gold >= 100)
                    {
                        gold -= 100
                        createTower2(At: a)
                    }
                }
            }
            if tower3.contains(location)
            {
                for a in 0...towerSelected.count-1
                {
                    if(towerSelected[a] == true && gold >= 150)
                    {
                        gold -= 150
                        createTower3(At: a)
                    }
                }
            }
            
            
            defaultRange.removeFromParent()
            towerSelected[temp] = false
            
            for x in 0...towerPosArray.count-1
            {
                if towerPosArray[x].contains(location)
                {
                    towerSelected[x] = true
                    temp = x
                    
                    defaultRange = SKShapeNode(circleOfRadius: towerPosArray[x].size.width + 20)
                    defaultRange.strokeColor = SKColor.white
                    defaultRange.fillColor = UIColor(red: 169.0/255.0, green: 169.0/255.0, blue: 169.0/255.0, alpha: 0.35)
                    defaultRange.position = towerPosArray[x].position
                    
                    map.addChild(defaultRange)
                    
                }
            }
            
        }
    }
    
    func createTower1(At: Int)
    {
        let tower = SKSpriteNode(imageNamed: "Cannon1_Tower")
        tower.position = towerPosArray[At].position
        tower.zPosition = 2
        
        tower.physicsBody = SKPhysicsBody(circleOfRadius: tower.size.width + 30)
        tower.physicsBody?.affectedByGravity = false
        tower.physicsBody?.categoryBitMask = PhyCat.TowerRange
        tower.physicsBody?.collisionBitMask = 0
        tower.physicsBody?.contactTestBitMask = PhyCat.Enemy
        
        map.addChild(tower)
        towersOnMap.append(tower)
        towersOnMapAt.append(At)
    }
    
    func createTower2(At: Int)
    {
        let tower = SKSpriteNode(imageNamed: "Cannon1_Tower")
        tower.position = towerPosArray[At].position
        tower.zPosition = 2
        
        tower.physicsBody = SKPhysicsBody(circleOfRadius: tower.size.width + 30)
        tower.physicsBody?.affectedByGravity = false
        tower.physicsBody?.categoryBitMask = PhyCat.TowerRange
        tower.physicsBody?.collisionBitMask = 0
        tower.physicsBody?.contactTestBitMask = PhyCat.Enemy
        
        map.addChild(tower)
        towersOnMap.append(tower)
        towersOnMapAt.append(At)
    }
    
    func createTower3(At: Int)
    {
        let tower = SKSpriteNode(imageNamed: "Cannon1_Tower")
        tower.position = towerPosArray[At].position
        tower.zPosition = 2
        
        tower.physicsBody = SKPhysicsBody(circleOfRadius: tower.size.width + 30)
        tower.physicsBody?.affectedByGravity = false
        tower.physicsBody?.categoryBitMask = PhyCat.TowerRange
        tower.physicsBody?.collisionBitMask = 0
        tower.physicsBody?.contactTestBitMask = PhyCat.Enemy
        
        map.addChild(tower)
        towersOnMap.append(tower)
        towersOnMapAt.append(At)
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
