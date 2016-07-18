//
//  BeginScene.swift
//  Oct_Game
//
//  Created by zc on 16/6/10.
//  Copyright © 2016年 oct. All rights reserved.
//

import UIKit
import SpriteKit
import Starscream

class BeginScene: BaseScene {

    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)

        
        self.backGround = SKSpriteNode(imageNamed: "begin.jpg")
        self.backGround.size = CGSize(width: self.frame.width, height: self.frame.height)
        self.backGround.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        self.backGround.zPosition = SpriteLevel.background.rawValue
        self.addChild(backGround)
        
        let gameNameLabel = SKLabelNode(fontNamed: "Chalkduster")
        gameNameLabel.text = "Welcome to Oct World"
        gameNameLabel.fontSize = 27
        gameNameLabel.fontColor = UIColor.blackColor()
        gameNameLabel.zPosition = SpriteLevel.sprite.rawValue;
        gameNameLabel.position = CGPointMake(self.frame.width/2, self.frame.height/2)
        self.addChild(gameNameLabel)


        let goldBtn = SpriteButton(titleText: "金币游戏", normalImageName: nil, callBack: { () -> () in
            
            let nextScene = MainScene()
            nextScene.size = self.view!.frame.size
           // nextScene.websocket = self.websocket
            let door = SKTransition.doorsOpenHorizontalWithDuration(2.0)
            self.view!.presentScene(nextScene, transition: door)
            
            }, frame:CGRectMake(self.frame.size.width/2, 80, 120, 40))
        goldBtn.setBackGroundColor(UIColor.blackColor())
        goldBtn.zPosition = SpriteLevel.sprite.rawValue
        self.addChild(goldBtn)
        
        
//        let carleBtn = SpriteButton(titleText: "卡尔传奇", normalImageName: nil, callBack: { () -> () in
//            
//            let nextScene = FTMatchScene()
//            nextScene.size = self.view!.frame.size
//            // nextScene.websocket = self.websocket
//            let door = SKTransition.doorsOpenHorizontalWithDuration(2.0)
//            self.view!.presentScene(nextScene, transition: door)
//            
//            
//            }, frame:CGRectMake(self.frame.size.width/2, 80, 120, 40))
//        carleBtn.setBackGroundColor(UIColor.blackColor())
//        carleBtn.zPosition = SpriteLevel.sprite.rawValue
//        self.addChild(carleBtn)
    }

}
