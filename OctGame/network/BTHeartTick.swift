//
//  BTHeartTick.swift
//  SpriteLabUtility
//
//  Created by yuhan zhang on 7/14/16.
//  Copyright © 2016 octopus. All rights reserved.
//


import Foundation


extension SLBattleFieldNet {
    
    func startHeartTick() {
        DispatchQueue.global(attributes: DispatchQueue.GlobalAttributes.qosDefault).async {
            
            while true {
                guard self.socket.isConnected else {
                    print("disconnected STOP heart tick")
                    return
                }
                
                print("send ping")
                
                self.socket.write("1111111111111".data(using: String.Encoding.utf8)!)
                
                sleep(2)
                
            }
            
        }
        
    }
    
}
