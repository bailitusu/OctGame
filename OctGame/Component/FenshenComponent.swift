//
//  FenshenComponent.swift
//  OctGame
//
//  Created by zc on 16/6/15.
//  Copyright © 2016年 oct. All rights reserved.
//

import UIKit
import SpriteKit

class FenshenComponent:Component {
  //  var screenSize:CGSize!
    var fenshen:FenShen!
  //  var fenshenDirection:String!
    var duration:NSTimeInterval!
    var sprite:SKSpriteNode {
        return (self.entity?.componentForClass(SpriteComponent.self)?.sprite)!
    }
    var movement:MovementComponent!
    init(screenSize:CGSize,fenShen fenshen:FenShen,duration time:NSTimeInterval) {
        super.init()
     //   self.screenSize = screenSize
        self.fenshen = fenshen
        self.duration = time
    }
    func addFenShen() {
//        fenshen = SKSpriteNode(imageNamed: "zhujiao.png")
//        fenshen.size = sprite.size
//        if sprite.position.x >= screenSize.width/2 {
//            fenshenDirection = "left"
//            fenshen.position.x = sprite.position.x-sprite.size.width-4
//        }else {
//            fenshenDirection = "right"
//            fenshen.position.x = sprite.position.x+sprite.size.width*1.5
//        }
//        fenshen.position.y = sprite.position.y
//        fenshen.zPosition = SpriteLevel.sprite.rawValue
//        fenshen.physicsBody = SKPhysicsBody(rectangleOfSize: sprite.size, center: CGPoint(x: 0.5, y: 0.5))
//        fenshen.physicsBody?.affectedByGravity = false;
//        fenshen.physicsBody?.mass = 10000;
//        fenshen.physicsBody?.allowsRotation = false;
//        fenshen.physicsBody?.categoryBitMask = BitMaskType.player
//        fenshen.physicsBody?.collisionBitMask = BitMaskType.gold | BitMaskType.background | BitMaskType.player
//        fenshen.physicsBody?.contactTestBitMask = BitMaskType.gold | BitMaskType.background
//        sprite.parent?.addChild(fenshen)

//        fenshen.addComponent(SpriteComponent(sprite: fenshen.sprite))
//        fenshen.addComponent(MovementComponent())
    }
    override func willAddToEntity(entity: Entity) {
        if entity.hasComponent(FenshenComponent.self) == true {
            entity.removeComponent(FenshenComponent.self)
        }
    }
    override func didAddToEntity(entity: Entity) {
        if entity.hasComponent(FenshenComponent.self) == true {
            self.sprite.removeActionForKey("fenshen")
        }
        movement = entity.componentForClass(MovementComponent.self)
        let wait = SKAction.waitForDuration(self.duration)
        let block = SKAction.runBlock { () -> Void in
            self.fenshen.sprite.removeFromParent()
            entity.removeComponent(FenshenComponent.self)
        }
        self.sprite.runAction(SKAction.sequence([wait,block]),withKey: "fenshen")
       // addFenShen()
    }
    
    override func updateWithDeltaTime(second: NSTimeInterval) {
//        if fenshenDirection == "right" {
//            fenshen.position.x = sprite.position.x+sprite.size.width*1.5
//        }else if fenshenDirection == "left"{
////            if fenshen.position.x <= fenshen.size.width/2 {
////                return
////            }
//            fenshen.position.x = max(sprite.position.x-sprite.size.width-4, 0)
//        }
        fenshen.velocity = movement.velocity
    }
}
