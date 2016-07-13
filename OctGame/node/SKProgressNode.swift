//
//  SKProgressNode.swift
//  OctGame
//
//  Created by zc on 16/6/28.
//  Copyright © 2016年 oct. All rights reserved.
//

import SpriteKit

class SKProgressNode: SKSpriteNode {
    var fillSprite : SKSpriteNode!
    var cropNode : SKCropNode!
    var maskNode : SKSpriteNode!
    var time: CGFloat!
    var nodeName: String!
    var progress: CGFloat!
    init(texture: SKTexture?, size: CGSize, fillSpriteName: String, name: String) {
        super.init(texture: texture, color: UIColor.redColor(), size: size)
        self.nodeName = name
        self.progress = 0
        fillSprite = SKSpriteNode(imageNamed: fillSpriteName)
        fillSprite.size = size
        maskNode = SKSpriteNode(color: SKColor.greenColor(), size: CGSize(width: self.size.width, height: self.size.height))
//        maskNode = SKSpriteNode(imageNamed: "dawuyun")
//        maskNode.size = CGSize(width: self.size.width, height: self.size.height)
        maskNode.position.y = -size.height/2
        
        cropNode = SKCropNode()
        cropNode.addChild(fillSprite)
        cropNode.maskNode = maskNode
        cropNode.zPosition = self.zPosition+1
        self.addChild(cropNode)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reStart() {
        self.progress = 0
    }
    
    func finish() {
        self.progress = 1
    }
    
    func setFillAmount(amount: CGFloat) {
        // amount parameter must be float value between 0.0 and 1.0
        let newHeight = amount * (self.size.height*2)
        maskNode.size = CGSize(width: self.size.width, height: newHeight)
    }
}
