//
//  FenShen.swift
//  OctGame
//
//  Created by zc on 16/6/16.
//  Copyright © 2016年 oct. All rights reserved.
//

import UIKit
import SpriteKit

class FenShen: Entity {
    static var fenShenImageName = "zhujiao.png"
    var fenshenDirection:String!
    var sprite:SKSpriteNode {
        return (self.componentForClass(SpriteComponent.self)?.sprite)!
    }
    var zhushen:Player!
    
    var screenSize:CGSize!
    var direction:String! //false: left true: right
    var velocity = 0 as CGFloat {
        didSet {
            if let movement = self.componentForClass(MovementComponent.self) {
                if velocity > 0 {
                    // movement.toRight(velocity)
                    movement.velocity = velocity
                    self.direction = "right"
                } else {
                    // movement.toLeft(velocity)
                    movement.velocity = velocity
                    self.direction = "left"
                }
            }
        }
    }
    
    init(zhushen:Player,screenView:CGSize) {
        super.init()
        self.zhushen = zhushen
        self.screenSize = screenView
        let fenshen = SKSpriteNode(texture: zhushen.sprite.texture)
        fenshen.size = zhushen.sprite.size

        fenshen.name = "fenshen"
        fenshen.position.y = zhushen.sprite.position.y
        fenshen.zPosition = SpriteLevel.sprite.rawValue
        fenshen.physicsBody = SKPhysicsBody(rectangleOfSize: zhushen.sprite.size, center: CGPoint(x: 0.5, y: 0.5))
        fenshen.physicsBody?.affectedByGravity = false;
        fenshen.physicsBody?.mass = 10000;
        fenshen.physicsBody?.allowsRotation = false;
        fenshen.physicsBody?.categoryBitMask = BitMaskType.player
        fenshen.physicsBody?.collisionBitMask = BitMaskType.gold | BitMaskType.background | BitMaskType.player
        fenshen.physicsBody?.contactTestBitMask = BitMaskType.gold | BitMaskType.background
        self.addComponent(SpriteComponent(sprite: fenshen))
        self.addComponent(MovementComponent())
        self.addComponent(AnimationComponent())
    }
    
    override func updateWithDeltaTime(second: NSTimeInterval) {
        super.updateWithDeltaTime(second)
        self.sprite.position.y = zhushen.sprite.position.y
        if fenshenDirection == "right" {
            if zhushen.sprite.position.x >= (self.screenSize.width-zhushen.sprite.size.width*1.5) {
                self.sprite.position.x = self.screenSize.width-self.sprite.size.width/2
            }else {
                self.sprite.position.x = zhushen.sprite.position.x+zhushen.sprite.size.width
            }
        }else if fenshenDirection == "left"{
            if zhushen.sprite.position.x <= zhushen.sprite.size.width*1.5 {
                self.sprite.position.x = self.sprite.size.width/2
            }else {
                self.sprite.position.x = zhushen.sprite.position.x-zhushen.sprite.size.width
            }
        }
        self.componentForClass(AnimationComponent.self)?.state =  (zhushen.componentForClass(AnimationComponent.self)?.state)!
        
    }
    
    
}
