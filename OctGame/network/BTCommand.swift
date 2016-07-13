//
//  BTCommand.swift
//  SLBattleServer
//
//  Created by yuhan zhang on 7/1/16.
//
//


import Foundation


enum BTCommand: String, CustomStringConvertible {
    
    case Synchronize = "synchronize"
    case Match = "match"
    case StartFighting = "startfighting"
    case CreateSpell = "createspell"
    case CastSpell = "castspell"
    case PlayerStatus = "playerstatus"
    case EndFighting = "endfighting"
    case Error = "commanderror"
    
    
    static func decode(string: String) -> BTCommand {
        switch string {
        case "synchronize":
            return .Synchronize
        case "match":
            return .Match
        case "startfighting":
            return .StartFighting
        case "createspell":
            return .CreateSpell
        case "castspell":
            return .CastSpell
        case "playerstatus":
            return .PlayerStatus
        case "endfighting":
            return .EndFighting
        default:
            return .Error
        }
    }
    
    
    var description: String {
        return self.rawValue
    }
    
}



func ==(lhs: BTCommand, rhs: BTCommand) -> Bool {
    return lhs.rawValue == rhs.rawValue
}






