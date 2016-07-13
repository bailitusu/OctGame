//
//  BaseScene.swift
//  Oct_Game
//
//  Created by zc on 16/6/10.
//  Copyright © 2016年 oct. All rights reserved.
//

import SpriteKit

class BaseScene: SKScene {
    var entities = [Entity]()
    var backGround:SKSpriteNode!
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        self.backgroundColor = SKColor.whiteColor()
        self.scaleMode = .AspectFill
        self.userInteractionEnabled = true
    }
    
    override func update(currentTime: NSTimeInterval) {
        for entity in self.entities {
            entity.updateWithDeltaTime(currentTime)
        }
    }
    
    func addEntity(entity: Entity) {
        self.entities.append(entity)
        if let node = entity.componentForClass(SpriteComponent.self)?.sprite {
            self.addChild(node)
        }
    }
}
