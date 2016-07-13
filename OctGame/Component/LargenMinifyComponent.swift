//
//  LargenMinifyComponent.swift
//  OctGame
//
//  Created by zc on 16/6/15.
//  Copyright © 2016年 oct. All rights reserved.
//

import UIKit
import SpriteKit

class LargenMinifyComponent: Component {
    var isBig:Bool!
    var duration:NSTimeInterval!
    var defaultSpeed:CGFloat!
//    var speed:CGFloat!
    var sprite: SKSpriteNode {
        return (self.entity?.componentForClass(SpriteComponent.self)?.sprite)!
    }
    
    init(isBig:Bool,duration time:NSTimeInterval) {
        super.init()
        self.isBig = isBig
        self.duration = time
//        self.defaultSpeed = ds
//        self.speed = velocity
        
        
    }
    
    override func willAddToEntity(entity: Entity) {
    //    print("willAddToEntity \(entity.componentForClass(LargenMinifyComponent.self)?.sprite.zRotation)")
        if entity.hasComponent(LargenMinifyComponent.self) == true {
          //  self.sprite.removeActionForKey("change")
            entity.removeComponent(LargenMinifyComponent.self)
        }
    }
    
    
    override func didAddToEntity(entity: Entity) {
      //  print("didaddtoEntity \(self.sprite.zRotation)")
        self.sprite.removeActionForKey("change")
        LargenMinify()        
    }
    
    func LargenMinify() {
//        let movement = self.entity?.componentForClass(MovementComponent.self)
//        self.defaultSpeed = movement?.velocity
        var scale:CGFloat = 1
        if let temp = self.entity as? Player {

            if self.isBig == true {
                scale = 1.5
                if temp.componentForClass(MoveComponent.self)?.direction == SpriteDirection.Left {
                    temp.velocity = -VelocityType.playerVelocity/1.2
                }else if temp.componentForClass(MoveComponent.self)?.direction == SpriteDirection.Right{
                    temp.velocity = VelocityType.playerVelocity/1.2
                }
            }else {
                scale = 0.5
                if temp.componentForClass(MoveComponent.self)?.direction == SpriteDirection.Left {
                    temp.velocity = -VelocityType.playerVelocity*1.2
                }else if temp.componentForClass(MoveComponent.self)?.direction == SpriteDirection.Right{
                    temp.velocity = VelocityType.playerVelocity*1.2
                }
              //  temp.velocity = temp.velocity*1.5
            }
        }
        let change = SKAction.scaleTo(scale, duration: 0.8)
        let wait = SKAction.waitForDuration(self.duration)
        let nolmal = SKAction.scaleTo(1, duration: 0.8)
        let block = SKAction.runBlock{ () -> Void in
//            movement?.isChangeSpeed = true
//            movement?.velocity = self.defaultSpeed
//            movement?.isChangeSpeed = false
//            if self.isBig == true {
//                movement?.velocity = (movement?.velocity )! * 2
//            }else {
//                movement?.velocity = (movement?.velocity)! / 2
//            }

            self.entity?.removeComponent(LargenMinifyComponent.self)
        }
        
        
        self.sprite.runAction(SKAction.sequence([change,wait,nolmal,block]), withKey: "change")
//        movement?.isChangeSpeed = true
//        movement?.velocity = self.speed
//        movement?.isChangeSpeed = false
    }
    
    override func willRemoveFromEntity(entity: Entity) {
        let nolmal = SKAction.scaleTo(1, duration: 0.8)
        self.sprite.runAction(nolmal)
        if let temp = self.entity as? Player {
            if temp.componentForClass(MoveComponent.self)?.direction == SpriteDirection.Left {
                temp.velocity = -VelocityType.playerVelocity
            }else if temp.componentForClass(MoveComponent.self)?.direction == SpriteDirection.Right{
                temp.velocity = VelocityType.playerVelocity
            }
        }
    }
    
//    override func updateWithDeltaTime(second: NSTimeInterval) {
//        if self.sprite.position.y != self.sprite.size.height/2 {
//            self.sprite.position = CGPoint(x: self.sprite.position.x, y: self.sprite.size.height/2)
//        }
//    }
}

