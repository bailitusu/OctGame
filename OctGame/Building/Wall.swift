//
//  Wall.swift
//  OctGame
//
//  Created by zc on 16/7/14.
//  Copyright © 2016年 oct. All rights reserved.
//

import SpriteKit
import UIKit

class Wall: Building, FTCellStandAbleDelegate,SaveSkillProtocal {
    var HP: Int = 5
//    var wallSprite: SKSpriteNode!
//    var entityName: String!
//    var wallID: UInt32!
//    var isControl: Bool!
    var isRemove: Bool!
    
    var skillPosition: CGPoint? {
        didSet {
            self.buildSprite.position = skillPosition!
        }
    }
    var hpLabel: SKLabelNode!
  //  var isRemove: Bool!
    init(entityName: String, collsionBitMask: UInt32, wallID: UInt32) {
        super.init()

        self.buildSprite = SKSpriteNode(imageNamed: "wall.jpg")
        self.buildSprite.size = SkillSize.building
        self.buildSprite.physicsBody = SKPhysicsBody(rectangleOfSize: SkillSize.building, center: CGPoint(x: 0.5, y: 0.5))
        self.buildSprite.physicsBody?.affectedByGravity = false
        self.buildSprite.physicsBody?.mass = 10
        self.buildSprite.physicsBody?.allowsRotation = false
        self.buildSprite.physicsBody?.categoryBitMask = BitMaskType.ftWall
        self.buildSprite.physicsBody?.collisionBitMask = collsionBitMask
        self.buildSprite.physicsBody?.contactTestBitMask = collsionBitMask
        self.buildSprite.physicsBody?.usesPreciseCollisionDetection = true
        self.buildSprite.physicsBody?.dynamic = false
        
        self.buildSprite.userData = NSMutableDictionary()
        
        self.buildSprite.userData?.setObject(self, forKey: "wallclass")
        
        
        self.hpLabel = SKLabelNode(fontNamed: "Arial")
        self.hpLabel.text = "\(HP)"
        self.hpLabel.fontSize = 12
        self.hpLabel.fontColor = UIColor.redColor()
        self.hpLabel.zPosition = SpriteLevel.fightStateUI.rawValue
        self.buildSprite.addChild(self.hpLabel)
        
        self.buildSprite.zPosition = SpriteLevel.sprite.rawValue+1
        self.isControl = true
        self.buildID = wallID
        self.entityName = entityName
        self.isRemove = false
      //  self.isRemove = false
        
    }
    
    func getEntityName() -> String {
        return self.entityName
    }
    
    func removeWall() -> Bool {
        if self.HP <= 0 {
            self.buildSprite.removeFromParent()
            return true
        }
        return false
    }
    func removeItem() {
        self.isRemove = true
    }
    func didBeHit(hitValue: Int) {
        self.HP  = self.HP - hitValue
        self.hpLabel.text = "\(HP)"
    }
}
