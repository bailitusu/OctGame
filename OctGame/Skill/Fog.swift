//
//  Fog.swift
//  OctGame
//
//  Created by zc on 16/7/26.
//  Copyright © 2016年 oct. All rights reserved.
//

import SpriteKit
import UIKit

class Fog: SKSpriteNode ,SaveSkillProtocal{
    var entityName: String!
    var isControl: Bool!
    var fogID: UInt32!
    var isRemove: Bool!
    var imageName: String = "wu.png"
    var time: Double = 0
    var perTime: NSTimeInterval = 0
    var oneTime: Bool = true
    var skillPosition: CGPoint? {
        didSet {
            self.position = skillPosition!
        }
    }
    init(size: CGSize, entityName: String, fogID: UInt32) {
        super.init(texture: SKTexture(imageNamed: imageName), color: UIColor.clearColor(), size: size)
        self.entityName = entityName
        self.isControl = true
        self.isRemove = false
        self.fogID = fogID
        self.alpha = 0.7
        self.zPosition = SpriteLevel.fog.rawValue
    }
    
    func removeItem() {
        self.isRemove = true
    }
    
    func removeFog()->Bool {
        if self.isRemove == true {
            self.removeFromParent()
            return true
        }
        return false
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
