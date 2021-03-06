//
//  JianTower.swift
//  OctGame
//
//  Created by zc on 16/7/25.
//  Copyright © 2016年 oct. All rights reserved.
//

import SpriteKit
import UIKit

class  JianTower: Building, FTCellStandAbleDelegate,SaveSkillProtocal {
    var HP: Int = 3
    var skillPosition: CGPoint?{
        didSet{
            self.buildSprite.position = skillPosition!
        }
    }
    var isRemove: Bool!
    var hpLabel: SKLabelNode!
    init(entityName: String, collsionBitMask: UInt32, buildID: UInt32) {
        super.init()
        
        self.buildSprite = SKSpriteNode(imageNamed: "jianTower.png")
        self.buildSprite.size = SkillSize.building
        self.buildSprite.physicsBody = SKPhysicsBody(rectangleOfSize: SkillSize.building, center: CGPoint(x: 0.5, y: 0.5))
        self.buildSprite.physicsBody?.affectedByGravity = false
        self.buildSprite.physicsBody?.mass = 10
        self.buildSprite.physicsBody?.allowsRotation = false
        self.buildSprite.physicsBody?.categoryBitMask = BitMaskType.ftJianTower
        self.buildSprite.physicsBody?.collisionBitMask = collsionBitMask
        self.buildSprite.physicsBody?.contactTestBitMask = collsionBitMask
        self.buildSprite.physicsBody?.usesPreciseCollisionDetection = true
        self.buildSprite.physicsBody?.dynamic = false
        
        self.buildSprite.userData = NSMutableDictionary()
        
        self.buildSprite.userData?.setObject(self, forKey: "towerclass")
        
        
        self.hpLabel = SKLabelNode(fontNamed: "Arial")
        self.hpLabel.text = "\(HP)"
        self.hpLabel.fontSize = 12
        self.hpLabel.fontColor = UIColor.redColor()
        self.hpLabel.zPosition = SpriteLevel.fightStateUI.rawValue
        self.buildSprite.addChild(self.hpLabel)
        
        self.buildSprite.zPosition = SpriteLevel.sprite.rawValue+1
        self.isControl = true
        self.buildID = buildID
        self.entityName = entityName
        self.isRemove = false
        
    }
    func createZidan() -> Bullte {
//        let zidan = SKSpriteNode(imageNamed: "bullet.png")
//        zidan.size = SkillSize.zidan
//        zidan.physicsBody = SKPhysicsBody(rectangleOfSize: SkillSize.zidan, center: CGPoint(x: 0.5, y: 0.5))
//        zidan.physicsBody?.affectedByGravity = false
//        zidan.physicsBody?.mass = 1
//        zidan.physicsBody?.allowsRotation = false
//        zidan.physicsBody?.categoryBitMask = BitMaskType.bullet
//        zidan.physicsBody?.collisionBitMask = BitMaskType.ftWall | BitMaskType.ftJianTower | BitMaskType.fightEnemy | BitMaskType.fightSelf
//        zidan.physicsBody?.contactTestBitMask = BitMaskType.ftWall | BitMaskType.ftJianTower | BitMaskType.fightEnemy | BitMaskType.fightSelf
//        zidan.physicsBody?.usesPreciseCollisionDetection = true
//        zidan.zPosition = SpriteLevel.bullte.rawValue
//       // zidan.physicsBody?.dynamic = true
//        zidan.name = entityName
        let zidan = Bullte(entityName: self.entityName)
        
        return zidan
    }
    func removeTower() -> Bool {
        if self.HP <= 0 {
            self.buildSprite.removeActionForKey("zidan")
            self.buildSprite.removeFromParent()
            
            return true
        }
        return false
    }
    
    func getEntityName() -> String {
        return self.entityName
    }
    
    func removeItem() {
        self.isRemove = true
    }
    func didBeHit(hitValue: Int) {
        self.HP  = self.HP - hitValue
        self.hpLabel.text = "\(HP)"
    }
}
