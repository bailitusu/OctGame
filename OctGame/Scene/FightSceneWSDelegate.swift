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

class FightSceneWSDelegate: WebSocketDelegate{
    
    weak var scene: FightScene!
    
    init(forScene scene: FightScene) {
        self.scene = scene
        print("init")
    }
    
    func websocketDidConnect(socket: WebSocket) {
        
    }
    
    func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        
    }
    
    func websocketDidReceiveData(socket: WebSocket, data: NSData) {
        print("websocketDidReceiveData")
    }
    
    func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        print(text)
  
        guard let msg = BTMessage(from: text) else {
            print("websocketDidReceiveMessage ERROR \(text)")
            return
        }
        
        switch msg.command {
        case .CastSpell:
            self.doCastSpell(msg)
        case .CreateSpell:
            self.doCreateSpell(msg)
        case .PlayerStatus:
            self.doPlayerStatus(msg)
//        case .EndFighting:
        default:
            return
        }
        
        
        
    }
    
    func doPlayerStatus(msg: BTMessage) {
        scene.fightEnemy.fromDictionary(msg.params!)
    }
    
    func doCreateSpell(msg: BTMessage) {
     scene.fightEnemy.fromInitSkill(msg.params!)
    }
    
    func doCastSpell(msg: BTMessage) {
        
        
        
        scene.fightEnemy.fromReleaseSkill(msg.params!)
    }
    
    deinit {
        print("deinit")
    }
}