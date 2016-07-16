//
//  Wall.swift
//  OctGame
//
//  Created by zc on 16/7/14.
//  Copyright © 2016年 oct. All rights reserved.
//

import SpriteKit
import UIKit

class Wall: Building, FTCellStandAbleDelegate {
    var wallHP: Int = 5
    var wallSprite: SKSpriteNode!
    var entityName: String!
    var wallID: UInt32!
    var isControl: Bool!
    var hpLabel: SKLabelNode!
  //  var isRemove: Bool!
    init(entityName: String, collsionBitMask: UInt32, wallID: UInt32) {
        super.init()

        self.wallSprite = SKSpriteNode(imageNamed: "wall.jpg")
        self.wallSprite.size = SkillSize.wall
        self.wallSprite.physicsBody = SKPhysicsBody(rectangleOfSize: SkillSize.wall, center: CGPoint(x: 0.5, y: 0.5))
        self.wallSprite.physicsBody?.affectedByGravity = false
        self.wallSprite.physicsBody?.mass = 10
        self.wallSprite.physicsBody?.allowsRotation = false
        self.wallSprite.physicsBody?.categoryBitMask = BitMaskType.ftWall
        self.wallSprite.physicsBody?.collisionBitMask = collsionBitMask
        self.wallSprite.physicsBody?.contactTestBitMask = collsionBitMask
        self.wallSprite.physicsBody?.usesPreciseCollisionDetection = true
        self.wallSprite.physicsBody?.dynamic = false
        
        self.wallSprite.userData = NSMutableDictionary()
        
        self.wallSprite.userData?.setObject(self, forKey: "wallclass")
        
        
        self.hpLabel = SKLabelNode(fontNamed: "Arial")
        self.hpLabel.text = "\(wallHP)"
        self.hpLabel.fontSize = 12
        self.hpLabel.fontColor = UIColor.redColor()
        self.hpLabel.zPosition = SpriteLevel.fightStateUI.rawValue
        self.wallSprite.addChild(self.hpLabel)
        
        self.wallSprite.zPosition = SpriteLevel.sprite.rawValue+1
        self.isControl = true
        self.wallID = wallID
        self.entityName = entityName
      //  self.isRemove = false
        
    }
    
    func removeWall() -> Bool {
        if self.wallHP <= 0 {
            self.wallSprite.removeFromParent()
            return true
        }
        return false
    }
    
    func didBeHit(hitValue: Int) {
        self.wallHP  = self.wallHP - hitValue
        self.hpLabel.text = "\(wallHP)"
    }
}
