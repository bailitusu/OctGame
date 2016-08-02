//
//  BTNet.swift
//  SpriteLabClient
//
//  Created by yuhan zhang on 7/11/16.
//  Copyright © 2016 octopus. All rights reserved.
//


import Foundation
import Starscream


public protocol SLBattleFieldNetDelegate: NSObjectProtocol {
    func websocketDidConnected(socket: SLBattleFieldNet)
    func websocketDidDisconnected(socket: SLBattleFieldNet, error: NSError?)
    func websocketDidReceiveMessage(msg: BTMessage, net: SLBattleFieldNet)
}



let BTWebSocketURL = "ws://120.25.98.248:8282/synchronization"
let BTProtocols = ["SynchronizationHandler"]



public class SLBattleFieldNet: WebSocketDelegate {
    
    let socket: WebSocket
    
    var heartBeatTimer: NSTimer?
    
    weak var delegate: SLBattleFieldNetDelegate?
    
    init() {
        self.socket = WebSocket(url: NSURL(string: BTWebSocketURL)!, protocols: BTProtocols)
        self.socket.connect()
        self.socket.delegate = self
    }
    
    
    
    deinit {
        self.socket.disconnect()
        self.heartBeatTimer?.invalidate()
        print("---------------web socket deinit")
    }
    
    
    
    
    public func websocketDidConnect(socket: WebSocket) {
        self.startHeartTick()
        self.delegate?.websocketDidConnected(self)
    }
    
    
    
    public func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        self.delegate?.websocketDidDisconnected(self, error: error)
        self.heartBeatTimer?.invalidate()
    }
    
    
    
    public func websocketDidReceiveData(socket: WebSocket, data: NSData) {
        
    }
    
    
    
    public func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        guard let msg = BTMessage(from: text) else {
            return
        }
        

        self.delegate?.websocketDidReceiveMessage(msg, net: self)
//        switch msg.command {
//        case .SStartFighting:
//            self.delegate?.doStartFighting(msg: msg)
//        case .SEndFighting:
//            self.delegate?.doEndFighting(msg: msg)
//        case .SPlayerDisconnected:
//            self.delegate?.doPlayerDisconnected(msg: msg)
//        case .CCreateSpell:
//            self.delegate?.doCastSpell(msg: msg)
//        case .CCastSpell:
//            self.delegate?.doCastSpell(msg: msg)
//        case .CPlayerStatus:
//            self.delegate?.doPlayerStatus(msg: msg)
//        default:
//            print("unknow command: \(msg.command)")
//        }
        
    }
    
    
    
}



extension SLBattleFieldNet {
    func send(command: BTCommand, withParams params: [String: AnyObject] = [:]) {
        let msg = BTMessage(command: command, params: params)
        
        self.socket.writeString(msg.description)
    }
}













