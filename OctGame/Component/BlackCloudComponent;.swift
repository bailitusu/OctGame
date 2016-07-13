//
//  BlackCloudComponent;.swift
//  OctGame
//
//  Created by zc on 16/6/15.
//  Copyright © 2016年 oct. All rights reserved.
//

import UIKit
import SpriteKit

class BlackCloudComponent: Component {
    var sprite: SKSpriteNode {
        return (self.entity?.componentForClass(SpriteComponent.self)?.sprite)!
    }
    var duration:NSTimeInterval!
  //  var screenSize:CGSize!
    var cloud:SKSpriteNode!
    
    var direction:Direction!
    init(duration:NSTimeInterval) {
        super.init()
        self.duration = duration
  //      self.screenSize = size
    }
    override func willAddToEntity(entity: Entity) {
        if entity.hasComponent(BlackCloudComponent.self) == true {
            
            entity.componentForClass(BlackCloudComponent.self)?.cloud.removeFromParent()
            
//            cloud.removeFromParent()
            entity.removeComponent(BlackCloudComponent.self)
        }
    }
    override func didAddToEntity(entity: Entity) {
      //  if entity.hasComponent(BlackCloudComponent.self) == true {
            self.sprite.removeActionForKey("blackcloud")
       // }
            addBlockCloud()
        
        let wait = SKAction.waitForDuration(duration)
        let block = SKAction.runBlock { () -> Void in
            self.cloud.removeFromParent()
            self.entity?.removeComponent(BlackCloudComponent.self)
        }
        self.sprite.runAction(SKAction.sequence([wait,block]), withKey: "blackcloud")
    
    }
    func addBlockCloud() {
        
        cloud = SKSpriteNode(imageNamed: "dawuyun")
        cloud.size = cloudSize
//        cloud.physicsBody = SKPhysicsBody(rectangleOfSize: cloud.size, center: CGPoint(x: 0.5, y: 0.5))
//        cloud.physicsBody?.affectedByGravity = false
//        cloud.physicsBody?.mass = 10000
//        cloud.physicsBody?.allowsRotation = false
//        cloud.physicsBody?.categoryBitMask = BitMaskType.dawuyun
//        cloud.physicsBody?.collisionBitMask = BitMaskType.dawuyun
//        cloud.physicsBody?.contactTestBitMask = BitMaskType.dawuyun
//        cloud.physicsBody?.fieldBitMask = 0
        cloud.zPosition = SpriteLevel.dawuyun.rawValue
        
        
        self.sprite.parent?.addChild(cloud)
        cloud.position = CGPoint(x: screenSize.width/2-screenSize.width*0.3, y: screenSize.height/2)
        
        self.direction = .Right
        let right = SKAction.moveByX(20, y: 0, duration: 0.1)
        cloud.runAction(SKAction.repeatActionForever(right), withKey: self.direction.key)
    }
    
    override func updateWithDeltaTime(second: NSTimeInterval) {
        
        if cloud != nil {
            if cloud.position.x <= screenSize.width / 4 {
                if self.direction != .Right {
                    cloud.removeActionForKey(direction.key)
                    self.direction = .Right
                    let right = SKAction.moveByX(20, y: 0, duration: 0.1)
                    cloud.runAction(SKAction.repeatActionForever(right), withKey: self.direction.key)
                }
            }else if cloud.position.x >= screenSize.width * 3 / 4 {
                if self.direction != .Left {
                    cloud.removeActionForKey(direction.key)
                    self.direction = .Left
                    let left = SKAction.moveByX(-20, y: 0, duration: 0.1)
                    cloud.runAction(SKAction.repeatActionForever(left), withKey: self.direction.key)
                }
            }
            
        }
    }
}
