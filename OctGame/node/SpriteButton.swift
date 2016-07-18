//
//  SpriteButton.swift
//  Oct_Game
//
//  Created by zc on 16/6/10.
//  Copyright © 2016年 oct. All rights reserved.
//

import Foundation
import SpriteKit

class SpriteButton: SKNode {
    
    var sprite:SKSpriteNode!
    var normalTexture:SKTexture!
    var selectBackGroundColor:SKColor!
    var normalBackGroundColor:SKColor!
    typealias CallBack = ()->()
    var callback: CallBack!
    var titleText:SKLabelNode!
    var fontSize:CGFloat = 14  {
        didSet {
            self.titleText.fontSize = fontSize
        }
    }
   // var crop:SKCropNode!
    
    init(titleText:String?,normalImageName:String?,callBack:CallBack!,frame:CGRect) {
        super.init()
        self.userInteractionEnabled = true
        //        self.frame = frame
        //        let roundRect:CGRect = UIBezierPath(roundedRect: frame, cornerRadius: 5.0)
        if let imgaeName = normalImageName {
            normalTexture = SKTexture(imageNamed: imgaeName)
            sprite = SKSpriteNode(texture: normalTexture)
        }else {
            sprite = SKSpriteNode(color: UIColor.redColor(), size: frame.size)
        }
        
        sprite.size = frame.size
        sprite.position = frame.origin
       // sprite.position = CGPoint(x: frame.origin.x+frame.size.width/2, y:  frame.origin.y-frame.size.height/2)
        self.addChild(sprite)
        if let text = titleText {
            self.titleText = SKLabelNode(fontNamed: "Arial")
            self.titleText.text = text
            self.titleText.fontSize = fontSize
            self.titleText.position = CGPoint(x: frame.origin.x,y: frame.origin.y-7)

            self.titleText.fontColor = UIColor.greenColor()
            self.addChild(self.titleText)
        }
        self.callback = callBack
        
    }
    func setBackGroundColor(bgColor:UIColor!) {
        sprite.color = bgColor
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            if CGRectContainsPoint(sprite.frame, location) {
                self.callback()
            }
            
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}