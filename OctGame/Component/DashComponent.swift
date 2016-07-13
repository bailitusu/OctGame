//
//  DashComponent.swift
//  OctGame
//
//  Created by zc on 16/6/15.
//  Copyright © 2016年 oct. All rights reserved.
//

import UIKit
import SpriteKit

class DashComponent: Component {
//    var duration:NSTimeInterval!
//    var originVelocity:CGFloat!
//    var movement:Component!
    var sprite: SKSpriteNode {
        return (self.entity?.componentForClass(SpriteComponent.self)?.sprite)!
    }

    override func didAddToEntity(entity: Entity) {
//        if entity.hasComponent(DashComponent.self) {
//            self.sprite.removeActionForKey("dash")
//        }
//      //  self.movement = entity.componentForClass(MovementComponent.self)
//        dash()
    }
//    func dash() {
//        let wait = SKAction.waitForDuration(duration)
//        let block = SKAction.runBlock { () -> Void in
//            self.entity?.removeComponent(DashComponent.self)
//            if let player = self.entity {
//                if let realPlayer = player as? Player  {
//                    realPlayer.velocity = self.originVelocity
//                }
//            }
//        }
//        self.sprite.runAction(SKAction.sequence([wait,block]),withKey: "dash")
//    }
//    func getSpeed(velocity:CGFloat){
//        self.originVelocity = velocity
//    }
//    
//    deinit {
//        
//    }
    
}