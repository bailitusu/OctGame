//
//  CreateProduct.swift
//  OctGame
//
//  Created by zc on 16/6/14.
//  Copyright © 2016年 oct. All rights reserved.
//

import UIKit
import SpriteKit

struct BitMaskType{
    static var gold = UInt32(1)
    static var player = UInt32(1 << 1)
    static var zombie = UInt32(1 << 2)
    static var enemy = UInt32(1 << 3)
    static var background = UInt32.max
    static var magnet = UInt32(1 << 4)

    static var boom = UInt32(1 << 5)
    static var changeBig = UInt32(1 << 6)
    static var changeSmall = UInt32(1 << 7)
    static var dingShen = UInt32(1 << 8)
    static var jiasu = UInt32(1 << 9)
    static var wudi = UInt32(1 << 10)
    static var fenshen = UInt32(1 << 11)
    static var wuyun = UInt32(1 << 12)
    static var dawuyun = UInt32(1 << 13)
    
    static var fightSelf = UInt32(1 << 14)
    static var fightEnemy = UInt32(1 << 15)
    static var fire = UInt32(1 << 16)
    static var ftWall = UInt32(1 << 17)
    static var ftJianTower = UInt32(1 << 18)
    static var bullet = UInt32(1 << 19)
   // static var
}
enum ProductType:String {
    case gold = "qian.png"
    case boom = "boom.png"
    case changeBig = "bianda"
    case changeSmall = "bianxiao"
    case dingShen = "dingshen"
    case jiasu = "jiasu"
    case wudi = "wudi"
    case magnet = "xitieshi"
    case fenshen = "fenshen"
    case wuyun = "wuyun"
}
class CreateProduct: NSObject {
    static var sheepArray = NSMutableArray()
    static func createGold(imageName:String, size: CGSize) ->SKSpriteNode {
        let gold = SKSpriteNode(imageNamed:imageName);
        gold.size = size
        gold.physicsBody = SKPhysicsBody(rectangleOfSize: gold.size,center: CGPoint(x: 0.5, y: 0.5))
        gold.physicsBody?.usesPreciseCollisionDetection = true
        gold.name = "Gold"
        gold.physicsBody?.mass = 1
        gold.physicsBody?.categoryBitMask = BitMaskType.gold
        gold.physicsBody?.collisionBitMask = BitMaskType.player | BitMaskType.gold
        gold.physicsBody?.contactTestBitMask = BitMaskType.player | BitMaskType.gold
        gold.physicsBody?.fieldBitMask = BitMaskType.magnet
        gold.zPosition = SpriteLevel.sprite.rawValue
        return gold
    }

    
    static func createProp(imageName:String,BitMask bitMask:UInt32)->SKSpriteNode {
        let prop = SKSpriteNode(imageNamed:imageName);
        prop.size = PropSizeType.prop
        prop.physicsBody = SKPhysicsBody(rectangleOfSize: prop.size,center: CGPoint(x: 0.5, y: 0.5))
        prop.physicsBody?.usesPreciseCollisionDetection = true
        prop.name = imageName
        prop.physicsBody?.mass = 100
        prop.physicsBody?.categoryBitMask = bitMask
        prop.physicsBody?.collisionBitMask = BitMaskType.player 
        prop.physicsBody?.contactTestBitMask = BitMaskType.player
        prop.zPosition = SpriteLevel.prop.rawValue
        return prop
    }
    
    static func createSheep() -> Sheep {
//        let atlas = SKTextureAtlas(named: "\(AtlasName.walkLeft.rawValue).atlas")
//        let texturename:String = "\(OneTextureName.oneWalkLeft.rawValue)1.png"
//        let sheep = SKSpriteNode(texture: atlas.textureNamed(texturename))
//        sheep.size = CGSize(width: 14, height: 20)
//        sheep.zPosition = SpriteLevel.sprite.rawValue
        let screen = UIScreen.mainScreen().bounds
        let sheep = Sheep(screenSize: screen.size)
        sheepArray.addObject(sheep)
        return sheep
    }
    

}
