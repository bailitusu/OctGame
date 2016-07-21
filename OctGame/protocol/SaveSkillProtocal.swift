//
//  SaveSkillProtocal.swift
//  OctGame
//
//  Created by zc on 16/7/20.
//  Copyright © 2016年 oct. All rights reserved.
//

import SpriteKit
import UIKit

protocol SaveSkillProtocal {
    var isSaveAble: Bool { get set }
    func saveSkillItem(item: AnyObject)
    func removeSkillItem(item: AnyObject)

    var configRightSkillArray: NSMutableArray{ get set }
}


extension SaveSkillProtocal {
    func saveSkillItem(item: AnyObject) {
        if self.isSaveAble == true {
            self.configRightSkillArray.addObject(item)
        }
    }
    
    func removeSkillItem(item: AnyObject) {
        self.configRightSkillArray.removeObject(item)
    }
}


extension SaveSkillProtocal where Self: SKScene {
    func aaa() {
        print("scene aaa")
    }
}