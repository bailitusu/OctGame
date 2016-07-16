//
//  Fire.swift
//  OctGame
//
//  Created by zc on 16/7/2.
//  Copyright © 2016年 oct. All rights reserved.
//

import SpriteKit
import UIKit

class Fire: SKSpriteNode {
    
   // weak var player: FightPlayer!
    
    var entityName: String!
    var isControl: Bool!
    var fireID:String!
    var collideCount: UInt32!
    var isRemove: Bool!
    
    var dircspeed: CGVector! {
//        if self.player.roleName == "fightplayer" {
//            
//        } else {
//            self.physicsBody?.velocity = ()
//        }
        didSet {
           self.physicsBody?.velocity = dircspeed
        }
        
    }
//
    
    
    
    init(imageName: String, size: CGSize, entityName: String, collsionBitMask: UInt32, fireID: String) {
        super.init(texture: SKTexture(imageNamed: imageName), color: UIColor.clearColor(), size: size)
        self.entityName = entityName
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width/2, center: CGPoint(x: 0.5, y: 0.5))
       // self.physicsBody = SKPhysicsBody(rectangleOfSize: size, center: CGPoint(x: 0.5, y: 0.5))
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.mass = 10
        self.physicsBody?.allowsRotation = true
        self.physicsBody?.categoryBitMask = BitMaskType.fire
        self.physicsBody?.collisionBitMask = collsionBitMask    //self.player.enemyCollsionBitMask
        self.physicsBody?.contactTestBitMask = collsionBitMask
        self.physicsBody?.linearDamping = 0
        self.physicsBody?.usesPreciseCollisionDetection = true

        self.zPosition = SpriteLevel.sprite.rawValue+1
        self.fireID = fireID
        self.isControl = true
        self.collideCount = 0
        self.isRemove = false
    }
    
    func removeFire() -> Bool {
        if self.position.y <= SkillSize.huoqiu.height/2+10 || self.position.y >= screenSize.height-(SkillSize.huoqiu.height/2+10) {
            self.removeFromParent()
            return true
        }
        if collideCount >= FightSkillCollideMaxCount.huoqiu {
            collideCount = 0
            self.removeFromParent()
            return true
        }
        if self.isRemove == true {
            self.removeFromParent()
            return true
        }
        return false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
