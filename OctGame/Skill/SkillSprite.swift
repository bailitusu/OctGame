//
//  SkillSprite.swift
//  OctGame
//
//  Created by zc on 16/7/8.
//  Copyright © 2016年 oct. All rights reserved.
//

import Foundation
import SpriteKit

class SkillSprite {
    var sprite: SKSpriteNode?
    var entityName: String?
    var isControl: Bool?
    var skillSpriteID:String?
    var collideCount: UInt32?
    var isRemove: Bool?
    
    var dircspeed: CGVector! {
        didSet {
            self.sprite!.physicsBody?.velocity = dircspeed
        }
        
    }
    
    
}