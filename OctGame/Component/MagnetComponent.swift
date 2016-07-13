//
//  MagnetComponent.swift
//  OctGame
//
//  Created by zc on 16/6/15.
//  Copyright © 2016年 oct. All rights reserved.
//

import UIKit
import SpriteKit

class MagnetComponent: Component {
    var node: SKFieldNode!
    var duration:NSTimeInterval!
    var spriteAnimation:SKSpriteNode!
    var textureArray = [SKTexture]()
    var sprite: SKSpriteNode {
        return (self.entity?.componentForClass(SpriteComponent.self)?.sprite)!
    }
    init(duration:NSTimeInterval) {
        super.init()
        self.duration = duration
        self.node = SKFieldNode.radialGravityField()
        node.region = SKRegion(radius: 200)
        node.strength = 40
        node.falloff = 0
        node.categoryBitMask = BitMaskType.magnet
        node.name = "Magnet"
        
        
    }
    override func willAddToEntity(entity: Entity) {
        if entity.hasComponent(MagnetComponent.self) == true {
            entity.componentForClass(MagnetComponent.self)?.spriteAnimation.removeActionForKey("xitieshi")
            entity.componentForClass(MagnetComponent.self)?.spriteAnimation.removeFromParent()
            entity.removeComponent(MagnetComponent.self)
        }
    }
    override func didAddToEntity(entity: Entity) {
        
        self.sprite.removeActionForKey("magnet")
        let atlas = SKTextureAtlas(named: "\(AtlasName.citie.rawValue).atlas")
        self.spriteAnimation = SKSpriteNode(texture: atlas.textureNamed("\(OneTextureName.oneCitie.rawValue)1.png"))
        var tempName:String
        for j in 1 ..< (atlas.textureNames.count+1) {
            tempName = "\(OneTextureName.oneCitie.rawValue)\(j).png"
            let texture = atlas.textureNamed(tempName)
            textureArray.append(texture)
        }
        self.spriteAnimation.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(textureArray, timePerFrame: 0.1)), withKey: "xitieshi")
        self.sprite.addChild(self.spriteAnimation)
    //    let anmition = self.entity?.componentForClass(AnimationComponent.self)
        entity.componentForClass(SpriteComponent.self)?.sprite.addChild(node)
        let wait = SKAction.waitForDuration(self.duration)
        let block = SKAction.runBlock { () -> Void in
            self.node.removeFromParent()
            self.spriteAnimation.removeActionForKey("xitieshi")
            self.spriteAnimation.removeFromParent()
            self.spriteAnimation = nil

            entity.removeComponent(MagnetComponent.self)
            
           // anmition?.state = .none
        }
        self.sprite.runAction(SKAction.sequence([wait, block]),withKey: "magnet")
        
    }
    
    override func willRemoveFromEntity(entity: Entity) {
        node.removeFromParent()
    }
    
//    override func updateWithDeltaTime(second: NSTimeInterval) {
//        if self.sprite.position.y != self.sprite.size.height/2 {
//            self.sprite.position = CGPoint(x: self.sprite.position.x, y: self.sprite.size.height/2)
//        }
//    }
}
