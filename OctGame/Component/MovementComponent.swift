//
//  MovementComponent.swift
//  OctGame
//
//  Created by zc on 16/6/14.
//  Copyright © 2016年 oct. All rights reserved.
//

import UIKit
import SpriteKit
enum Direction: Int {
    case Stop
    case Left
    case Right
    case Up
    case Down
    
    var key: String {
        switch self {
        case .Stop:
            return "stop"
        case .Left:
            return "left"
        case .Right:
            return "right"
        case .Up:
            return "up"
        case .Down:
            return "down"
        }
    }
    
   // static let all = [Stop]
}
class MovementComponent: Component {
    var velocity = 0 as CGFloat {
        didSet {
            if velocity > 0 {
                toRight(velocity)
            } else if velocity < 0 {
                toLeft(velocity)
            } else {
                stop()
            }
        }
    }
//    var dashFlag:String = ""
   // var isChangeSpeed:Bool = false
    var direction = Direction.Stop

    var sprite: SKSpriteNode {
        return (self.entity?.componentForClass(SpriteComponent.self)?.sprite)!
    }
    func stop() {
        if self.direction != Direction.Stop {
            self.sprite.removeActionForKey(self.direction.key)
        }
        self.direction = .Stop
    }
    func toLeft(var velocity: CGFloat) {
//        if dashFlag == "chongci" {
//            let leftt = SKAction.moveByX(velocity, y: 0, duration: 0.2)
//            self.sprite.runAction(leftt)
//            dashFlag = "buchongci"
//            return
//        }
        if velocity  <= -80 {
            let leftt = SKAction.moveByX(velocity, y: 0, duration: 0.2)
            self.sprite.runAction(leftt)
            return
        }
        if self.direction != .Left {
            self.sprite.removeActionForKey(self.direction.key)
            self.direction = .Left
            if ((self.entity?.hasComponent(LargenMinifyComponent.self))! == true) {
                let isBig = self.entity?.componentForClass(LargenMinifyComponent.self)?.isBig
                if isBig == true {
                    velocity = velocity/2
                }else {
                    velocity = velocity*2
                }
            }
            let left = SKAction.moveByX(velocity, y: 0, duration: 0.1)
            self.sprite.runAction(SKAction.repeatActionForever(left), withKey: self.direction.key)
        }

    }
    
    func toRight(var velocity: CGFloat) {
//        if dashFlag == "chongci" {
//            let rightt = SKAction.moveByX(velocity, y: 0, duration: 0.2)
//            self.sprite.runAction(rightt)
//            dashFlag = "buchongci"
//            return
//        }
        if velocity >= 80 {
            let rightt = SKAction.moveByX(velocity, y: 0, duration: 0.2)
            self.sprite.runAction(rightt)
            return
        }
        if self.direction != .Right {
            self.sprite.removeActionForKey(self.direction.key)
            self.direction = .Right
            if ((self.entity?.hasComponent(LargenMinifyComponent.self))! == true) {
                let isBig = self.entity?.componentForClass(LargenMinifyComponent.self)?.isBig
                if isBig == true {
                    velocity = velocity/2
                }else {
                   velocity = velocity*2
                }
            }
            let right = SKAction.moveByX(velocity, y: 0, duration: 0.1)
            self.sprite.runAction(SKAction.repeatActionForever(right), withKey: self.direction.key)
        }

    }
    
    
    override func didAddToEntity(entity: Entity) {
        self.entity = entity
    }
    
}
