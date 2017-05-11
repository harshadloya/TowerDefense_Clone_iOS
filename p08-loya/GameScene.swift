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
    static let Bullet1 : UInt32 = 0x1 << 3
    static let Bullet2 : UInt32 = 0x1 << 4
    static let Bullet3 : UInt32 = 0x1 << 5
    static let Tower1Range : UInt32 = 0x1 << 6
    static let Tower2Range : UInt32 = 0x1 << 7
    static let Tower3Range : UInt32 = 0x1 << 8
    static let Castle : UInt32 = 0x1 << 9
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
    var tower1CostLabel = SKLabelNode()
    var tower2CostLabel = SKLabelNode()
    var tower3CostLabel = SKLabelNode()
    
    var towersOnMap = Array<SKSpriteNode>()
    var towersOnMapAt = Array<Int>()
    var wavesCount = Int()
    
    var numberOfEnemies = Int()
    
    var enemiesOnMap = [(SKSpriteNode,Int)]()
    var SpawnEnemy = SKAction()
    
    var timeIntervalInWaveSpawns = Int()
    var spawnTimer = Timer()
    
    var townHealth = Int()
    var townHealthLabel = SKLabelNode()
    
    var enemyToBeRemoved = [Int]()
    var enemySize = CGFloat()
    var tempD = CGFloat()
    
    var townCastle = SKSpriteNode()

    var gameWinOrLoose = Bool()
    var restartBtn = SKSpriteNode()
    var exitBtn = SKSpriteNode()
    
    var waveNumberLabel = SKLabelNode()
    
    var bullet1 = SKShapeNode()
    var bullet2 = SKShapeNode()
    var bullet3 = SKShapeNode()
    
    let enemy1Health = 2
    let enemy2Health = 4
    let enemy3Health = 9
    
    override func didMove(to view: SKView)
    {
        self.startGame()
    }
    
    func startGame()
    {
        self.physicsWorld.contactDelegate = self
        
        map = JSTileMap(named: "Level1.tmx")
        map.position.y += 7
        self.addChild(map)
        
        //Initial Gold
        gold = 100
        wavesCount = 1
        timeIntervalInWaveSpawns = 35
        townHealth = 50
        gameWinOrLoose = false
        
        self.createPhysicsAssets()
        self.createTowerTypesIcons()
        self.createLabel()
        
        
        let spawn = SKAction.run{
            () in
            if(!self.gameWinOrLoose)
            {
                self.waveNumberLabel = SKLabelNode(text: "Wave \(self.wavesCount)")
                self.waveNumberLabel.position = CGPoint(x: -50, y: self.frame.size.height / 2 - 50)
                self.waveNumberLabel.zPosition = 10
                self.waveNumberLabel.fontSize = 50
                self.waveNumberLabel.fontName = "Oetztype"
                self.waveNumberLabel.fontColor = SKColor.black
                self.waveNumberLabel.color = SKColor.white
                self.map.addChild(self.waveNumberLabel)
                
                let waveNoAnim = SKAction.move(to: CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2 - 50), duration: 3)
                let waveNoAnim2 = SKAction.fadeOut(withDuration: 3.5)
                self.waveNumberLabel.run(SKAction.sequence([waveNoAnim, waveNoAnim2, SKAction.removeFromParent()]), completion:{ () -> Void in
                    
                        
                        if(self.wavesCount == 1)
                        {
                            self.enemyToBeRemoved.removeAll()
                            let d = CGFloat(550.0)
                            self.tempD = d + 50.0
                            
                            self.numberOfEnemies = 5
                            self.createEnemy1(No: self.numberOfEnemies, Dist: d)
                        }
                        else if(self.wavesCount == 2)
                        {
                            self.enemyToBeRemoved.removeAll()
                            let d = CGFloat(750.0)
                            self.tempD = d + 50.0
                            
                            self.numberOfEnemies = 6
                            self.createEnemy2(No: self.numberOfEnemies, Dist: d)
                        }
                        else if(self.wavesCount == 3)
                        {
                            self.enemyToBeRemoved.removeAll()
                            let d = CGFloat(850.0)
                            self.tempD = d + 50.0
                            
                            self.numberOfEnemies = 7
                            self.createEnemy3(No: self.numberOfEnemies, Dist: d)
                        }
                        else if(self.wavesCount == 4)
                        {
                            self.enemyToBeRemoved.removeAll()
                            let d = CGFloat(1050.0)
                            self.tempD = d + 50.0
                            
                            self.numberOfEnemies = 8
                            self.createEnemy1(No: self.numberOfEnemies-5, Dist: d)
                            self.createEnemy2(No: self.numberOfEnemies-4, Dist: -(self.enemySize*3 - d))
                            self.createEnemy3(No: self.numberOfEnemies-7, Dist: -(self.enemySize*7 - d))
                        }
                        else if(self.wavesCount == 5)
                        {
                            self.enemyToBeRemoved.removeAll()
                            let d = CGFloat(1150.0)
                            self.tempD = d + 50.0
                            
                            self.numberOfEnemies = 9
                            self.createEnemy1(No: self.numberOfEnemies-7, Dist: d)
                            self.createEnemy2(No: self.numberOfEnemies-6, Dist: -(self.enemySize*2 - d))
                            self.createEnemy3(No: self.numberOfEnemies-4, Dist: -(self.enemySize*5 - d))
                        }
                        else
                        {
                            if self.enemiesOnMap.isEmpty
                            {
                                self.enemyToBeRemoved.removeAll()
                            }
                            
                        }
                        
                        
                        for x in 0...self.numberOfEnemies-1
                        {
                            self.map.addChild(self.enemiesOnMap[x].0)
                        }
                    })
                
            }
        }
        
        SpawnEnemy = SKAction.sequence([spawn])
        self.run(SpawnEnemy)
        
        spawnTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.spawnEnemiesInInterval), userInfo: nil, repeats: true)
    }
    
    func spawnEnemiesInInterval()
    {
        timeIntervalInWaveSpawns -= 1
        if(timeIntervalInWaveSpawns == 0)
        {
           self.run(SpawnEnemy)
            timeIntervalInWaveSpawns = 35
            wavesCount += 1
            
            if wavesCount >= 6
            {
                spawnTimer.invalidate()
                self.gameWin()
            }
            
        }
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
        
        townCastle = SKSpriteNode(imageNamed: "Castle")
        townCastle.setScale(0.65)
        let path = map.childNode(withName: "Path")
        townCastle.position = CGPoint(x: self.frame.width - townCastle.frame.size.width * (0.65) / 4, y: (path?.position.y)! + 105.0)
        townCastle.zPosition = 1
        
        /*
        print(townCastle.frame.size.width * (0.65))
        print(townCastle.frame.size.width * (1.5))
        print(townCastle.position)
        
        let tempS = SKShapeNode(circleOfRadius: townCastle.size.width / 2 - 100)
        tempS.position = townCastle.position
        tempS.zPosition = 100
        map.addChild(tempS)
        */
        
        //townCastle.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: townCastle.frame.size.width, height: self.frame.size.height))
        townCastle.physicsBody = SKPhysicsBody(circleOfRadius: townCastle.size.width / 2 - 110)
        townCastle.physicsBody?.categoryBitMask = PhyCat.Castle
        townCastle.physicsBody?.collisionBitMask = 0
        townCastle.physicsBody?.contactTestBitMask = PhyCat.Enemy
        townCastle.physicsBody?.affectedByGravity = false

        
        map.addChild(townCastle)
    }
    
    func createTowerTypesIcons()
    {
        tower3 = SKSpriteNode(imageNamed: "Cannon3_Icon")
        tower3.position = CGPoint(x: self.frame.size.width - 80, y: 90)
        tower3.zPosition = 1
        
        tower3CostLabel = SKLabelNode(text: "Cost: 150")
        tower3CostLabel.fontColor = SKColor.darkGray
        tower3CostLabel.fontName = "Oetztype"
        tower3CostLabel.fontSize = 30
        tower3CostLabel.position = tower3.position
        tower3CostLabel.position.y += 75
        tower3CostLabel.zPosition = 15
        
        
        tower2 = SKSpriteNode(imageNamed: "Cannon2_Icon")
        tower2.position.x = tower3.position.x - 160
        tower2.position.y = tower3.position.y
        tower2.zPosition = 1
        
        tower2CostLabel = SKLabelNode(text: "Cost: 100")
        tower2CostLabel.fontColor = SKColor.blue
        tower2CostLabel.fontName = "Oetztype"
        tower2CostLabel.fontSize = 30
        tower2CostLabel.position = tower2.position
        tower2CostLabel.position.y += 75
        tower2CostLabel.zPosition = 15
        
        tower1 = SKSpriteNode(imageNamed: "Cannon1_Icon")
        tower1.position.x = tower2.position.x - 160
        tower1.position.y = tower2.position.y
        tower1.zPosition = 1
        
        tower1CostLabel = SKLabelNode(text: "Cost: 50")
        tower1CostLabel.fontColor = SKColor.red
        tower1CostLabel.fontName = "Oetztype"
        tower1CostLabel.fontSize = 30
        tower1CostLabel.position = tower1.position
        tower1CostLabel.position.y += 75
        tower1CostLabel.zPosition = 15
        
        map.addChild(tower3)
        map.addChild(tower3CostLabel)
        map.addChild(tower2)
        map.addChild(tower2CostLabel)
        map.addChild(tower1)
        map.addChild(tower1CostLabel)
        
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
            
            if(gameWinOrLoose)
            {
                if (restartBtn.contains(location))
                {
                    restartGame()
                }
                
                if (exitBtn.contains(location))
                {
                    let gameMenuScene = GameMenuScene()
                    gameMenuScene.size = CGSize(width: 1280, height: 720)
                    gameMenuScene.scaleMode = .aspectFill
                    self.view?.presentScene(gameMenuScene)
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
        tower.physicsBody?.categoryBitMask = PhyCat.Tower1Range
        tower.physicsBody?.collisionBitMask = 0
        tower.physicsBody?.contactTestBitMask = PhyCat.Enemy
        
        map.addChild(tower)
        towersOnMap.append(tower)
        towersOnMapAt.append(At)
    }
    
    func createTower2(At: Int)
    {
        let tower = SKSpriteNode(imageNamed: "Cannon2_Tower")
        tower.position = towerPosArray[At].position
        tower.zPosition = 2
        
        tower.physicsBody = SKPhysicsBody(circleOfRadius: tower.size.width + 30)
        tower.physicsBody?.affectedByGravity = false
        tower.physicsBody?.categoryBitMask = PhyCat.Tower2Range
        tower.physicsBody?.collisionBitMask = 0
        tower.physicsBody?.contactTestBitMask = PhyCat.Enemy
        
        map.addChild(tower)
        towersOnMap.append(tower)
        towersOnMapAt.append(At)
    }
    
    func createTower3(At: Int)
    {
        let tower = SKSpriteNode(imageNamed: "Cannon3_Tower")
        tower.position = towerPosArray[At].position
        tower.zPosition = 2
        
        tower.physicsBody = SKPhysicsBody(circleOfRadius: tower.size.width + 30)
        tower.physicsBody?.affectedByGravity = false
        tower.physicsBody?.categoryBitMask = PhyCat.Tower3Range
        tower.physicsBody?.collisionBitMask = 0
        tower.physicsBody?.contactTestBitMask = PhyCat.Enemy
        
        map.addChild(tower)
        towersOnMap.append(tower)
        towersOnMapAt.append(At)
    }
    
    func createEnemy1(No: Int, Dist: CGFloat)
    {
        var enemy = SKSpriteNode(imageNamed: "Orc1_Walk_000")
        enemySize = enemy.size.width*0.09 / 1.1
        
        for i in 0...No-1
        {
            enemy = SKSpriteNode(imageNamed: "Orc1_Walk_000")
            enemy.name = "Orc1_\(i)"
            let path = map.childNode(withName: "Path")
            enemy.position.y = (path?.position.y)! + 32
            enemy.position.x = CGFloat(i) * enemy.size.width*0.09 / 1.1 - Dist
            
            enemy.zPosition = 2
            enemy.setScale(0.09)
            
            enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
            enemy.physicsBody?.affectedByGravity = false
            enemy.physicsBody?.categoryBitMask = PhyCat.Enemy
            enemy.physicsBody?.collisionBitMask = 0
            enemy.physicsBody?.contactTestBitMask = PhyCat.Bullet1 | PhyCat.Bullet2 | PhyCat.Bullet3 | PhyCat.Tower1Range | PhyCat.Tower2Range | PhyCat.Tower3Range | PhyCat.Castle
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
            
            enemy.run(SKAction.sequence([SKAction.moveBy(x: self.frame.size.width + CGFloat(i) * enemy.size.width*0.09 / 1.1 + self.tempD, y: 0, duration: 30), SKAction.removeFromParent()]))
            
            //map.addChild(enemy)
            enemiesOnMap.append((enemy,enemy1Health))
        }
    }
    
    func createEnemy2(No: Int, Dist: CGFloat)
    {
        //enemyHealth = 2
        var enemy = SKSpriteNode(imageNamed: "Orc2_Walk_000")
        enemySize = enemy.size.width*0.09 / 1.1
        
        
        for i in 0...No-1
        {
            enemy = SKSpriteNode(imageNamed: "Orc2_Walk_000")
            enemy.name = "Orc2_\(i)"
            let path = map.childNode(withName: "Path")
            enemy.position.y = (path?.position.y)! + 32
            enemy.position.x = CGFloat(i) * enemy.size.width*0.09 / 1.1 - Dist
            
            enemy.zPosition = 2
            enemy.setScale(0.09)
            
            enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
            enemy.physicsBody?.affectedByGravity = false
            enemy.physicsBody?.categoryBitMask = PhyCat.Enemy
            enemy.physicsBody?.collisionBitMask = 0
            enemy.physicsBody?.contactTestBitMask = PhyCat.Bullet1 | PhyCat.Bullet2 | PhyCat.Bullet3 | PhyCat.Tower1Range | PhyCat.Tower2Range | PhyCat.Tower3Range | PhyCat.Castle
            enemy.physicsBody?.isDynamic = false
            enemy.physicsBody?.allowsRotation = false
            
            var enemy2 = SKTextureAtlas()
            var enemy2Array = [SKTexture]()
            
            enemy2 = SKTextureAtlas(named: "Orc2_Walk.atlas")
            for i in 0...enemy2.textureNames.count-1
            {
                let Name = "Orc2_Walk_00\(i).png"
                enemy2Array.append(SKTexture(imageNamed: Name))
            }
            enemy.run(SKAction.repeatForever(SKAction.animate(with: enemy2Array, timePerFrame: 0.16)))
            
            enemy.run(SKAction.sequence([SKAction.moveBy(x: self.frame.size.width + CGFloat(i) * enemy.size.width*0.09 / 1.1 + self.tempD, y: 0, duration: 30), SKAction.removeFromParent()]))
            
            //map.addChild(enemy)
            enemiesOnMap.append((enemy,enemy2Health))
        }
    }
    
    func createEnemy3(No: Int, Dist: CGFloat)
    {
        //enemyHealth = 2
        var enemy = SKSpriteNode(imageNamed: "Orc3_Walk_000")
        for i in 0...No-1
        {
            enemy = SKSpriteNode(imageNamed: "Orc3_Walk_000")
            enemy.name = "Orc3_\(i)"
            let path = map.childNode(withName: "Path")
            enemy.position.y = (path?.position.y)! + 32
            enemy.position.x = CGFloat(i) * enemy.size.width*0.09 / 1.1 - Dist
            
            enemy.zPosition = 2
            enemy.setScale(0.09)
            
            enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
            enemy.physicsBody?.affectedByGravity = false
            enemy.physicsBody?.categoryBitMask = PhyCat.Enemy
            enemy.physicsBody?.collisionBitMask = 0
            enemy.physicsBody?.contactTestBitMask = PhyCat.Bullet1 | PhyCat.Bullet2 | PhyCat.Bullet3 | PhyCat.Tower1Range | PhyCat.Tower2Range | PhyCat.Tower3Range | PhyCat.Castle
            enemy.physicsBody?.isDynamic = false
            enemy.physicsBody?.allowsRotation = false
            
            var enemy3 = SKTextureAtlas()
            var enemy3Array = [SKTexture]()
            
            enemy3 = SKTextureAtlas(named: "Orc3_Walk.atlas")
            for i in 0...enemy3.textureNames.count-1
            {
                let Name = "Orc3_Walk_00\(i).png"
                enemy3Array.append(SKTexture(imageNamed: Name))
            }
            enemy.run(SKAction.repeatForever(SKAction.animate(with: enemy3Array, timePerFrame: 0.16)))
            
            enemy.run(SKAction.sequence([SKAction.moveBy(x: self.frame.size.width + CGFloat(i) * enemy.size.width*0.09 / 1.1 + self.tempD, y: 0, duration: 30), SKAction.removeFromParent()]))
            
            //map.addChild(enemy)
            enemiesOnMap.append((enemy,enemy3Health))
        }
    }
    
    func createBullet1() -> SKShapeNode
    {
        bullet1 = SKShapeNode(circleOfRadius: 5)
        bullet1.fillColor = SKColor.red
        bullet1.position = CGPoint(x: tower1.position.x + tower1.size.width - 9, y: tower1.position.y + 2)
        bullet1.zPosition = 1
        bullet1.physicsBody = SKPhysicsBody(circleOfRadius: 5)
        bullet1.physicsBody?.usesPreciseCollisionDetection = true
        bullet1.physicsBody?.categoryBitMask = PhyCat.Bullet1
        bullet1.physicsBody?.collisionBitMask = 0
        bullet1.physicsBody?.contactTestBitMask = PhyCat.Enemy
        bullet1.physicsBody?.isDynamic = true
        bullet1.physicsBody?.affectedByGravity = false
        
        return bullet1
    }
    
    func createBullet2() -> SKShapeNode
    {
        bullet2 = SKShapeNode(circleOfRadius: 5)
        bullet2.fillColor = SKColor.blue
        bullet2.position = CGPoint(x: tower2.position.x + tower2.size.width - 9, y: tower2.position.y + 2)
        bullet2.zPosition = 1
        bullet2.physicsBody = SKPhysicsBody(circleOfRadius: 5)
        bullet2.physicsBody?.usesPreciseCollisionDetection = true
        bullet2.physicsBody?.categoryBitMask = PhyCat.Bullet2
        bullet2.physicsBody?.collisionBitMask = 0
        bullet2.physicsBody?.contactTestBitMask = PhyCat.Enemy
        bullet2.physicsBody?.isDynamic = true
        bullet2.physicsBody?.affectedByGravity = false
        
        return bullet2
    }
    
    func createBullet3() -> SKShapeNode
    {
        bullet3 = SKShapeNode(circleOfRadius: 5)
        bullet3.fillColor = SKColor.darkGray
        bullet3.position = CGPoint(x: tower3.position.x + tower3.size.width - 9, y: tower3.position.y + 2)
        bullet3.zPosition = 1
        bullet3.physicsBody = SKPhysicsBody(circleOfRadius: 5)
        bullet3.physicsBody?.usesPreciseCollisionDetection = true
        bullet3.physicsBody?.categoryBitMask = PhyCat.Bullet3
        bullet3.physicsBody?.collisionBitMask = 0
        bullet3.physicsBody?.contactTestBitMask = PhyCat.Enemy
        bullet3.physicsBody?.isDynamic = true
        bullet3.physicsBody?.affectedByGravity = false
        
        return bullet3
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let firstObj = contact.bodyA
        let secondObj = contact.bodyB
        
        if (firstObj.categoryBitMask == PhyCat.Tower1Range && secondObj.categoryBitMask == PhyCat.Enemy)
        {
            let tempNode = secondObj.node
            
            let tempBullet = self.createBullet1()
            tempBullet.position = (firstObj.node?.position)!
            map.addChild(tempBullet)
            
            
            let move = SKAction.move(to: CGPoint(x: (tempNode?.position.x)!, y: (tempNode?.position.y)!), duration: 1)
            let remove = SKAction.removeFromParent()
            let fire = SKAction.sequence([move, remove])
            tempBullet.run(fire)
            
        }
        else if (firstObj.categoryBitMask == PhyCat.Enemy && secondObj.categoryBitMask == PhyCat.Tower1Range)
        {
            let tempNode = firstObj.node
            
            let tempBullet = self.createBullet1()
            tempBullet.position = (secondObj.node?.position)!
            map.addChild(tempBullet)
            
            
            let move = SKAction.move(to: CGPoint(x: (tempNode?.position.x)!, y: (tempNode?.position.y)!), duration: 1)
            let remove = SKAction.removeFromParent()
            let fire = SKAction.sequence([move, remove])
            tempBullet.run(fire)
        }
        
        if (firstObj.categoryBitMask == PhyCat.Tower2Range && secondObj.categoryBitMask == PhyCat.Enemy)
        {
            let tempNode = secondObj.node
            
            let tempBullet = self.createBullet2()
            tempBullet.position = (firstObj.node?.position)!
            map.addChild(tempBullet)
            
            
            let move = SKAction.move(to: CGPoint(x: (tempNode?.position.x)!, y: (tempNode?.position.y)!), duration: 1)
            let remove = SKAction.removeFromParent()
            let fire = SKAction.sequence([move, remove])
            tempBullet.run(fire)
            
        }
        else if (firstObj.categoryBitMask == PhyCat.Enemy && secondObj.categoryBitMask == PhyCat.Tower2Range)
        {
            let tempNode = firstObj.node
            
            let tempBullet = self.createBullet2()
            tempBullet.position = (secondObj.node?.position)!
            map.addChild(tempBullet)
            
            
            let move = SKAction.move(to: CGPoint(x: (tempNode?.position.x)!, y: (tempNode?.position.y)!), duration: 1)
            let remove = SKAction.removeFromParent()
            let fire = SKAction.sequence([move, remove])
            tempBullet.run(fire)
        }
        
        if (firstObj.categoryBitMask == PhyCat.Tower3Range && secondObj.categoryBitMask == PhyCat.Enemy)
        {
            let tempNode = secondObj.node
            
            let tempBullet = self.createBullet3()
            tempBullet.position = (firstObj.node?.position)!
            map.addChild(tempBullet)
            
            
            let move = SKAction.move(to: CGPoint(x: (tempNode?.position.x)!, y: (tempNode?.position.y)!), duration: 1)
            let remove = SKAction.removeFromParent()
            let fire = SKAction.sequence([move, remove])
            tempBullet.run(fire)
            
        }
        else if (firstObj.categoryBitMask == PhyCat.Enemy && secondObj.categoryBitMask == PhyCat.Tower3Range)
        {
            let tempNode = firstObj.node
            
            let tempBullet = self.createBullet3()
            tempBullet.position = (secondObj.node?.position)!
            map.addChild(tempBullet)
            
            
            let move = SKAction.move(to: CGPoint(x: (tempNode?.position.x)!, y: (tempNode?.position.y)!), duration: 1)
            let remove = SKAction.removeFromParent()
            let fire = SKAction.sequence([move, remove])
            tempBullet.run(fire)
        }
        
        if (firstObj.categoryBitMask == PhyCat.Enemy && secondObj.categoryBitMask == PhyCat.Bullet1)
        {
            secondObj.node?.removeFromParent()
            
            for x in 0...enemiesOnMap.count-1
            {
                if firstObj.node == enemiesOnMap[x].0
                {
                    enemiesOnMap[x].1 -= 1
                }
            }
            
            for x in 0...enemiesOnMap.count-1
            {
                if enemiesOnMap[enemiesOnMap.count-1-x].1 <= 0
                {
                    enemiesOnMap[enemiesOnMap.count-1-x].0.removeFromParent()
                    enemyToBeRemoved.append(enemiesOnMap.count-1-x)
                    gold += 20
                }
            }
            if !enemyToBeRemoved.isEmpty
            {
                for y in 0...enemyToBeRemoved.count-1
                {
                    enemiesOnMap.remove(at: enemyToBeRemoved[y])
                }
                enemyToBeRemoved.removeAll()
            }
        }
        else if (firstObj.categoryBitMask == PhyCat.Bullet1 && secondObj.categoryBitMask == PhyCat.Enemy)
        {
            firstObj.node?.removeFromParent()
            
            for x in 0...enemiesOnMap.count-1
            {
                if firstObj.node == enemiesOnMap[x].0
                {
                    enemiesOnMap[x].1 -= 1
                }
            }
            
            for x in 0...enemiesOnMap.count-1
            {
                if enemiesOnMap[enemiesOnMap.count-1-x].1 <= 0
                {
                    enemiesOnMap[enemiesOnMap.count-1-x].0.removeFromParent()
                    enemyToBeRemoved.append(enemiesOnMap.count-1-x)
                    gold += 20
                }
            }
            if !enemyToBeRemoved.isEmpty
            {
                for y in 0...enemyToBeRemoved.count-1
                {
                    enemiesOnMap.remove(at: enemyToBeRemoved[y])
                }
                enemyToBeRemoved.removeAll()
            }
        }
        
        if (firstObj.categoryBitMask == PhyCat.Enemy && secondObj.categoryBitMask == PhyCat.Bullet2)
        {
            secondObj.node?.removeFromParent()
            
            for x in 0...enemiesOnMap.count-1
            {
                if firstObj.node == enemiesOnMap[x].0
                {
                    enemiesOnMap[x].1 -= 2
                }
            }
            
            for x in 0...enemiesOnMap.count-1
            {
                if enemiesOnMap[enemiesOnMap.count-1-x].1 <= 0
                {
                    enemiesOnMap[enemiesOnMap.count-1-x].0.removeFromParent()
                    enemyToBeRemoved.append(enemiesOnMap.count-1-x)
                    gold += 25
                }
            }
            if !enemyToBeRemoved.isEmpty
            {
                for y in 0...enemyToBeRemoved.count-1
                {
                    enemiesOnMap.remove(at: enemyToBeRemoved[y])
                }
                enemyToBeRemoved.removeAll()
            }
        }
        else if (firstObj.categoryBitMask == PhyCat.Bullet2 && secondObj.categoryBitMask == PhyCat.Enemy)
        {
            firstObj.node?.removeFromParent()
            
            for x in 0...enemiesOnMap.count-1
            {
                if firstObj.node == enemiesOnMap[x].0
                {
                    enemiesOnMap[x].1 -= 2
                }
            }
            
            for x in 0...enemiesOnMap.count-1
            {
                if enemiesOnMap[enemiesOnMap.count-1-x].1 <= 0
                {
                    enemiesOnMap[enemiesOnMap.count-1-x].0.removeFromParent()
                    enemyToBeRemoved.append(enemiesOnMap.count-1-x)
                    gold += 25
                }
            }
            if !enemyToBeRemoved.isEmpty
            {
                for y in 0...enemyToBeRemoved.count-1
                {
                    enemiesOnMap.remove(at: enemyToBeRemoved[y])
                }
                enemyToBeRemoved.removeAll()
            }
        }
        
        if (firstObj.categoryBitMask == PhyCat.Enemy && secondObj.categoryBitMask == PhyCat.Bullet3)
        {
            secondObj.node?.removeFromParent()
            
            for x in 0...enemiesOnMap.count-1
            {
                if firstObj.node == enemiesOnMap[x].0
                {
                    enemiesOnMap[x].1 -= 5
                }
            }
            
            for x in 0...enemiesOnMap.count-1
            {
                if enemiesOnMap[enemiesOnMap.count-1-x].1 <= 0
                {
                    enemiesOnMap[enemiesOnMap.count-1-x].0.removeFromParent()
                    enemyToBeRemoved.append(enemiesOnMap.count-1-x)
                    gold += 35
                }
            }
            if !enemyToBeRemoved.isEmpty
            {
                for y in 0...enemyToBeRemoved.count-1
                {
                    enemiesOnMap.remove(at: enemyToBeRemoved[y])
                }
                enemyToBeRemoved.removeAll()
            }
        }
        else if (firstObj.categoryBitMask == PhyCat.Bullet3 && secondObj.categoryBitMask == PhyCat.Enemy)
        {
            firstObj.node?.removeFromParent()
            
            for x in 0...enemiesOnMap.count-1
            {
                if firstObj.node == enemiesOnMap[x].0
                {
                    enemiesOnMap[x].1 -= 5
                }
            }
            
            for x in 0...enemiesOnMap.count-1
            {
                if enemiesOnMap[enemiesOnMap.count-1-x].1 <= 0
                {
                    enemiesOnMap[enemiesOnMap.count-1-x].0.removeFromParent()
                    enemyToBeRemoved.append(enemiesOnMap.count-1-x)
                    gold += 35
                }
            }
            if !enemyToBeRemoved.isEmpty
            {
                for y in 0...enemyToBeRemoved.count-1
                {
                    enemiesOnMap.remove(at: enemyToBeRemoved[y])
                }
                enemyToBeRemoved.removeAll()
            }
        }
        
        if (firstObj.categoryBitMask == PhyCat.Enemy && secondObj.categoryBitMask == PhyCat.Castle)
        {
            for x in 0...enemiesOnMap.count-1
            {
                if firstObj.node == enemiesOnMap[x].0
                {
                    if enemiesOnMap[x].1 > 0
                    {
                        townHealth -= enemiesOnMap[x].1
                    }
                    else
                    {
                        townHealth -= 1
                    }
                    enemiesOnMap[x].1 = 0
                }
            }
            
            for x in 0...enemiesOnMap.count-1
            {
                if enemiesOnMap[enemiesOnMap.count-1-x].1 == 0
                {
                    enemiesOnMap[enemiesOnMap.count-1-x].0.removeFromParent()
                    enemyToBeRemoved.append(enemiesOnMap.count-1-x)
                }
            }
            if !enemyToBeRemoved.isEmpty
            {
                for y in 0...enemyToBeRemoved.count-1
                {
                    enemiesOnMap.remove(at: enemyToBeRemoved[y])
                }
                enemyToBeRemoved.removeAll()
            }
        }
        else if (firstObj.categoryBitMask == PhyCat.Castle && secondObj.categoryBitMask == PhyCat.Enemy)
        {
            for x in 0...enemiesOnMap.count-1
            {
                if secondObj.node == enemiesOnMap[x].0
                {
                    if enemiesOnMap[x].1 > 0
                    {
                        townHealth -= enemiesOnMap[x].1
                    }
                    else
                    {
                        townHealth -= 1
                    }
                    enemiesOnMap[x].1 = 0
                }
            }
            for x in 0...enemiesOnMap.count-1
            {
                if enemiesOnMap[enemiesOnMap.count-1-x].1 == 0
                {
                    enemiesOnMap[enemiesOnMap.count-1-x].0.removeFromParent()
                    enemyToBeRemoved.append(enemiesOnMap.count-1-x)
                }
            }
            if !enemyToBeRemoved.isEmpty
            {
                for y in 0...enemyToBeRemoved.count-1
                {
                    enemiesOnMap.remove(at: enemyToBeRemoved[y])
                }
                enemyToBeRemoved.removeAll()
            }
        }
    }
    
    func gameWin()
    {
        if(self.townHealth >= 1)
        {
            print("Game Win")
            
            let messageDisplay = SKLabelNode()
            messageDisplay.text = "You WIN"
            messageDisplay.position = CGPoint(x: self.frame.size.width / 2 - 40, y: self.frame.size.height / 2 + self.frame.size.height / 4 - 50)
            messageDisplay.fontSize = 72
            messageDisplay.fontName = "Oetztype"
            
            messageDisplay.setScale(0)
            messageDisplay.zPosition = 10
            self.addChild(messageDisplay)
            
            messageDisplay.run(SKAction.scale(to: 1, duration: TimeInterval(0.5)))
            
            
            self.gameWinLooseDisplay()
        }
    }
    
    func gameLoose()
    {
        if(self.townHealth <= 0)
        {
            print("Game Loose")
            
            let messageDisplay = SKLabelNode()
            messageDisplay.text = "You Loose, Wanna Try Again?"
            messageDisplay.position = CGPoint(x: self.frame.size.width / 2 - 40, y: self.frame.size.height / 2 + self.frame.size.height / 4 - 50)
            messageDisplay.fontSize = 72
            messageDisplay.fontName = "Oetztype"
            
            messageDisplay.setScale(0)
            messageDisplay.zPosition = 10
            self.addChild(messageDisplay)
            
            messageDisplay.run(SKAction.scale(to: 1, duration: TimeInterval(0.5)))
            
            map.removeAllActions()
            self.removeAllActions()
            
            self.gameWinLooseDisplay()
        }
    }
    
    func gameWinLooseDisplay()
    {
        self.spawnTimer.invalidate()
        
        self.gameWinOrLoose = true
        
        let popUpMessage = SKNode()
        let popUpMessageBackground = SKSpriteNode(color: SKColor.gray, size: CGSize(width: 350, height: 70))
        let messageDisplay = SKLabelNode()
        
        popUpMessageBackground.position = CGPoint(x: self.frame.size.width / 2 - 40, y: self.frame.size.height / 2)
        popUpMessage.addChild(popUpMessageBackground)
        
        
        messageDisplay.text = "Gold: \(gold)"
        messageDisplay.position = CGPoint(x: self.frame.size.width / 2 - 40, y: self.frame.size.height / 2 - 20)
        messageDisplay.fontSize = 50
        messageDisplay.fontName = "Oetztype"
        popUpMessage.addChild(messageDisplay)
        popUpMessage.setScale(0)
        popUpMessage.zPosition = 10
        self.addChild(popUpMessage)
        popUpMessage.run(SKAction.scale(to: 1, duration: TimeInterval(0.5)))
        
        
        let restartMessage = SKNode()
        let restartMessageText = SKLabelNode()
        
        restartBtn = createButton()
        
        restartMessageText.text = "Play Again"
        restartMessageText.fontSize = 50
        restartMessageText.position = restartBtn.position
        restartMessageText.position.y -= 15
        restartMessageText.fontName = "Oetztype"
        
        restartMessage.addChild(restartBtn)
        restartMessage.addChild(restartMessageText)
        
        restartMessage.setScale(0)
        restartMessage.zPosition = 10
        self.addChild(restartMessage)
        restartMessage.run(SKAction.scale(to: 1, duration: TimeInterval(0.5)))
        
        
        let exitMessage = SKNode()
        let exitBtnText = SKLabelNode()
        
        exitBtn = createButton()
        exitBtn.position.x += 350
        
        exitBtnText.text = "Exit"
        exitBtnText.fontSize = 50
        exitBtnText.position = exitBtn.position
        exitBtnText.position.y -= 15
        exitBtnText.fontName = "Oetztype"
        
        exitMessage.addChild(exitBtn)
        exitMessage.addChild(exitBtnText)
        
        exitMessage.setScale(0)
        exitMessage.zPosition = 10
        self.addChild(exitMessage)
        exitMessage.run(SKAction.scale(to: 1, duration: TimeInterval(0.5)))
    }

    
    func createButton() -> SKSpriteNode
    {
        let button = SKSpriteNode(color: UIColor.gray, size: CGSize(width: 300, height: 70))
        button.position = CGPoint(x: self.frame.size.width / 2 - 170, y: self.frame.size.height / 2 - 100)
        
        return button
    }
    
    func createLabel()
    {
        goldLabel = SKLabelNode(text: "Gold: \(gold)")
        goldLabel.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2 + self.frame.size.height / 2.5)
        goldLabel.fontColor = SKColor.black
        goldLabel.fontSize = 50
        goldLabel.fontName = "Oetztype"
        goldLabel.zPosition = 10
        map.addChild(goldLabel)
        
        townHealthLabel = SKLabelNode(text: "Health: \(townHealth)")
        townHealthLabel.position = CGPoint(x: self.frame.size.width / 2 + self.frame.size.width / 2.5 - 20, y: self.frame.size.height / 2 + self.frame.size.height / 2.5)
        townHealthLabel.fontColor = SKColor.black
        townHealthLabel.fontSize = 50
        townHealthLabel.fontName = "Oetztype"
        townHealthLabel.zPosition = 10
        map.addChild(townHealthLabel)
    }
    
    func restartGame()
    {
        towersOnMap.removeAll()
        towersOnMapAt.removeAll()
        enemiesOnMap.removeAll()
        towerPosArray.removeAll()
        towerSelected.removeAll()
        enemyToBeRemoved.removeAll()
        
        self.removeAllChildren()
        self.removeAllActions()
        
        startGame()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        //Check if Player Lost
        if(!gameWinOrLoose)
        {
            //Update Gold Value and TownHealth value only if player has not lost
            goldLabel.text = "Gold: \(gold)"
            townHealthLabel.text = "Health: \(townHealth)"
            self.gameLoose()
        }
        
        if(!towersOnMap.isEmpty && !enemiesOnMap.isEmpty)
        {
            for i in 0...towersOnMap.count - 1
            {
                for j in 0...self.enemiesOnMap.count-1
                {
                    //let enemy = map.childNode(withName: "Orc1_\(self.numberOfEnemies-1-j)")
                    let enemy = enemiesOnMap[self.enemiesOnMap.count-1-j].0
                    let location = enemy.position
                    
                    //Aim
                    if(location != nil)
                    {
                        let dx = location.x - towersOnMap[i].position.x
                        let dy = location.y - towersOnMap[i].position.y
                        
                        let angle = atan2(dy, dx)
                        
                        towersOnMap[i].zRotation = angle - CGFloat(GLKMathDegreesToRadians(90))
                        break
                    }
        
                }
            }
        }
        
    }
}
