//
//  MoveComponent.swift
//  OctGame
//
//  Created by zc on 16/6/21.
//  Copyright © 2016年 oct. All rights reserved.
//

import Foundation
import SpriteKit
enum SpriteDirection {
    case Stop
    case Left
    case Right
    case Up
    case Down
}
class MoveComponent: Component {

    
    var speed = 0 as CGFloat {
        didSet {
//            if abs(self.speed) >= VelocityType.velocityMax {
//                if self.speed < 0 {
//                    self.speed = -VelocityType.velocityMax
//                }else {
//                    self.speed = VelocityType.velocityMax
//                }
//                
//            }
            self.sprite.removeActionForKey("move")
            if speed > 0 {
//                if speed  >= VelocityType.playerVelocity*2 {
//                    self.toRightChongci(speed)
//                }else {
//                    toRight(speed)
//                }
                toRight(speed)
            } else if speed < 0 {
//                if speed  <= -VelocityType.playerVelocity*2 {
//                    self.toLeftChongci(speed)
//                }else {
//                    toLeft(speed)
//                }
                toLeft(speed)
            } else {
                stop()
            }
        }
    }
    var sprite: SKSpriteNode {
        return (self.entity?.componentForClass(SpriteComponent.self)?.sprite)!
    }
    var direction: SpriteDirection = SpriteDirection.Stop
    
    override func didAddToEntity(entity: Entity) {
        self.entity = entity
    }
    
    func stop() {
//        self.sprite.removeActionForKey("move")
        self.direction = .Stop
//        self.sprite.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
//        
//        self.direction = .Stop
    }
    
    func toLeftChongci(valocity: CGFloat) {
        var tempSpeed: CGFloat = 0
        if abs(valocity) >= VelocityType.velocityMax {
            tempSpeed = -VelocityType.velocityMax
        }else {
            tempSpeed = valocity
        }
        let leftt = SKAction.moveByX(tempSpeed, y: 0, duration: 0.1)
        let block = SKAction.runBlock { () -> Void in
//            if abs(valocity) >= VelocityType.velocityMax {
//                self.toLeft(self.speed/2)
//            }else {
                self.toLeft(valocity/3)
          //  }
            
        }
        self.sprite.runAction(SKAction.sequence([leftt,block]),withKey: "move")
  
    }
    
    func toRightChongci(valocity: CGFloat) {
        var tempSpeed: CGFloat = 0
        if abs(valocity) >= VelocityType.velocityMax {
            tempSpeed = VelocityType.velocityMax
        }else {
            tempSpeed = valocity
        }
        
        let rightt = SKAction.moveByX(tempSpeed, y: 0, duration: 0.1)
        let block = SKAction.runBlock { () -> Void in
            self.toRight(valocity/3)
        }
        self.sprite.runAction(SKAction.sequence([rightt,block]),withKey: "move")

    }
    
    func toLeft(var valocity: CGFloat) {

        self.direction = SpriteDirection.Left
//        if ((self.entity?.hasComponent(LargenMinifyComponent.self))! == true) {
//            let isBig = self.entity?.componentForClass(LargenMinifyComponent.self)?.isBig
//            if isBig == true {
//                valocity = valocity/2
//            }else {
//                valocity = valocity*2
//            }
//        }
       // self.sprite.physicsBody?.velocity = CGVector(dx: valocity, dy: 0)
        if abs(valocity) >= VelocityType.velocityMax {
            valocity = -VelocityType.velocityMax
        }
        
        
        let left = SKAction.moveByX(valocity, y: 0, duration: 0.1)
        self.sprite.runAction(SKAction.repeatActionForever(left), withKey: "move")
    }
    
    func toRight(var velocity: CGFloat) {
        self.direction = SpriteDirection.Right
//        if ((self.entity?.hasComponent(LargenMinifyComponent.self))! == true) {
//            let isBig = self.entity?.componentForClass(LargenMinifyComponent.self)?.isBig
//            if isBig == true {
//                velocity = velocity/2
//            }else {
//                velocity = velocity*2
//            }
//        }
       // self.sprite.physicsBody?.velocity = CGVector(dx: velocity, dy: 0)
        
        if abs(velocity) >= VelocityType.velocityMax {
            velocity = VelocityType.velocityMax
        }
        
        let right = SKAction.moveByX(velocity, y: 0, duration: 0.1)
        self.sprite.runAction(SKAction.repeatActionForever(right), withKey: "move")
    }
}