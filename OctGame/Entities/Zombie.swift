//
//  Zombie.swift
//  OctGame
//
//  Created by zc on 16/6/14.
//  Copyright © 2016年 oct. All rights reserved.
//

import UIKit
import SpriteKit

class Zombie: Entity {
    static var zombieImageName = "laodaoshi.png"
    //var isDirectionLeft = true
    let screenView: CGSize!
//    var gold:SKSpriteNode!
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
    
    init(screenView:CGSize) {
        
        self.screenView = screenView
        super.init()
     
        let sprite = SKSpriteNode(imageNamed: Zombie.zombieImageName)
        sprite.size = enemySize
        sprite.physicsBody = SKPhysicsBody(rectangleOfSize: sprite.size,center: CGPoint(x: 0.5, y: 0.5))
        sprite.physicsBody?.affectedByGravity = false
        sprite.physicsBody?.allowsRotation = false
        sprite.physicsBody?.mass = 1
        sprite.zPosition = SpriteLevel.sprite.rawValue
        self.addComponent(SpriteComponent(sprite: sprite))
        self.addComponent(MoveComponent())
       
    }
    

//    override func updateWithDeltaTime(second: NSTimeInterval) {
//        if self.sprite.position.x <= self.screenView.width / 6 {
//            self.velocity = VelocityType.enemyVelocity
//        }else if self.sprite.position.x >= self.screenView.width * 5 / 6 {
//            self.velocity = -VelocityType.enemyVelocity
//        }
//    }
    
    func start() {
        self.velocity = VelocityType.enemyVelocity
        let createGold = SKAction.performSelector(#selector(Zombie.startCreateGold), onTarget: self)
        let wait = SKAction.waitForDuration(0.3)
        self.sprite.runAction(SKAction.repeatActionForever(SKAction.sequence([createGold,wait])), withKey: "gold")
        
    }
    
    func createProduct() {
        let type = arc4random()%6+1
        // let type = 4
        var imageName:String!
        var bitMask:UInt32!
        switch type {
        case 1:
            imageName = ProductType.changeSmall.rawValue
            bitMask = BitMaskType.changeSmall
            break
        case 2:
            imageName = ProductType.changeBig.rawValue
            bitMask = BitMaskType.changeBig
            break
            //        case 5:
            //            imageName = ProductType.jiasu.rawValue
            //            bitMask = BitMaskType.jiasu
            //            break
        case 3:
            imageName = ProductType.magnet.rawValue
            bitMask = BitMaskType.magnet
            break
        case 4:
            imageName = ProductType.wudi.rawValue
            bitMask = BitMaskType.wudi
            break
        case 5:
            //            imageName = ProductType.fenshen.rawValue
            //            bitMask = BitMaskType.fenshen
            imageName = ProductType.wudi.rawValue
            bitMask = BitMaskType.wudi
            break
        case 6:
            imageName = ProductType.wuyun.rawValue
            bitMask = BitMaskType.wuyun
            break
        default:
            break
        }
        let prop = CreateProduct.createProp(imageName,BitMask: bitMask)
        prop.position = CGPoint(x: self.sprite.position.x, y: self.sprite.position.y-self.sprite.size.height/2-prop.size.height/2)
        prop.zPosition = SpriteLevel.sprite.rawValue
        //        if imageName == ProductType.boom.rawValue {
        //            prop.physicsBody?.fieldBitMask = BitMaskType.boom
        //        }else {
        //            prop.physicsBody?.fieldBitMask = BitMaskType.magnet
        //        }
        prop.physicsBody?.fieldBitMask = 0
        self.sprite.parent?.addChild(prop)
    }
    func startCreateGold() {
        let random = arc4random()%2
        var gold: SKSpriteNode!
        switch random {
        case 0:
            gold = CreateProduct.createGold("qian.png", size: GoldSizeType.gold)
            break
        case 1:
            gold = CreateProduct.createGold("zuanshi.png", size: GoldSizeType.gold)
            break
        default:
            break
        }
        
        gold.position = CGPoint(x: self.sprite.position.x, y: self.sprite.position.y-self.sprite.size.height/2-gold.size.height/2)
        gold.zPosition = SpriteLevel.sprite.rawValue
         self.sprite.parent?.addChild(gold)
    }
    
    func aiLogic(wanjia: Player) {
        let randomNum = CommonFunc.createRandomNum(1, Max: 20)
        if randomNum <= 6 {
            if wanjia.velocity > 0 {
                self.velocity = VelocityType.enemyVelocity
            }else {
                self.velocity = -VelocityType.enemyVelocity
            }
        }else {
            if wanjia.velocity > 0 {
                self.velocity = -VelocityType.enemyVelocity
            }else {
                self.velocity = VelocityType.enemyVelocity
            }
        }
        
//        NSThread.sleepForTimeInterval(2)
//        aiLogic(wanjia)
    }
}
