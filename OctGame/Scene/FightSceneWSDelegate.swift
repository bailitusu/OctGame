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
        switch msg.command {
            
        case .SEndFighting:
            self.sock.send(BTCommand.CStatusEnding)
        case .SPlayerDisconnected:
            self.sock.send(BTCommand.CStatusEnding)
            
        case .CCastSpell:
            self.doCastSpell(msg)
        case .CCreateSpell:
            self.doCreateSpell(msg)
        case .CPlayerStatus:
            self.doPlayerStatus(msg)
            
            
            
            
            default:
            return
        }

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















