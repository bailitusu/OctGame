//
//  WebSocketDelegate.swift
//  OctGame
//
//  Created by zc on 16/7/4.
//  Copyright © 2016年 oct. All rights reserved.
//

import Foundation
import SpriteKit
//import Starscream
import SwiftyJSON
import Starscream

//class FightSceneWSDelegate: WebSocketDelegate{
//    
//    weak var scene: FightScene!
//    
//    init(forScene scene: FightScene) {
//        self.scene = scene
//        print("init")
//    }
//    
//    func websocketDidConnect(socket: WebSocket) {
//        
//    }
//    
//    func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
//        
//    }
//    
//    func websocketDidReceiveData(socket: WebSocket, data: NSData) {
//        print("websocketDidReceiveData")
//    }
//    
//    func websocketDidReceiveMessage(socket: WebSocket, text: String) {
//     //   print(text)
//  
//        guard let msg = BTMessage(from: text) else {
//            print("websocketDidReceiveMessage ERROR \(text)")
//            return
//        }
//        
//        switch msg.command {
//        case .CCastSpell:
//            self.doCastSpell(msg)
//        case .CCreateSpell:
//            self.doCreateSpell(msg)
//        case .CPlayerStatus:
//            self.doPlayerStatus(msg)
////        case .EndFighting:
//        default:
//            return
//        }
//        
//        
//        
//    }
//    
//    func doPlayerStatus(msg: BTMessage) {
//        scene.fightEnemy.fromDictionary(msg.params!)
//    }
//    
//    func doCreateSpell(msg: BTMessage) {
//     scene.fightEnemy.fromInitSkill(msg.params!)
//    }
//    
//    func doCastSpell(msg: BTMessage) {
//        
//        
//        
//        scene.fightEnemy.fromReleaseSkill(msg.params!)
//    }
//    
//    deinit {
//        print("deinit")
//    }
//}



extension FightScene: SLBattleFieldNetDelegate {
    func websocketDidConnected(socket: SLBattleFieldNet) {
        
    }
    
    func websocketDidDisconnected(socket: SLBattleFieldNet, error: NSError?) {
        print("失去连接")
    }
    
    func websocketDidReceiveMessage(msg: BTMessage, net: SLBattleFieldNet) {
        print(msg.command)
        
        switch msg.command {
            
        case .SEndFighting:
            self.doEndFighting(msg)
            break
        case .SPlayerDisconnected:
            self.doDisconnect(msg)
            
            break
        case .CCastSpell:
            self.doCastSpell(msg)
            break
        case .CCreateSpell:
            self.doCreateSpell(msg)
            break
        case .CPlayerStatus:
            self.doPlayerStatus(msg)
            break
        default:
            return
        }

    }
    
    func doEndFighting(msg: BTMessage) {
        let json = JSON(msg.params)
        if json["winner"].stringValue == UserID {
            SuccessView.instance.isSuccess = true
            SuccessView.instance.rightBtn.userInteractionEnabled = true
            SuccessView.instance.rightBtn.hidden = false
        }else if json["loser"].stringValue == UserID {
            SuccessView.instance.isSuccess = false
            SuccessView.instance.rightBtn.userInteractionEnabled = true
            SuccessView.instance.rightBtn.hidden = false
        }

    }
    
    func doDisconnect(msg: BTMessage) {
        SuccessView.gameOver(self.view!, isSuccess: true)
        self.sock.send(BTCommand.CStatusEnding)
    }
    
    func doPlayerStatus(msg: BTMessage) {
        let json = JSON(msg.params)
        self.fightEnemy.fromDictionary(json)
    }
    
    func doCreateSpell(msg: BTMessage) {
        let json = JSON(msg.params)
        self.fightEnemy.fromInitSkill(json)
    }
    
    func doCastSpell(msg: BTMessage) {
        
        
        let json = JSON(msg.params)
        self.fightEnemy.fromReleaseSkill(json)
    }
}















