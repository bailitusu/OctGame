//
//  BTMessage.swift
//  SLBattleServer
//
//  Created by yuhan zhang on 7/1/16.
//
//


import Foundation
import SwiftyJSON


#if os(iOS)
    let UserID = NSUserDefaults.standardUserDefaults().objectForKey("userid") as? String ?? "user_\(arc4random() % 1000)"
#else
    let UserID = "WebSocketServer"
#endif



public struct BTMessage: CustomStringConvertible {
    
    public var userid: String = UserID
    
    public var command: BTCommand
    
    public var params: [String: AnyObject]
    
    
    public init?(from string: String) {
        
            let json = JSON.parse(string)
            
            guard let id = json["userid"].string else {
                return nil
            }
            
            
            guard let command = json["command"].string else {
                return nil
            }
            
            
            guard let params = json["params"].dictionaryObject else {
                return nil
            }
            
            
            self.userid = id
            self.command = BTCommand.decode(command)
            self.params = params
            
            
        
    }
    
    
    public init(command: BTCommand, params: [String: AnyObject] = [:]) {
        self.userid = UserID
        self.command = command
        self.params = params
    }
    

    public var description: String {
        
        let dict: [String: AnyObject] = ["userid": self.userid, "command": self.command.description, "params": self.params]
        return JSON(dict).description
        
    }
    
    
    
}




