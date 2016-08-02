//
//  FogSystem.swift
//  OctGame
//
//  Created by zc on 16/7/26.
//  Copyright © 2016年 oct. All rights reserved.
//

import SpriteKit
import UIKit

class FogSystem: SkillSystem {
    var fogArray: NSMutableArray!
    var currentFog: Fog!
    var defaluePosition: CGPoint?
    var fogID: UInt32!
    var silentObjArray = NSMutableArray()
    override init() {
        super.init()
        self.fogArray = NSMutableArray()
        self.fogID = 0
        self.touchPointArray = NSMutableArray()
        self.bollGroup = BallCategory.fuzhu.rawValue + BallCategory.fuzhu.rawValue + BallCategory.jianzhu.rawValue
        self.isSilent = false
    }
    
    override func initSkill() {
        self.fogID = self.fogID+1
        let fog = Fog(size: SkillSize.fog, entityName: self.entityName, fogID: fogID)
        let player = (self.entity as! FightPlayer)
        if player.roleName == "fightPlayer" {
            player.scene?.saveSkill.saveSkillArray.append(fog)
            player.scene!.saveSkill.showCurrentSaveSkill()
            defaluePosition = fog.skillPosition
            player.sprite.parent?.addChild(fog)
        }
        self.fogArray.addObject(fog)
        self.currentFog = fog
    }
    
    func isSetFogSuccess(point: CGPoint) -> Bool? {
        let enemyMap = (self.entity as! FightPlayer).enemy.fightMap
        let rect = CGRect(x: enemyMap.mapArray.objectAtIndex(16).frame.origin.x-fightMapCellSize.width/2, y: enemyMap.mapArray.objectAtIndex(16).frame.origin.y-fightMapCellSize.height/2, width: fightMapCellSize.width*5, height: fightMapCellSize.height*4)
        if CGRectContainsPoint(rect, point) {
            self.currentFog.position = point
            return true
        }
        
        return nil
    }
    
    override func toucheBegan(touches: Set<UITouch>, withEvent event: UIEvent?, scene: FightScene) {
        let touchLocation = touches.first?.locationInNode(scene)
        self.touchPointArray.removeAllObjects()
        
        for temp in self.fogArray {
            if (temp as! Fog).isControl == true {
                //                let rect = CGRect(origin: CGPoint(x: (temp as! Wall).buildSprite.position.x-SkillSize.building.width, y: (temp as! Wall).buildSprite.position.y-SkillSize.building.height), size: CGSize(width: (temp as! Wall).buildSprite.frame.width*2, height: (temp as! Wall).buildSprite.frame.height*2))
                if CGRectContainsPoint((temp as! Fog).frame, touchLocation!) {
                    self.touchPointArray.addObject(NSValue.init(CGPoint: touchLocation!))
                    self.currentFog = temp as! Fog
                    self.defaluePosition = self.currentFog.skillPosition
                }
                
            }
        }
        
        if self.currentFog != nil {
            //if self.noLaunchBoom!.isControl == true {
//            let rect = CGRect(origin: CGPoint(x: self.currentFog!.position.x-SkillSize.fog.width, y: self.currentFog!.position.y-SkillSize.fog.height), size: CGSize(width: self.currentFog!.frame.width*2, height: self.currentFog!.frame.height*2))
            if CGRectContainsPoint(self.currentFog.frame, touchLocation!) {
                self.touchPointArray.addObject(NSValue.init(CGPoint: touchLocation!))
                self.currentFog.size = CGSize(width: fightMapCellSize.height*1.5, height: fightMapCellSize.height*1.5)
            }
            // }
        }
        
    }

    override func toucheMoved(touches: Set<UITouch>, withEvent event: UIEvent?, scene: FightScene) {
        if self.currentFog != nil {
            if self.currentFog!.isControl == true {
                if self.touchPointArray.count != 0 {
                    let point = (touches.first?.locationInNode(scene))!
                    self.touchPointArray.addObject(NSValue.init(CGPoint: point))
                    let oldPoint = (touches.first?.previousLocationInNode(scene))!
                    let distance = CGPoint(x: point.x-oldPoint.x, y: point.y-oldPoint.y)

                    let newPoint = CGPoint(x: self.currentFog!.position.x+distance.x, y: self.currentFog!.position.y+distance.y)
                    self.currentFog!.position = newPoint
      
                }
            }
        }
    }

    override func toucheEnded(touches: Set<UITouch>, withEvent event: UIEvent?, scene: FightScene) {
        if self.touchPointArray.count != 0 {
            let endPoint = (self.touchPointArray.lastObject!.CGPointValue)!
            var fogMapCellNum: Bool? = nil
            if self.isSilent == false {
                fogMapCellNum = isSetFogSuccess(endPoint)
            }
            if fogMapCellNum == true{
                
                self.currentFog!.isControl = false
                // var dict = Dictionary<String, AnyObject>()
                var dict = [String: AnyObject]()
                dict.updateValue(SkillName.fog.rawValue, forKey: "initSkill")
                let percentX = self.currentFog!.position.x / screenSize.width
                let percentY = (self.currentFog!.position.y-fightMapCellSize.height) / screenSize.height
                dict.updateValue(percentX, forKey: "percentX")
                dict.updateValue(percentY, forKey: "percentY")
                // scene.websocket.writeMessage(BTMessage(command: BTCommand.CastSpell, params: (self.entity as! FightPlayer).toReleaseSkill(dict)))
                scene.sock.send(BTCommand.CCastSpell, withParams: (self.entity as! FightPlayer).toReleaseSkill(dict))
                
                self.reckonFogOccupyArea(self.currentFog, disappear: false)
     
                var removeObjNum = 0
                for i in 0 ..< ((self.entity as! FightPlayer).scene?.saveSkill.saveSkillArray)!.count {
                    if let fog = ((self.entity as! FightPlayer).scene?.saveSkill.saveSkillArray)![i] as? Fog {
                        if fog.fogID == self.currentFog.fogID {
                            removeObjNum = i
                        }
                    }
                }
                (self.entity as! FightPlayer).scene?.saveSkill.saveSkillArray.removeAtIndex(removeObjNum)
            }else {
                self.currentFog.size = SkillSize.fog
                self.currentFog!.position = defaluePosition!
            }
        }
    }
    
    func reckonFogOccupyArea(fog: Fog, disappear: Bool) {
        let enemyMap = (self.entity as! FightPlayer).enemy.fightMap
        var occupyMapCellArray = [FTMapCell]()
        
        for temp in enemyMap.mapArray {
            let distance = ((temp as! FTMapCell).position.x - fog.position.x) * ((temp as! FTMapCell).position.x - fog.position.x) + ((temp as! FTMapCell).position.y - fog.position.y) * ((temp as! FTMapCell).position.y - fog.position.y)
            if UInt32(distance) <= UInt32((fog.size.width/2) * (fog.size.width/2)){
                occupyMapCellArray.append(temp as! FTMapCell)
            }
        }
        
        for tempOccupy in occupyMapCellArray {
            if let player = tempOccupy.obj as? FightPlayer {
                self.silentObjArray.addObject(player)
//                for skill in player.skillSystemArray {
//                    if disappear == true {
//                        skill.isSilent = false
//                    }else {
//                        skill.isSilent = true
//                    }
//                    
//                }
            }
            
            if let tower = tempOccupy.obj as? JianTower {
                self.silentObjArray.addObject(tower)
//                if disappear == true {
//                    ((self.entity as! FightPlayer).enemy.skillSystemForClass(JianTowerSystem.self)?.shootCloseRange(tower, scene: (self.entity as! FightPlayer).scene!))
//                }else {
                    tower.buildSprite.removeActionForKey("zidan")
               // }
                
            }
        }
        let removeObj = NSMutableArray()
        for tempSilent in self.silentObjArray {
            if disappear == false {
                if let player = tempSilent as? FightPlayer {
                    var hasPlayer = false
                    for tempOccupy in occupyMapCellArray {
                        if Int(tempOccupy.position.x) == Int(player.sprite.position.x) && Int(tempOccupy.position.y) == Int(player.sprite.position.y){
                            hasPlayer = true
                        }
                    }
                    for skill in player.skillSystemArray {
                        if hasPlayer == true {
                            skill.isSilent = true
                        }else {
                            skill.isSilent = false
                            
                        }
                        
                    }
                    if hasPlayer == false {
                        removeObj.addObject(player)
                    }
                }
                
                
            }else {
                if let tower = tempSilent as? JianTower {
                    if tower.HP > 0 {
                        ((self.entity as! FightPlayer).enemy.skillSystemForClass(JianTowerSystem.self)?.shootCloseRange(tower, scene: (self.entity as! FightPlayer).scene!))
                    }
                }else if let player = tempSilent as? FightPlayer {
                
                    for skill in player.skillSystemArray {
                        skill.isSilent = false
                    }
                }
            }
            
        }
        if disappear == true {
            self.silentObjArray.removeAllObjects()
        }else {
            for temp in removeObj {
                self.silentObjArray.removeObject(temp)
            }
        }
        removeObj.removeAllObjects()
    }
    
    func silentFogOccupyArea(fog: Fog,disappear: Bool) {
        let enemyMap = (self.entity as! FightPlayer).enemy.fightMap
        var occupyMapCellArray = [FTMapCell]()
        
        for temp in enemyMap.mapArray {
            let distance = ((temp as! FTMapCell).position.x - fog.position.x) * ((temp as! FTMapCell).position.x - fog.position.x) + ((temp as! FTMapCell).position.y - fog.position.y) * ((temp as! FTMapCell).position.y - fog.position.y)
            if UInt32(distance) <= UInt32((fog.size.width/2) * (fog.size.width/2)){
                occupyMapCellArray.append(temp as! FTMapCell)
            }
        }
    }
    override func checkState(time: NSTimeInterval) {
        let removeArray = NSMutableArray()
        for temp in self.fogArray {
            if (temp as! Fog).isControl == false {
                if (temp as! Fog).time >= 10 {
                    (temp as! Fog).isRemove = true
                     self.reckonFogOccupyArea((temp as! Fog), disappear: true)
                    
                }else {
                    if (temp as! Fog).oneTime == true {
                        (temp as! Fog).time = (temp as! Fog).time + (temp as! Fog).perTime
                        (temp as! Fog).oneTime = false
                        
                    }else {
                       (temp as! Fog).time = (temp as! Fog).time + time - (temp as! Fog).perTime
                    }
                    (temp as! Fog).perTime = time
                    self.reckonFogOccupyArea((temp as! Fog), disappear: false)
                    
                    
                }
            }
        }
        for temp in self.fogArray {
            if (temp as! Fog).removeFog() == true {
                removeArray.addObject(temp)
            }
            
        }
        
        for removeTemp in removeArray {
            self.fogArray.removeObject(removeTemp)
        }

    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
