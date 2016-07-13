//
//  SpriteComponent.swift
//  Oct_Game
//
//  Created by zc on 16/6/10.
//  Copyright © 2016年 oct. All rights reserved.
//

import SpriteKit

class SpriteComponent: Component {
    var sprite: SKSpriteNode!
    init(sprite:SKSpriteNode) {
        self.sprite = sprite
    }
    override func didAddToEntity(entity: Entity) {
        if entity.hasComponent(SpriteComponent.self) == true {
            return
        }
    }
}

extension Entity {
    var physicsBody: SKPhysicsBody? {
        return self.componentForClass(SpriteComponent.self)!.sprite!.physicsBody!
    }
}