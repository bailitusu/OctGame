//
//  HengPaiHarm.swift
//  OctGame
//
//  Created by zc on 16/7/8.
//  Copyright © 2016年 oct. All rights reserved.
//

import SpriteKit
import UIKit

class HengPaiHarm: HarmArea {
    let harmCellCount: Int = 3
    
    override init() {
        super.init()
        self.harmcellArray = NSMutableArray()
    }
    override func initHarmArea() {
        
    }
    
    override func runHarmArea(toHarmPlayer: FightPlayer, originalConterPoint: CGPoint) {
        var tempPoint:CGPoint
        for i in 0 ..< harmCellCount {

            if i < harmCellCount/2 {
                tempPoint = CGPoint(x: originalConterPoint.x - fightMapCellSize.width * CGFloat((harmCellCount/2-i)), y: originalConterPoint.y)
            }else {
                tempPoint = CGPoint(x: originalConterPoint.x + fightMapCellSize.width * CGFloat((i-harmCellCount/2)), y: originalConterPoint.y)
            }
            if toHarmPlayer.fightMap.getCurrentPointMapCell(tempPoint) != nil {
                let harmObj = HarmObj()
                harmObj.harmCellIndex = toHarmPlayer.fightMap.getCurrentPointMapCell(tempPoint)
                harmObj.harmValue = 5
                self.harmcellArray?.addObject(harmObj)
                print("\(toHarmPlayer.roleName)--------\(harmObj.harmCellIndex)")
            }
        }
        
    }
}
