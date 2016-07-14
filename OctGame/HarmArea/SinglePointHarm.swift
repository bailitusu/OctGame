//
//  SinglePointHarm.swift
//  OctGame
//
//  Created by zc on 16/7/13.
//  Copyright © 2016年 oct. All rights reserved.
//

import SpriteKit
import UIKit

class SinglePointHarm: HarmArea {
    
    override func runHarmArea(toHarmPlayer: FightPlayer, originalConterPoint: CGPoint, hitValue: Int) {
         (toHarmPlayer.fightMap.mapArray.objectAtIndex(toHarmPlayer.fightMap.getCurrentPointMapCell(originalConterPoint)!) as! FTMapCell).obj?.didBeHit(hitValue)
    }
}
