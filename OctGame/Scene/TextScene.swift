//
//  TextScene.swift
//  OctGame
//
//  Created by zc on 16/6/28.
//  Copyright © 2016年 oct. All rights reserved.
//

import SpriteKit
import UIKit

class TextScene: BaseScene {
    override func didMoveToView(view: SKView) {
     //   let ss = SKTexture(imageNamed: "flash.png")
//        let anode = SKProgressNode(backgroundTexture: SKTexture(imageNamed: "flash.png"), fillTexture: SKTexture(imageNamed: "Cooldown.png"), overlayTexture:SKTexture(imageNamed: "flash.png"), size: CGSize(width: 100, height: 100))
//        anode.size = CGSize(width: 100, height: 100)
//        anode.setProgressValue(0.5)
//        anode.position = CGPoint(x: screenSize.width/2, y: screenSize.height/2)
//        ss.drawLayer(<#T##layer: CALayer##CALayer#>, inContext: <#T##CGContext#>)
        
//        var progress:CGFloat = 0
//        let aaa = SKProgressNode(texture: SKTexture(imageNamed: "Cooldown.png"), size: CGSize(width: 100, height: 100), fillSpriteName: "flash.png")
//        aaa.position = CGPoint(x: screenSize.width/2, y: screenSize.height/2)
//        aaa.setFillAmount(progress)
//        self.addChild(aaa)
//        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
//        
//        dispatch_async(queue) { () -> Void in
//            while progress < 1 {
//                progress = progress + 0.05
//                aaa.setFillAmount(progress)
//                NSThread.sleepForTimeInterval(0.1)
//            }
//        }
        
        self.backgroundColor = SKColor.whiteColor()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
     //   CommonFunc.skillMeun("xitieshi", size: CGSize(width: PropSizeType.prop.width, height: PropSizeType.prop.height), fillImageName: "huicitie", timeCd: 10, scene: self)
     //   CommonFunc.skillMeun("dingshen", size: CGSize(width: PropSizeType.prop.width, height: PropSizeType.prop.height), fillImageName: "huidingshen", timeCd: 2, scene: self)
    }
}














