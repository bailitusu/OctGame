//
//  Enemy.swift
//  OctGame
//
//  Created by zc on 16/6/27.
//  Copyright © 2016年 oct. All rights reserved.
//

import SpriteKit
import UIKit

class Enemy: Entity {
    static var enemyImageName = "enemy.jpg"
    var sprite: SKSpriteNode {
        return (self.componentForClass(SpriteComponent.self)?.sprite)!
    }
    
    var velocity = 0 as CGFloat {
        didSet {
            if let movement = self.componentForClass(MoveComponent.self) {
                if velocity > 0 {
                    movement.toRight(velocity)
                }else {
                    movement.toLeft(velocity)
                }
            }
        }
    }
    
    override init() {
        super.init()
        let sprite = SKSpriteNode(imageNamed: Enemy.enemyImageName)
        sprite.size = enemySize
        sprite.physicsBody = SKPhysicsBody(rectangleOfSize: sprite.size, center: CGPoint(x: 0.5, y: 0.5))
        sprite.physicsBody?.affectedByGravity = false
        sprite.physicsBody?.allowsRotation = false
        sprite.physicsBody?.mass = 1
        sprite.zPosition = SpriteLevel.sprite.rawValue
        sprite.alpha = 0
        self.addComponent(SpriteComponent(sprite: sprite))
        self.addComponent(MoveComponent())
    }
    
//    func start() {
//        self.velocity = -VelocityType.enemyVelocity
//    }
    
    func throwBadProp() {
        let propType = arc4random()%2
      //  let propType = 1
        var imageName:String!
        var bitMask:UInt32!
        switch propType {
        case 0:
            imageName = ProductType.boom.rawValue
            bitMask = BitMaskType.boom
            break
        case 1:
            imageName = ProductType.dingShen.rawValue
            bitMask = BitMaskType.dingShen
            break
        default:
//            imageName = ProductType.boom.rawValue
//            bitMask = BitMaskType.boom
            break
        }
        let prop = CreateProduct.createProp(imageName,BitMask: bitMask)
        prop.position = CGPoint(x: self.sprite.position.x, y: self.sprite.position.y-self.sprite.size.height/2-prop.size.height/2)
        prop.zPosition = SpriteLevel.sprite.rawValue

        prop.physicsBody?.fieldBitMask = 0
        self.sprite.parent?.addChild(prop)
    }
    
    func disappear() {
        let enemyPosition = CommonFunc.createRandomNum(UInt32(screenSize.width/6), Max: UInt32(screenSize.width*5/6))
       // let enemyPosition = screenSize.width-self.sprite.size.width/2
        self.sprite.position.x = CGFloat(enemyPosition)
        let appear = SKAction.fadeAlphaTo(1, duration: 0.3)
        let throwProp = SKAction.performSelector(#selector(Enemy.throwBadProp), onTarget: self)
//        let block = SKAction.runBlock { [unowned self] () -> Void in
//            self.sprite.alpha = 0
//        }
        let disappear = SKAction.fadeAlphaTo(0, duration: 0.2)
        self.sprite.runAction(SKAction.sequence([appear,throwProp,disappear]), withKey: "badProp")
    }
}
