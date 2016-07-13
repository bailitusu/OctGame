//
//  InvincibleComponent.swift
//  OctGame
//
//  Created by zc on 16/6/15.
//  Copyright © 2016年 oct. All rights reserved.
//

import UIKit
import SpriteKit

class InvincibleComponent: Component {
    var duration:NSTimeInterval!
    
    var spriteAnimation: SKSpriteNode!
//    var textureArray = [SKTexture]()
    var sprite:SKSpriteNode {
        return (self.entity?.componentForClass(SpriteComponent.self)?.sprite)!
    }
    
    init(duration:NSTimeInterval) {
        super.init()
        self.duration = duration
    }
    override func willAddToEntity(entity: Entity) {
        if entity.hasComponent(InvincibleComponent.self) == true {
           // self.sprite.removeActionForKey("wudi")
            entity.componentForClass(SpriteComponent.self)?.sprite.removeActionForKey("wudi")
            entity.componentForClass(InvincibleComponent.self)?.spriteAnimation.removeFromParent()
            entity.removeComponent(InvincibleComponent.self)
        }
    }
    override func didAddToEntity(entity: Entity) {


        self.spriteAnimation = SKSpriteNode(imageNamed: "\(OneTextureName.oneWudi.rawValue)1.png")
        self.spriteAnimation.size = CGSize(width: 110, height: 120)
        self.spriteAnimation.position = CGPoint(x: 0, y: 10)
        self.sprite.addChild(spriteAnimation)
    //    let anmition = self.entity?.componentForClass(AnimationComponent.self)
        let wait = SKAction.waitForDuration(duration)
    //    let tempSprite = self.spriteAnimation
        let block = SKAction.runBlock { () -> Void in
            self.entity?.removeComponent(InvincibleComponent.self)
          //  anmition?.state = .none
          //  tempSprite.removeFromParent()
        }
        self.sprite.runAction(SKAction.sequence([wait,block]),withKey: "wudi")
    }
    
    override func willRemoveFromEntity(entity: Entity) {
        self.sprite.removeActionForKey("wudi")
        self.spriteAnimation.removeFromParent()
    }
//    override func updateWithDeltaTime(second: NSTimeInterval) {
//        self.s.position = self.sprite.position
//    }
//    
//    func clear() {
    
}
