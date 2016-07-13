//
//  Sheep.swift
//  OctGame
//
//  Created by zc on 16/6/21.
//  Copyright © 2016年 oct. All rights reserved.
//

import Foundation
import SpriteKit

class Sheep : NSObject {
    static var sheepImageName = "laodaoshi.png"
    var screenSize: CGSize!
    var sprite: SKSpriteNode!
    var state:AnimationState!
    init(screenSize: CGSize) {
        super.init()
        self.screenSize = screenSize
        self.state = AnimationState.walkLeft
        
        let atlas = SKTextureAtlas(named: "\(AtlasName.walkLeft.rawValue).atlas")
        let texturename:String = "\(OneTextureName.oneWalkLeft.rawValue)1.png"
        sprite = SKSpriteNode(texture: atlas.textureNamed(texturename))
        sprite.size = CGSize(width: 14, height: 20)
        sprite.zPosition = SpriteLevel.sprite.rawValue
    }
    
    func runAnimation(currentState: AnimationState) {
        self.state = currentState
        self.sprite.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(AddResource.animationDic[currentState]!, timePerFrame: 0.05)), withKey: currentState.rawValue)
    }
    
    func removeSheep() {
        self.sprite.removeAllActions()
        self.sprite.removeFromParent()
    }
}