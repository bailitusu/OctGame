//
//  HaltComponent.swift
//  OctGame
//
//  Created by zc on 16/6/15.
//  Copyright © 2016年 oct. All rights reserved.
//

import UIKit
import SpriteKit

class HaltComponent: Component {
    var duration:NSTimeInterval!
    var sprite:SKSpriteNode {
        return (self.entity?.componentForClass(SpriteComponent.self)?.sprite)!
    }
    var veloctity:CGFloat!
    init(duration:NSTimeInterval) {
        super.init()
        self.duration = duration
    }
    override func willAddToEntity(entity: Entity) {
        if entity.hasComponent(HaltComponent.self) == true {
           // self.sprite.removeActionForKey("halt")
            entity.removeComponent(HaltComponent.self)
        }
    }
    override func didAddToEntity(entity: Entity) {
        if entity.hasComponent(HaltComponent.self) == true {
            self.sprite.removeActionForKey("halt")
        }
//        let movement = self.entity?.componentForClass(MovementComponent.self)
//        self.veloctity = movement?.velocity
//        movement?.stop()
//        let move = self.entity?.componentForClass(MovementComponent.self)
//        move?.direction = .Stop
        let anmition = self.entity?.componentForClass(AnimationComponent.self)
        let wait = SKAction.waitForDuration(duration)
        let block = SKAction.runBlock { () -> Void in
           // self.entity?.addComponent(MovementComponent())
            anmition?.state = .none
            self.entity?.removeComponent(HaltComponent.self)

            //movement?.velocity = self.veloctity
        }
        self.sprite.runAction(SKAction.sequence([wait,block]),withKey: "halt")
    }
}
