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

class GameScene: SKScene, SKPhysicsContactDelegate {
    
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
    var wavesCount = Int()
    
    var bullet = SKShapeNode()
    
    override func didMove(to view: SKView)
    {
        self.physicsWorld.contactDelegate = self
        
        map = JSTileMap(named: "Level1.tmx")
        map.position.y += 7
        self.addChild(map)
        
        //Initial Gold
        gold = 10000
        wavesCount = 5
        
        createPhysicsAssets()
        createTowerTypesIcons()
        var numberOfEnemies = 5
        let spawn = SKAction.run{
            () in
            
            self.createEnemies(No: numberOfEnemies)
            numberOfEnemies += 1
        }
        
        let delay = SKAction.wait(forDuration:20, withRange: 5)
        let SpawnDelay = SKAction.sequence([spawn, delay])
        
        //for _ in 1...wavesCount
        //{
            self.run(SpawnDelay)
        //}
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
            roadNode.physicsBody?.collisionBitMask = 0
            roadNode.physicsBody?.contactTestBitMask = 0
            roadNode.name = "Path"
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
    
    func createEnemies(No: Int)
    {
        var enemy = SKSpriteNode(imageNamed: "Orc1_Walk_000")
        for i in 0...No-1
        {
            enemy = SKSpriteNode(imageNamed: "Orc1_Walk_000")
            let path = map.childNode(withName: "Path")
            enemy.position.y = (path?.position.y)! + 32
            enemy.position.x = CGFloat(i) * enemy.size.width*0.09 / 2 - 375
            enemy.zPosition = 2
            enemy.setScale(0.09)
            
            enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
            enemy.physicsBody?.affectedByGravity = false
            enemy.physicsBody?.categoryBitMask = PhyCat.Enemy
            enemy.physicsBody?.collisionBitMask = 0
            enemy.physicsBody?.contactTestBitMask = PhyCat.Bullet | PhyCat.TowerRange
            enemy.physicsBody?.isDynamic = false
            enemy.physicsBody?.allowsRotation = false
            
            var enemy1 = SKTextureAtlas()
            var enemy1Array = [SKTexture]()
            
            enemy1 = SKTextureAtlas(named: "Orc1_Walk.atlas")
            for i in 0...enemy1.textureNames.count-1
            {
                let Name = "Orc1_Walk_00\(i).png"
                enemy1Array.append(SKTexture(imageNamed: Name))
            }
            enemy.run(SKAction.repeatForever(SKAction.animate(with: enemy1Array, timePerFrame: 0.16)))
            enemy.run(SKAction.sequence([SKAction.moveBy(x: self.frame.size.width + CGFloat(i) * enemy.size.width*0.09 / 2 + 400, y: 0, duration: 30), SKAction.removeFromParent()]))
            
            map.addChild(enemy)
        }
    }
    
    func createAndFireBullet() -> SKShapeNode
    {
        bullet = SKShapeNode(circleOfRadius: 5)
        bullet.fillColor = SKColor.black
        bullet.position = CGPoint(x: tower1.position.x + tower1.size.width - 9, y: tower1.position.y + 2)
        bullet.zPosition = 1
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: 5)
        bullet.physicsBody?.usesPreciseCollisionDetection = true
        bullet.physicsBody?.categoryBitMask = PhyCat.Bullet
        bullet.physicsBody?.collisionBitMask = 0
        bullet.physicsBody?.contactTestBitMask = PhyCat.Enemy
        bullet.physicsBody?.isDynamic = true
        bullet.physicsBody?.affectedByGravity = false
        
        return bullet
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let firstObj = contact.bodyA
        let secondObj = contact.bodyB
        
        if (firstObj.categoryBitMask == PhyCat.TowerRange && secondObj.categoryBitMask == PhyCat.Enemy)
        {
            let tempBullet = self.createAndFireBullet()
            tempBullet.position = (firstObj.node?.position)!
            map.addChild(tempBullet)
            
            let move = SKAction.move(to: CGPoint(x: (secondObj.node?.position.x)!, y: (secondObj.node?.position.y)!), duration: 3)
            let remove = SKAction.removeFromParent()
            let fire = SKAction.sequence([move, remove])
            bullet.run(fire)
        }
        else if (firstObj.categoryBitMask == PhyCat.Enemy && secondObj.categoryBitMask == PhyCat.TowerRange)
        {
            let tempBullet = self.createAndFireBullet()
            tempBullet.position = (secondObj.node?.position)!
            map.addChild(tempBullet)
            
            let move = SKAction.move(to: CGPoint(x: (firstObj.node?.position.x)!, y: (firstObj.node?.position.y)!), duration: 3)
            let remove = SKAction.removeFromParent()
            let fire = SKAction.sequence([move, remove])
            bullet.run(fire)
        }
        
        if (firstObj.categoryBitMask == PhyCat.Enemy && secondObj.categoryBitMask == PhyCat.Bullet) || (firstObj.categoryBitMask == PhyCat.Bullet && secondObj.categoryBitMask == PhyCat.Enemy)
        {
            firstObj.node?.removeFromParent()
            secondObj.node?.removeFromParent()
            gold += 10
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
