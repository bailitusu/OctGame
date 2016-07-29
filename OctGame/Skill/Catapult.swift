//
//  Catapult.swift
//  OctGame
//
//  Created by zc on 16/7/29.
//  Copyright © 2016年 oct. All rights reserved.
//

import SpriteKit
import UIKit

class Catapult: SKSpriteNode {
    var entityName: String!
    var isControl: Bool!
    var catapultID: UInt32!
    var isRemove: Bool!
    var imageName: String = "toushiche.jpg"
    var miaoZhun: Bool = false
    var tagartPoint: CGPoint?
//    var dircspeed: CGVector! {
//
//        didSet {
//            self.physicsBody?.velocity = dircspeed
//        }
//        
//    }
    init(size: CGSize, entityName: String, catapultID: UInt32) {
        super.init(texture: SKTexture(imageNamed: imageName), color: UIColor.clearColor(), size: size)
        self.entityName = entityName
        self.isControl = true
        self.isRemove = false
        self.catapultID = catapultID
        self.zPosition = SpriteLevel.catapult.rawValue
//        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width/2, center: CGPoint(x: 0.5, y: 0.5))
//        self.physicsBody?.affectedByGravity = false
//        self.physicsBody?.mass = 10
//        self.physicsBody?.allowsRotation = false
//        self.physicsBody?.categoryBitMask = BitMaskType.toushiche
//        self.physicsBody?.collisionBitMask = BitMaskType.toushiche
//        self.physicsBody?.contactTestBitMask = BitMaskType.toushiche
//        self.physicsBody?.linearDamping = 0
    
    }
    

    func removeCatapult() -> Bool {
        if self.position.y <= SkillSize.catapult.height/2+1 || self.position.y >= screenSize.height-(SkillSize.huoqiu.height/2+1) || self.position.x <= SkillSize.catapult.width/2+1 || self.position.x >= screenSize.width-SkillSize.catapult.width/2-1{
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
