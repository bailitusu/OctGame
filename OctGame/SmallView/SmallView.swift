//
//  SmallView.swift
//  OctGame
//
//  Created by zc on 16/7/21.
//  Copyright © 2016年 oct. All rights reserved.
//

import UIKit
import SpriteKit

class SuccessView: SKView {
    static let instance = SuccessView(frame: CGRect(x: 0, y: 0,  width: screenSize.width, height: screenSize.height))
    var isSuccess: Bool? {
        didSet{
            if isSuccess == true {
                self.victoryLabel?.text = "You Victory!!!"
            }else if isSuccess == false {
                self.victoryLabel?.text = "You Lose!!!"
            }else {
                self.victoryLabel?.text = ""
            }
        }
    }
    var victoryLabel: UILabel?
    var rightBtn: UIButton!
   // var scene: SKScene!
   private override init(frame: CGRect) {
        super.init(frame: frame)
//        let bgImage = UIImage.init(named: "finishBackground.jpg")
//        self.layer.contents = bgImage?.CGImage
        self.backgroundColor = UIColor.blackColor()
        self.alpha = 0.8
        self.victoryLabel = UILabel(frame: CGRect(x: screenSize.width/2-screenSize.width*0.666/2, y: screenSize.height*0.24, width: screenSize.width*0.666, height: screenSize.height*0.075))
        self.victoryLabel?.font = UIFont.systemFontOfSize(24)
        self.victoryLabel?.textColor = UIColor.blueColor()
        self.victoryLabel?.textAlignment = NSTextAlignment.Center
        self.victoryLabel?.backgroundColor = UIColor.clearColor()
        self.addSubview(self.victoryLabel!)
        
        rightBtn = UIButton.init(frame: CGRect(x: screenSize.width/2-screenSize.width*0.32/2, y: screenSize.height-screenSize.height*0.059/2-screenSize.height*0.24 , width: screenSize.width*0.32 , height: screenSize.height*0.059))
        rightBtn.setTitle("确认", forState: UIControlState.Normal)
        rightBtn.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        rightBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        rightBtn.backgroundColor = UIColor.greenColor()
        rightBtn.titleLabel?.font = UIFont.systemFontOfSize(14)
        rightBtn.addTarget(self, action: #selector(rightOk), forControlEvents: UIControlEvents.TouchUpInside)
        rightBtn.userInteractionEnabled = false
        rightBtn.hidden = true
        self.addSubview(rightBtn)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func rightOk(sender: AnyObject) {
        
        let nextScene = FTMatchScene()
        nextScene.size = self.superview!.frame.size
        // nextScene.websocket = self.websocket
        let door = SKTransition.doorsCloseVerticalWithDuration(2.0)
        ((self.superview) as! SKView).presentScene(nextScene, transition: door)
        self.removeFromSuperview()
    }

    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("dddd")
        
    }

}

extension  SuccessView {
    static func gameOver(skView: SKView, isSuccess: Bool?) {
        let successView = instance
        successView.isSuccess = isSuccess
        skView.addSubview(successView)
        
    }
}
