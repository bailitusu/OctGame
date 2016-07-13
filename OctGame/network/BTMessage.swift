//
//  BTMessage.swift
//  SLBattleServer
//
//  Created by yuhan zhang on 7/1/16.
//
//


import Foundation
import SwiftyJSON


let UserID = "user\(Int(arc4random() % 10000) + 1)"


struct BTMessage: CustomStringConvertible {
    
    var userID: String = UserID
    
    var command: BTCommand
    
    var params: JSON?
    
    
    init?(from string: String) {
        
        let strings = string.componentsSeparatedByString("_")
        self.userID = strings[0]
        self.command = BTCommand.decode(strings[1])
        
        if strings.count > 2 {
            self.params = JSON.parse(strings[2])
        }
        
    }
    
    
    init(command: BTCommand, params: JSON? = nil) {
        self.command = command
        self.params = params
    }
    

    var description: String {
        if self.params == nil {
            return "\(userID)_\(command)"
        } else {
            return "\(userID)_\(command)_\(params!)"
        }
    }
    
    
    
}




