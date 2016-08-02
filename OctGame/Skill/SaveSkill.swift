//
//  SaveSkill.swift
//  OctGame
//
//  Created by zc on 16/7/27.
//  Copyright © 2016年 oct. All rights reserved.
//

import SpriteKit
import UIKit

class SaveSkill {
    var player: FightPlayer!
    var saveSkillArray = [SaveSkillProtocal]()
    var previousCount: Int = 0
    init(player: FightPlayer) {
        self.player = player
    }
    func showCurrentSaveSkill() {
//        if saveSkillArray.count > 5 {
//            saveSkillArray.first?.removeItem()
//            saveSkillArray.removeFirst()
//            for var i = saveSkillArray.count-1; i >= 0; i -= 1 {
//                saveSkillArray[i].skillPosition = (player.playerStateUI.skillUIArray.objectAtIndex(player.playerStateUI.skillUIArray.count-1-i) as! FTMapCell).position
//            }
//        }else {
//            for i in 0 ..< saveSkillArray.count {
//                saveSkillArray[i].skillPosition = (player.playerStateUI.skillUIArray.objectAtIndex(i) as! FTMapCell).position
//            }
//        }
        if saveSkillArray.count > 5 {
//                        saveSkillArray[4].removeItem()
//                        saveSkillArray.removeAtIndex(4)
                        saveSkillArray.first?.removeItem()
                        saveSkillArray.removeFirst()
        }

        for i in 0 ..< saveSkillArray.count {
            saveSkillArray[i].skillPosition = (player.playerStateUI.skillUIArray.objectAtIndex(i) as! FTMapCell).position
        }
        
        self.previousCount = saveSkillArray.count
    }
}
