//
//  Boom.swift
//  OctGame
//
//  Created by zc on 16/7/8.
//  Copyright © 2016年 oct. All rights reserved.
//

import Foundation
import SpriteKit

class Boom: SKSpriteNode {
    var entityName: String!
    var isControl: Bool!
    var boomID:String!
    var collideCount: UInt32!
    var isRemove: Bool!
    var boomOnMapCellIndex: Int?
    
    init(imageName: String, size: CGSize, entityName: String, collsionBitMask: UInt32, BoomID: String) {
        super.init(texture: SKTexture(imageNamed: imageName), color: UIColor.clearColor(), size: size)
        self.entityName = entityName
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width/2, center: CGPoint(x: 0.5, y: 0.5))
        // self.physicsBody = SKPhysicsBody(rectangleOfSize: size, center: CGPoint(x: 0.5, y: 0.5))
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.mass = 10
        self.physicsBody?.allowsRotation = true
        self.physicsBody?.categoryBitMask = BitMaskType.boom
        self.physicsBody?.collisionBitMask = collsionBitMask    //self.player.enemyCollsionBitMask
        self.physicsBody?.contactTestBitMask = collsionBitMask
        self.physicsBody?.linearDamping = 0
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.dynamic = false
        self.zPosition = SpriteLevel.sprite.rawValue+1
        self.boomID = BoomID
        self.isControl = true
        self.collideCount = 0
        self.isRemove = false
    }

    
    func removeBoom() -> Bool{
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



//extension Boom: FTCellStandAbleDelegate {
//    func didBeHit(hitValue: Int) {
//        if hitValue == -1 {
//            
//        }
//    }
//}

















