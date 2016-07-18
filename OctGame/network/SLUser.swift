//
//  SLUser.swift
//  SpriteLabClient
//
//  Created by yuhan zhang on 6/27/16.
//  Copyright © 2016 octopus. All rights reserved.
//

import Foundation


public let KeyID = "id"
public let KeyExp = "exp"
public let KeyCharacters = "characters"
public let KeyTalent = "talent"



public class SLUser: OCTModel {
    
    public let id: String
    
    public var exp: Int
    
    public var characters: [String]
    
    public var talent: [String]
    
    
    public init(fromJSON json: JSON) {
        self.id = json[KeyID]!.string!
        self.exp = Int(json[KeyExp]!.double!)

        
        self.characters = []
        for s in json[KeyCharacters]!.array! {
            self.characters.append(s.string!)
        }
        
        self.talent = []
        for s in json[KeyTalent]!.array! {
            self.talent.append(s.string!)
        }
    }
    
    
    public func toJSON() -> JSON {
        let idJSON = JSON([KeyID: JSON(self.id)])
        let expJSON = JSON([KeyExp: JSON(Double(self.exp))])
        
        
        var charJSON = [JSON]()
        for char in self.characters {
            charJSON.append(JSON(char))
        }
        let charsJSON = JSON(charJSON)
        let characterJSON = JSON([KeyCharacters: charsJSON])
        
        
        var talJSON = [JSON]()
        for tal in self.talent {
            talJSON.append(JSON(tal))
        }
        let talsJSON = JSON(talJSON)
        let talentJSON = JSON([KeyTalent: talsJSON])
        
        
        return JSON([KeyID: JSON(self.id), KeyExp: JSON(Double(self.exp)), KeyCharacters: charsJSON, KeyTalent: talsJSON])
        
    }
    
    
    
    public required init(fromDictionary dict: Dictionary<String, AnyObject>) {
        
        self.id = dict[KeyID] as! String
        self.exp = Int(dict[KeyExp] as! String)!
        self.characters = dict[KeyCharacters] as! [String]
        self.talent = dict[KeyTalent] as! [String]
        
    }
    
    
    public func toDictionary() -> Dictionary<String, AnyObject?> {
        return [KeyID: self.id, KeyExp: self.exp, KeyCharacters: "\(self.characters)", KeyTalent: "\(self.talent)"]
    }
    
}


extension SLUser {
    
    static func random() -> SLUser {
        let dict = [KeyID: "\(Int(arc4random() % 1000))", KeyExp: "100", KeyCharacters: ["huangdi", "chiyou"], KeyTalent: []]
        
        return SLUser(fromDictionary: dict as! Dictionary<String, AnyObject>)
        
    }
    
}










