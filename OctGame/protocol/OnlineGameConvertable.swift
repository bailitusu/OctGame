//
//  OnlineGameConvertable.swift
//  OctGame
//
//  Created by zc on 16/7/1.
//  Copyright © 2016年 oct. All rights reserved.
//

import SpriteKit
import UIKit
import SwiftyJSON

protocol OnlineGameConvertable {
    func sendMeg()
    
}


protocol OnlineGameObjectType {
    func toDictionary() -> [String: AnyObject]
    
    func toInitSkill(dict: [String: AnyObject])-> [String: AnyObject]
    func toReleaseSkill(dict: [String: AnyObject]) -> [String: AnyObject]
   // func fromDictionary(dict: JSON)
}


//extension OnlineGameObjectType {
//    
//    func toDictionary() -> Dictionary<String, AnyObject> {
//        let me = Mirror(reflecting: self)
//        
//        for (key, value) in me.children {
//            if key ==
//        }
//    }
//    
//    
//    
//}
