//
//  FTPlayerStateUI.swift
//  OctGame
//
//  Created by zc on 16/7/14.
//  Copyright © 2016年 oct. All rights reserved.
//

import SpriteKit
import UIKit

class FTPlayerStateUI: NSObject {
    var player: FightPlayer!
    var hpLabel: SKLabelNode!
   // var  scene: SKScene!
    var skillUIArray = NSMutableArray()
    init(player: FightPlayer) {
        super.init()
        self.player = player
     //   self.scene = scene
        self.initHpUI()
    }
    
    func initHpUI() {
        self.hpLabel = SKLabelNode(fontNamed: "Arial")
        self.hpLabel.text = "HP: \(self.player.HP)"
        self.hpLabel.fontSize = 14
        self.hpLabel.fontColor = UIColor.redColor()
        self.hpLabel.zPosition = SpriteLevel.fightStateUI.rawValue
       // self.scene.addChild(self.hpLabel)
    }
    
    func changeHpUI(hp: Int) {
        self.hpLabel.text = "HP: \(hp)"
    }
    
    func initSaveSkillUI(horizontalNum: Int,originalPointY: CGFloat) {
        let oneSpriteRect = self.player.fightMap.initFirstSpriteRect(horizontalNum, size: fightMapCellSize, originalPointY: originalPointY)
        oneSpriteRect.zPosition = SpriteLevel.map.rawValue
        skillUIArray.addObject(oneSpriteRect)
        for i in 1 ..< horizontalNum {
            let newCell = self.player.fightMap.createOneSpriteRect(fightMapCellSize)
            newCell.position = CGPoint(x:oneSpriteRect.position.x+CGFloat(i)*fightMapCellSize.width, y: oneSpriteRect.position.y)
            newCell.zPosition = SpriteLevel.map.rawValue
            skillUIArray.addObject(newCell)
        }
    }
}