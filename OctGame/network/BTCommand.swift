//
//  BTCommand.swift
//  SLBattleServer
//
//  Created by yuhan zhang on 7/1/16.
//
//


import Foundation


public enum BTCommand: String, CustomStringConvertible {
    
    
    case CStatusMatching        = "statusmatching"
    case CStatusSynchronized   = "statussynchronized"
    case CStatusEnding          = "statusending"
    
    case CCreateSpell           = "createspell"
    case CCastSpell             = "castspell"
    case CPlayerStatus          = "playerstatus"
    
    
    case SStartSynchronizing    = "startsynchronizing"
    case SStartFighting         = "startfighting"
    case SEndFighting           = "endfighting"
    case SPlayerDisconnected    = "playerdisconnected"
    
    
    case Error                  = "error"
    
    
    
    public static func decode(string: String) -> BTCommand {
        switch string {
        case "statussynchronized":
            return .CStatusSynchronized
        case "statusmatching":
            return .CStatusMatching
        case "statusending":
            return .CStatusEnding
            
        case "createspell":
            return .CCreateSpell
        case "castspell":
            return .CCastSpell
        case "playerstatus":
            return .CPlayerStatus
            
        case "startsynchronizing":
            return .SStartSynchronizing
        case "startfighting":
            return .SStartFighting
        case "endfighting":
            return .SEndFighting
        case "playerdisconnected":
            return .SPlayerDisconnected
        default:
            return .Error
        }
    }
    
    
    public var description: String {
        return self.rawValue
    }
    
}




