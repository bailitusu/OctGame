//
//  Bullte.swift
//  OctGame
//
//  Created by zc on 16/7/30.
//  Copyright © 2016年 oct. All rights reserved.
//

import SpriteKit
import UIKit

class Bullte: SKSpriteNode {
    var image = "bullet.png"
    var entityName: String!
    var defaulVelocity: CGVector?
    init(entityName: String) {
        super.init(texture: SKTexture(imageNamed: image), color: UIColor.clearColor(), size: SkillSize.zidan)
        self.entityName = entityName
        self.size = SkillSize.zidan
        self.physicsBody = SKPhysicsBody(rectangleOfSize: SkillSize.zidan, center: CGPoint(x: 0.5, y: 0.5))
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.mass = 1
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = BitMaskType.bullet
        self.physicsBody?.collisionBitMask = BitMaskType.fightEnemy | BitMaskType.fightSelf
        self.physicsBody?.contactTestBitMask = BitMaskType.fightEnemy | BitMaskType.fightSelf
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.zPosition = SpriteLevel.bullte.rawValue
        self.name = "zidan"
        // zidan.physicsBody?.dynamic = true
      //  BitMaskType.ftSlow | BitMaskType.ftWall | BitMaskType.ftJianTower |
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
