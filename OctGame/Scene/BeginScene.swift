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

class BeginScene: BaseScene,WebSocketDelegate {
    
   // weak var webDelegate: WebSocketDelegate!
    var websocket: WebSocket!

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
        self.websocket = WebSocket(url: NSURL(string: "ws://120.25.98.248:8282/synchronization")!, protocols: ["SynchronizationHandler"])
        
        self.websocket.delegate = self

        let beginBtn = SpriteButton(titleText: "开始游戏", normalImageName: nil, callBack: { () -> () in
            
            if self.websocket.isConnected {
                return
            }
            
            
            
            self.websocket.connect()
   
                print("lianjie begin")
            
            }, frame:CGRectMake(self.frame.size.width/2, 80, 120, 40))
        beginBtn.setBackGroundColor(UIColor.blackColor())
        beginBtn.zPosition = SpriteLevel.sprite.rawValue
        self.addChild(beginBtn)

    }
    
    func websocketDidConnect(socket: WebSocket) {
        print("websocketDidConnect")

//        self.websocket.writeString("battlefield001_\(userID)_synchronization")
        
        self.websocket.writeMessage(BTMessage(command: BTCommand.Match))
        
    }
    
    func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        print("disconnect")
    }
    
    func websocketDidReceiveData(socket: WebSocket, data: NSData) {
        
        
    }
    
    func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        
        guard let msg = BTMessage(from: text) else {
            print("websocketDidReceiveMessage ERROR \(text)")
            return
        }
        
        switch msg.command {
        case .StartFighting:
            let nextScene = FightScene()
            nextScene.size = self.view!.frame.size
            nextScene.websocket = self.websocket
            let door = SKTransition.doorsOpenHorizontalWithDuration(2.0)
            self.view!.presentScene(nextScene, transition: door)
            // self.websocket.disconnect()
        default:
            print("websocketDidReceiveMessage ERROR \(msg.command)")
        }
        
        
        
        
//        print(text)
//        if text == "Ready Go!" {
//            let nextScene = FightScene()
//            nextScene.size = self.view!.frame.size
//            nextScene.websocket = self.websocket
//            let door = SKTransition.doorsOpenHorizontalWithDuration(2.0)
//            self.view!.presentScene(nextScene, transition: door)
//            // self.websocket.disconnect()
//
//        }
        
    }

}
